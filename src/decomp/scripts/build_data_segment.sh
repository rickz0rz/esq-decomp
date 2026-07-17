#!/bin/bash
#
# build_data_segment.sh -- Phase-3 data segment for the whole-program C link.
#
# Assembles ALL of src/data (+ equate/macro includes) into one linkable object,
# exporting every data symbol the restored C corpus references (with a _-prefixed
# alias for the SAS/C C side). Restored C compiled with `sc DATA=FAR` links
# against this by absolute address (no near-data/A4/__MERGED juggling).
#
# A4-relative globals: the original reaches one storage location by MULTIPLE names
# (e.g. Global_DosLibrary == Global_REF_DOS_LIBRARY_2 @ A4+22832). Those A4 names
# must land at the exact near-data offset. vasm DROPS the offset when XDEF'ing an
# equate `label+const`, so instead we reconstruct the near-data as a single blob
# (reconstruct_near_data.py) with real labels placed at the live assembly PC (which
# export correctly) at every A4 alias offset, relocs re-emitted as dc.l addends.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"
VASM="${VASM_BIN:-$HOME/Downloads/vasm/vasmm68k_mot}"
OUT="build/decomp/phase3"; mkdir -p "$OUT"

# 1. export list: every src/data label referenced via `extern` in the corpus
python3 - "$OUT/dataexports.i" <<'PY'
import sys,os,re,glob
out=sys.argv[1]
ROOT=os.getcwd(); DATA=os.path.join(ROOT,"src","data"); SASC=os.path.join(ROOT,"src","decomp","sas_c")
defined=set()
for p in glob.glob(os.path.join(DATA,"*.s")):
    for line in open(p,encoding="utf-8",errors="replace"):
        m=re.match(r'^([A-Za-z_]\w*)\s*:',line)
        if m: defined.add(m.group(1))
for rel in ("src/lvo-offsets.s","src/hardware-addresses.s","src/structs.s"):
    p=os.path.join(ROOT,rel)
    if not os.path.exists(p): continue
    for line in open(p,encoding="utf-8",errors="replace"):
        m=re.match(r'^([A-Za-z_]\w*)\s*(?::|=|\s+EQU\b)',line)
        if m: defined.add(m.group(1))
refd=set(); cdefined=set()
for p in glob.glob(os.path.join(SASC,"*.c")):
    src=re.sub(r'/\*.*?\*/','',open(p,encoding="utf-8",errors="replace").read(),flags=re.DOTALL)
    src=re.sub(r'//[^\n]*','',src)
    for line in src.splitlines():
        if 'extern' in line:
            for m in re.finditer(r'\bextern\b[^;]*?\b([A-Za-z_]\w*)\s*(?:\[|\(|;|,)',line):
                refd.add(m.group(1))
        elif line[:1] not in (' ','\t','#','}','/') and '(' not in line:
            m=re.match(r'^[A-Za-z_][\w \t]*?\b([A-Za-z_]\w*)\s*(?:\[[^\]]*\])?\s*[;=]',line)
            if m: cdefined.add(m.group(1))
open(os.path.join(ROOT,"build/decomp/phase3/cdefined.txt"),"w").write("\n".join(sorted(cdefined)))
export=sorted((refd & defined) - cdefined)
export=[s for s in export if not s.startswith("_LVO")]
with open(out,"w") as f:
    for s in export: f.write(f"    XDEF {s}\n    XDEF _{s}\n")
    for s in export: f.write(f"_{s} = {s}\n")
print(f"exports: {len(export)} symbols (excluded {len((refd&defined)&cdefined)} C-defined)")
PY

# --- pre-data include preamble (constants + the near-data exports) ---
preamble() {
  echo 'includeCustomAriAssembly = 0'
  for f in lvo-offsets hardware-addresses structs macros string-macros text-formatting; do
    echo "    include \"$f.s\""
  done
  echo '    include "interrupts/constants.s"'
  echo '    include "../build/decomp/phase3/dataexports.i"'
}

# 1b. Pass 1: assemble the near-data ALONE (XDEF'd via dataexports.i so every
# referenced label appears in HUNK_EXT) to capture its bytes / relocs / label
# offsets for reconstruction.
{
  preamble
  echo '    SECTION datasegment,DATA'
  grep -oE 'include "data/[a-z0-9_]+\.s"' src/Prevue.asm | sed 's/^/    /'
} > "$OUT/datasegment_pass1.asm"
"$VASM" -Fhunk -I src -o "$OUT/datasegment_pass1.o" "$OUT/datasegment_pass1.asm" >/dev/null 2>&1

# 1c. Reconstruct the near-data blob with A4-name labels at exact offsets.
python3 src/decomp/scripts/reconstruct_near_data.py \
        "$OUT/datasegment_pass1.o" "$OUT/datasegment_blob.asm"

# 2. Final datasegment: preamble (equates + _X=X aliases) + reconstructed blob.
{
  preamble
  cat "$OUT/datasegment_blob.asm"
} > "$OUT/datasegment.asm"
"$VASM" -Fhunk -I src -o "$OUT/datasegment.o" "$OUT/datasegment.asm"
echo "built $OUT/datasegment.o ($(stat -f%z "$OUT/datasegment.o") bytes)"
