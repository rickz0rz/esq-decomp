#!/usr/bin/env python3
"""Find `<name>_Return` epilogues that DO REAL WORK, and whose C restoration drops it.

    python3 tools/return_epilogue_audit.py            # the manifest
    python3 tools/return_epilogue_audit.py --all      # every restoration

WHY THIS EXISTS

AGENTS.md already records that a `_Return` label makes refbytes.py stop early:
the disassembly gives a branched-to epilogue its own exported label, and
refbytes extracts label to label, so `Foo`'s reference ENDS BEFORE its own
epilogue. That note is about SIZE -- "add the epilogue back before judging the
delta".

The size is the harmless half. The dangerous half is that an epilogue can
CONTAIN REAL WORK, and a restoration written against the truncated reference
never sees it.

ESQIFF2_ApplyIncomingStatusPacket is the case that cost a day. Its epilogue is:

    ESQIFF2_ApplyIncomingStatusPacket_Return:
        MOVE.W  #1,_ESQIFF_StatusPacketReadyFlag
        MOVEM.L (A7)+,D2/D6-D7/A3
        RTS

The restoration reproduced all 266 bytes of the function and none of the 14
bytes of the epilogue, so it never set the flag. The dispatcher's 'C' arm
discards every channel group record while that flag is 0, so THE PROGRAM
RECEIVED NO LISTINGS AT ALL -- and every byte gate, audit and screen-based
harness passed, because the failure needs a real listings feed to show.

WHAT IT FLAGS

An epilogue instruction that is not pure stack-unwinding. Unwinding is MOVEM,
UNLK, RTS/RTE/RTR, `MOVE.L (A7)+,An`, and the ADDQ/LEA forms that pop a frame.
Anything else -- a store to a global, a call, arithmetic -- is work the caller
depends on, and it must appear in the C restoration.

The report says whether the restoration MENTIONS each symbol the epilogue
writes. A mention is not proof it is right, but a MISSING mention is proof it
is wrong.
"""
import os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CDIR = os.path.join(ROOT, 'src', 'c')

# Instructions that only unwind the frame and return.
UNWIND = re.compile(
    r'^(MOVEM\.[LW]\s+\(A7\)\+|UNLK|RTS|RTE|RTR|'
    r'MOVE\.L\s+\(A7\)\+,A[0-7]|MOVEM\.[LW]\s+-?\d*\(A5\)|'
    r'ADDQ\.[LW]\s+#\d+,A7|ADDA\.[LW]\s+#[^,]+,A7|LEA\s+-?\$?[0-9a-fA-F]*\(A7\),A7)',
    re.I)

LABEL = re.compile(r'^([A-Za-z_][\w.]*):')


def epilogues():
    """Yield (module, name, [instruction lines]) for every *_Return label."""
    for dp, _, fs in os.walk(os.path.join(ROOT, 'src', 'modules')):
        for fn in sorted(fs):
            if not fn.endswith('.s'):
                continue
            path = os.path.join(dp, fn)
            rel = os.path.relpath(path, os.path.join(ROOT, 'src'))
            lines = open(path, errors='replace').read().split('\n')
            i = 0
            while i < len(lines):
                m = LABEL.match(lines[i])
                if not m or not m.group(1).endswith('_Return'):
                    i += 1
                    continue
                body = []
                j = i + 1
                while j < len(lines):
                    text = lines[j].split(';')[0].rstrip()
                    if not text.strip():
                        j += 1
                        continue
                    if LABEL.match(text):
                        break
                    op = text.strip()
                    body.append(op)
                    if re.match(r'^(RTS|RTE|RTR)\b', op, re.I):
                        break
                    j += 1
                yield rel, m.group(1), body
                i = j + 1


def restores_map():
    """label -> C file, honouring multi-line RESTORES: lists."""
    out = {}
    for fn in sorted(os.listdir(CDIR)):
        if not fn.endswith('.c') or fn.endswith('_merged.c'):
            continue
        txt = open(os.path.join(CDIR, fn), errors='replace').read()
        m = re.search(r'RESTORES:\s*(.+)', txt)
        if not m:
            continue
        names = m.group(1).strip()
        rest = txt[m.end():].split('\n')
        for line in (rest[1:] if names.endswith(',') else []):
            bare = line.strip().lstrip('*').strip()
            if not re.match(r'^[A-Za-z_]\w*(\s*,\s*[A-Za-z_]\w*)*,?$', bare):
                break
            names += ' ' + bare
            if not bare.endswith(','):
                break
        for n in re.split(r'[,\s]+', names):
            n = n.strip().lstrip('_')
            if n and re.match(r'^[A-Za-z_]\w*$', n):
                out.setdefault(n, fn)
    return out


def manifest_files():
    out = set()
    p = os.path.join(CDIR, 'replacements-all.txt')
    if os.path.exists(p):
        for line in open(p):
            if line.strip() and not line.startswith('#'):
                parts = line.split()
                if len(parts) > 1:
                    out.add(os.path.basename(parts[1]))
    return out


def main():
    every = '--all' in sys.argv
    restores = restores_map()
    inman = manifest_files()
    bad = 0
    checked = 0

    for mod, name, body in epilogues():
        # A move INTO D0 in an epilogue is the RETURN VALUE, which C emits by
        # itself. Counting it as work made 14 of 16 hits noise on the first run
        # and would have buried the one real case.
        work = [op for op in body
                if not UNWIND.match(op)
                and not re.match(r'^MOVE[QA]?\.[BWL]\s+.+,\s*D0\s*$', op, re.I)]
        if not work:
            continue
        owner = name[:-len('_Return')].lstrip('_')
        cfile = restores.get(owner)
        if not every and cfile and cfile not in inman:
            continue
        checked += 1

        # Symbols the epilogue writes: the destination of a store to a global.
        syms = set()
        for op in work:
            m = re.match(r'^MOVE[QA]?\.[BWL]\s+[^,]+,\s*(_?[A-Za-z]\w*)\s*$', op, re.I)
            if m and not re.match(r'^[AD][0-7]$', m.group(1), re.I):
                syms.add(m.group(1).lstrip('_'))

        status = 'NO RESTORATION'
        if cfile:
            ctext = open(os.path.join(CDIR, cfile), errors='replace').read()
            missing = [s for s in syms if s not in ctext]
            if syms and missing:
                status = 'MISSING: ' + ','.join(sorted(missing))
            elif syms:
                status = 'ok (mentions ' + ','.join(sorted(syms)) + ')'
            else:
                status = 'review (epilogue does work, no simple store)'
        if status.startswith('ok'):
            continue
        bad += 1
        print('%s' % name)
        print('   module: %s' % mod)
        print('   C file: %s' % (cfile or '-'))
        for op in work:
            print('     %s' % op)
        print('   -> %s' % status)
        print()

    print('%d epilogue(s) that do real work; %d need attention'
          % (checked, bad))
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
