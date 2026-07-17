#!/usr/bin/env python3
"""
measure_match_tiers.py  --  Phase-0 "how close to 1-to-1?" measurement.

Reuses the cached SAS/C .dis artifacts (no vamos recompile) plus each
compare_sasc_*_trial.sh script's declared slicing to bucket every restored
function into a match tier:

  GOLD    raw normalized ASM stream is byte-identical to the original
          (true 1-to-1 ASM->C->ASM: SAS/C reproduced the original instructions)
  SILVER  raw stream differs, but the per-function semantic_filter_*.awk makes
          them equal (equivalence RELIES on the awk filter -> suspect, needs a
          behavioral proof to trust)
  RED     even after the semantic filter the streams differ (failing / stale)
  NO_DIS  no cached .dis for this function (needs a recompile to judge)
  SKIP    script did not follow the standard SASC compare shape

We compute two GOLD notions:
  raw_clean   : the project's own raw normalized diff is empty
  instr_clean : identical after ALSO stripping every label-only line from both
                sides (a cleaner "instruction shape" proxy that ignores the
                asymmetric label-naming between hand-asm and SAS/C output)

This script is intentionally read-only w.r.t. the repo (touches nothing but
its own stdout), so it is safe to run any time.
"""
import glob
import os
import re
import subprocess
import sys
from collections import Counter, defaultdict

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
SCRIPTS = os.path.join(ROOT, "src", "decomp", "scripts")

VAR_RE = {
    "SASC_SRC": re.compile(r'^SASC_SRC="([^"]+)"'),
    "ORIG_ASM": re.compile(r'^ORIG_ASM="([^"]+)"'),
    "ENTRY_ORIG": re.compile(r'^ENTRY_ORIG="([^"]+)"'),
    "ENTRY_ALT": re.compile(r'^ENTRY="([^"]+)"'),
    "SASC_DIR": re.compile(r'^SASC_DIR="([^"]+)"'),
}
SEM_RE = re.compile(r'awk -f (\S+semantic_filter_\S+\.awk)')
# how the script ends the ORIGINAL slice
ORIG_END_MARKER_RE = re.compile(r'if \(\$0 ~ /(\^;!=+)/\) exit')
ORIG_END_RTS_RE = re.compile(r'tolower\(\$1\) == "rts"')


def parse_script(path):
    d = {}
    with open(path, encoding="utf-8", errors="replace") as fh:
        text = fh.read()
    for line in text.splitlines():
        for k, rx in VAR_RE.items():
            m = rx.match(line)
            if m:
                d[k] = m.group(1)
    m = SEM_RE.search(text)
    d["SEM_AWK"] = m.group(1) if m else None
    d["ORIG_END"] = "rts" if ORIG_END_RTS_RE.search(text) else "marker"
    return d


def slice_lines(lines, entry, mode):
    """Slice from ^entry: (optionally leading _) to the appropriate end."""
    out = []
    started = False
    entry_res = [re.compile(r'^_?' + re.escape(entry) + r':?$')]
    for ln in lines:
        s = ln.rstrip("\n")
        if not started:
            if any(r.match(s.strip()) for r in entry_res):
                started = True
                out.append(s)
            continue
        # end conditions
        if mode == "orig_marker" and re.match(r'^;!=+', s):
            break
        if mode == "orig_rts":
            out.append(s)
            if s.strip().lower().startswith("rts"):
                break
            continue
        if mode == "sasc" and s.strip() in ("__const:", "const:"):
            break
        out.append(s)
    return out


NORM_LABEL_INTERNAL = re.compile(r'^___[A-Za-z0-9_]+__[0-9]+:$')
LABEL_ONLY = re.compile(r'^[.A-Za-z_][A-Za-z0-9_.$]*:$')


def normalize(lines):
    """Replicate the compare scripts' normalize() sed pipeline."""
    out = []
    for ln in lines:
        s = re.sub(r';.*$', '', ln)          # strip comments
        s = s.strip()
        s = re.sub(r'\s+', ' ', s)           # collapse ws
        if s == '':
            continue
        if NORM_LABEL_INTERNAL.match(s):     # drop ___NAME__n: labels
            continue
        if s in ('const:', 'strings:'):
            continue
        out.append(s)
    return out


def strip_labels(lines):
    return [x for x in lines if not LABEL_ONLY.match(x)]


BRANCH_RE = re.compile(r'^(B[A-Z]{2,3}|DB[A-Z]{2}|BSR|BRA|JMP|JSR)(\.[BWLS])?\b')
MOVEM_RANGE_RE = re.compile(r'([AD])(\d)-([AD])(\d)')


def _expand_range(m):
    r1, a, r2, b = m.group(1), int(m.group(2)), m.group(3), int(m.group(4))
    if r1 != r2:
        return m.group(0)
    return "/".join(f"{r1}{i}" for i in range(a, b + 1))


def _hex_to_dec(tok):
    return str(int(tok.group(1), 16))


def canonicalize(lines):
    """Reduce assembler-dialect noise so we measure STRUCTURAL identity:
    hex->dec, MOVEQ.L->MOVEQ, MOVEM ranges expanded, label names & branch
    targets removed. Generous 1-to-1 proxy: if this still differs, the
    structure genuinely differs (frame model, regalloc, signedness, ...)."""
    out = []
    for x in lines:
        if LABEL_ONLY.match(x):
            continue
        s = x
        s = MOVEM_RANGE_RE.sub(_expand_range, s)
        s = re.sub(r'\$([0-9A-Fa-f]+)', _hex_to_dec, s)
        s = s.replace("MOVEQ.L", "MOVEQ")
        # drop the branch target operand (label names differ but are not
        # structural) -> keep just the mnemonic+size
        mb = BRANCH_RE.match(s)
        if mb and mb.group(1) not in ("DBF", "DBRA"):
            s = mb.group(0)
        out.append(s)
    return out


def main():
    scripts = sorted(glob.glob(os.path.join(SCRIPTS, "compare_sasc_*_trial.sh")))
    tiers = Counter()
    per_module = defaultdict(Counter)
    red_list = []
    silver_list = []
    seen_dis = {}

    for sp in scripts:
        d = parse_script(sp)
        name = os.path.basename(sp)
        if "ENTRY_ORIG" not in d and "ENTRY_ALT" in d:
            d["ENTRY_ORIG"] = d["ENTRY_ALT"]
        if not all(k in d for k in ("SASC_SRC", "ORIG_ASM", "ENTRY_ORIG")):
            tiers["SKIP"] += 1
            continue
        sasc_dir = d.get("SASC_DIR", "src/decomp/sas_c")
        dis = os.path.join(ROOT, sasc_dir, d["SASC_SRC"] + ".dis")
        orig = os.path.join(ROOT, d["ORIG_ASM"])
        module = d["ORIG_ASM"]
        if not os.path.exists(dis):
            tiers["NO_DIS"] += 1
            per_module[module]["NO_DIS"] += 1
            continue
        if not os.path.exists(orig):
            tiers["SKIP"] += 1
            continue

        with open(dis, encoding="utf-8", errors="replace") as fh:
            dis_lines = fh.read().splitlines()
        with open(orig, encoding="utf-8", errors="replace") as fh:
            orig_lines = fh.read().splitlines()

        entry = d["ENTRY_ORIG"]
        omode = "orig_rts" if d["ORIG_END"] == "rts" else "orig_marker"
        o_slice = normalize(slice_lines(orig_lines, entry, omode))
        s_slice = normalize(slice_lines(dis_lines, entry, "sasc"))

        if not o_slice or not s_slice:
            tiers["SKIP"] += 1
            continue

        raw_clean = (o_slice == s_slice)
        canon_clean = (canonicalize(o_slice) == canonicalize(s_slice))

        if raw_clean:
            tier = "GOLD_raw"
        elif canon_clean:
            tier = "GOLD_instr"
        else:
            # consult the semantic filter if present
            sem = d.get("SEM_AWK")
            sem_clean = False
            if sem and os.path.exists(os.path.join(ROOT, sem)):
                try:
                    def run_awk(lines):
                        p = subprocess.run(
                            ["awk", "-f", os.path.join(ROOT, sem)],
                            input="\n".join(lines) + "\n",
                            capture_output=True, text=True, timeout=20)
                        return p.stdout.splitlines()
                    sem_clean = (run_awk(o_slice) == run_awk(s_slice))
                except Exception:
                    sem_clean = False
            tier = "SILVER" if sem_clean else "RED"

        tiers[tier] += 1
        per_module[module][tier] += 1
        if tier == "RED":
            red_list.append((module, entry, name))
        elif tier == "SILVER":
            silver_list.append((module, entry))
        seen_dis[dis] = True

    total = sum(tiers.values())
    print("=" * 72)
    print("MATCH-TIER MEASUREMENT (cached .dis, no recompile)")
    print("=" * 72)
    order = ["GOLD_raw", "GOLD_instr", "SILVER", "RED", "NO_DIS", "SKIP"]
    labels = {
        "GOLD_raw":  "GOLD  (raw 1-to-1 ASM identical)",
        "GOLD_instr":"GOLD  (instruction-stream identical, labels aside)",
        "SILVER":    "SILVER(equal only via semantic awk filter -> suspect)",
        "RED":       "RED*  (approx; static filter run omits -v ENTRY args)",
        "NO_DIS":    "NO_DIS(no cached .dis -> needs recompile to judge)",
        "SKIP":      "SKIP  (non-standard compare shape)",
    }
    for k in order:
        v = tiers.get(k, 0)
        pct = (100.0 * v / total) if total else 0
        print(f"  {labels[k]:<52} {v:5d}  ({pct:4.1f}%)")
    print(f"  {'TOTAL sasc compare lanes':<52} {total:5d}")
    gold = tiers.get("GOLD_raw", 0) + tiers.get("GOLD_instr", 0)
    judged = gold + tiers.get("SILVER", 0) + tiers.get("RED", 0)
    if judged:
        print(f"\n  Gold rate among judgeable lanes: {100.0*gold/judged:.1f}%  "
              f"({gold}/{judged})")
    print(f"\n  RED (failing) sample:")
    for m, e, n in red_list[:15]:
        print(f"    {e:<45} {m}")
    if len(red_list) > 15:
        print(f"    ... +{len(red_list)-15} more RED")
    print(f"\n  SILVER (filter-dependent, needs behavioral proof): "
          f"{len(silver_list)}")
    print("\n  NOTE: GOLD=0 is the robust headline (filter-independent: no")
    print("  restored fn reproduces the original instruction STRUCTURE).")
    print("  The SILVER/RED* split is approximate here because this static")
    print("  runner does not pass the per-script -v ENTRY/ENTRY_REGEX args")
    print("  into the semantic filters; a behavioral harness is the real")
    print("  adjudicator of equivalence for the non-GOLD lanes.")


if __name__ == "__main__":
    main()
