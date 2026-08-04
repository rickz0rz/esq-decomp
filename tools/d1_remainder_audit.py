#!/usr/bin/env python3
"""Find every caller that reads the REMAINDER out of D1 after a divide helper.

    python3 tools/d1_remainder_audit.py [binary] [map]

WHY THIS EXISTS

`MATH_DivS32`/`__CXD33` and `MATH_DivU32`/`__CXD22` return TWO values: the
quotient in D0 and the sign-corrected remainder in D1. SAS/C uses that for `%`:

    long r(long a, long b) { return a % b; }
        -> BSR.W __CXD33 / MOVE.L D1,D0
    long q(long a, long b) { return a / b; }
        -> BSR.W __CXD33                       (D0 used as-is)

A C function returns ONE value. So a C definition of these helpers, or a C
forwarding thunk in front of one, cannot preserve D1 -- and every caller that
reads the remainder silently computes garbage. **No byte gate and no other audit
can see this**, because the caller's own bytes are correct and the helper's own
bytes are correct. Only the pairing is wrong.

This audit is therefore the precondition for moving the helpers to C. It must
report ZERO before `src/modules/submodules/unknown22_p0.s` may be replaced.

WHAT IT CHECKS

It scans the LINKED image, not the sources, because a module replaced by a C
file never links -- auditing `src/**.s` reports sites that are not in the build.
For each call to a divide helper it walks forward and classifies the first
instruction that touches D1:

  READ   D1 appears as a source, or as the destination of a read-modify-write
         (TST.L D1, MOVE.L D1,x, SUBQ #1,D1, ASL.L #2,D1, NEG.L D1)
  KILL   D1 is fully overwritten from somewhere else (MOVEQ #n,D1, MOVE.L x,D1)

A KILL means the remainder was never wanted. Only a READ is a dependency.
Walking stops at the first branch, because past that the analysis would need a
real control-flow pass and this tool must not guess.
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))

try:
    import capstone
except ImportError:
    sys.exit('needs capstone: /tmp/.capvenv/bin/pip install capstone\n'
             'then run with /tmp/.capvenv/bin/python')

HELPERS = ('_MATH_DivS32', '__CXD33', '_MATH_DivU32', '__CXD22', 'MATH_DivU32')

# instructions that READ D1 when D1 is the destination operand
RMW = ('add', 'sub', 'and', 'or', 'eor', 'asl', 'asr', 'lsl', 'lsr', 'rol',
       'ror', 'neg', 'not', 'ext', 'swap', 'mul', 'div', 'cmp', 'tst', 'addi',
       'subi', 'andi', 'ori', 'eori', 'addq', 'subq', 'addx', 'subx', 'abcd',
       'sbcd', 'nbcd', 'bchg', 'bclr', 'bset', 'btst', 'move.b')


def load_code(path):
    import verify_restorations as vr
    return vr.load_hunks(path)[0]['img']


def code_symbols(mappath):
    """{name: address} for the CODE section.

    vlink writes `  0xADDR NAME: global reloc, size 0` -- the ADDRESS FIRST.
    An earlier version of this function expected name-then-address, matched
    nothing, and every finding was reported against an unnamed address.
    """
    lines = open(mappath, errors='replace').read().split('\n')
    i0 = next(i for i, l in enumerate(lines) if l.startswith('Symbols of S_0'))
    try:
        i1 = next(i for i, l in enumerate(lines) if l.startswith('Symbols of S_1'))
    except StopIteration:
        i1 = len(lines)
    out = {}
    for l in lines[i0 + 1:i1]:
        m = re.match(r'\s+0x([0-9a-fA-F]+)\s+(\S+?):', l)
        if m:
            out.setdefault(m.group(2), int(m.group(1), 16))
    return out


def contributors(mappath):
    """[(lo, hi, object-name)] from the map's address-range list.

    Assembly contributors keep their own filename here, so a site that survives
    this audit can be traced to the module it lives in. Every C object is called
    `u.c`, so a C site reports only as C.
    """
    out = []
    for ln in open(mappath, errors='replace'):
        m = re.match(r'\s+([0-9a-f]{8}) - ([0-9a-f]{8}) (\S+)\(', ln)
        if m:
            out.append((int(m.group(1), 16), int(m.group(2), 16), m.group(3)))
    return sorted(out)


def classify(ins):
    """READ, KILL or None for what `ins` does to D1."""
    ops = ins.op_str
    if not re.search(r'\bd1\b', ops):
        return None
    mn = ins.mnemonic.lower()
    base = mn.split('.')[0]
    parts = [p.strip() for p in ops.split(',')]
    # single-operand forms
    if len(parts) == 1:
        if base in ('clr',):
            return 'KILL'
        return 'READ'                       # tst, neg, not, ext, swap ...
    src, dst = parts[0], parts[-1]
    d1_src = bool(re.search(r'\bd1\b', src))
    d1_dst = bool(re.search(r'\bd1\b', dst))
    if d1_src:
        return 'READ'                       # D1 feeds something
    if d1_dst:
        if base in ('move', 'movea', 'moveq', 'lea', 'clr'):
            return 'KILL'                   # fully overwritten
        return 'READ'                       # read-modify-write
    return None


def scan_object(objpath):
    """[(offset, helper, instruction)] for D1 reads in ONE unlinked object.

    In an object the call target is a relocation, so the helper is named in the
    xref table rather than reachable by address. An xref of size 2 at offset `o`
    is the operand word of a BSR.W, so the next instruction starts at o + 2.
    """
    out = subprocess.run([sys.executable, os.path.join(ROOT, 'tools/objbytes.py'),
                          objpath], capture_output=True, text=True).stdout
    m = re.search(r'^bytes: (\S+)', out, re.M)
    if not m:
        return []
    code = bytes.fromhex(m.group(1))
    md = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_BIG_ENDIAN)
    md.detail = False
    found = []
    for name, lst in re.findall(r'(\w+)@\[([^\]]*)\]', out):
        if name not in ('__CXD22', '__CXD33'):
            continue
        for off, size in re.findall(r"\('(0x[0-9a-f]+)',\s*(\d+)\)", lst):
            # size 2 -> BSR.W, operand is one word, next instruction at off+2.
            # size 4 -> JSR abs.L, which is what CODE=FAR emits, so the operand
            # is a longword and the next instruction is at off+4. Filtering on
            # size 2 alone found NOTHING on a CODE=FAR build, which is the build
            # that matters.
            sz = int(size)
            if sz not in (2, 4):
                continue
            after = int(off, 16) + sz
            for ins in md.disasm(code[after:after + 24], after):
                v = classify(ins)
                mn = ins.mnemonic.lower()
                if v == 'READ':
                    found.append((after, name, f'{ins.mnemonic} {ins.op_str}'))
                    break
                if v == 'KILL':
                    break
                if mn.startswith(('b', 'j', 'dbf', 'db', 'rts', 'rte')):
                    break
    return sorted(found)


def check_source(cfile):
    """Compile one .c with the project options and report its D1 reads."""
    import tempfile
    import shutil
    work = tempfile.mkdtemp(prefix='d1aud.')
    try:
        shutil.copy(cfile, os.path.join(work, 'u.c'))
        for h in os.listdir(os.path.join(ROOT, 'src/c')):
            if h.endswith('.h'):
                shutil.copy(os.path.join(ROOT, 'src/c', h), work)
        cmd = ('. /Users/rj/Downloads/vamos/bin/activate 2>/dev/null; '
               f'vamos --volume work:{work} sc:c/sc NOSTKCHK DATA=FAR CODE=FAR '
               'CODENAME=S_0 DATANAME=S_1 IDLEN=128 DEFINE=ESQ_EXACT=1 '
               'OBJNAME=work:u.o work:u.c')
        subprocess.run(['bash', '-c', cmd], capture_output=True, text=True)
        obj = os.path.join(work, 'u.o')
        if not os.path.exists(obj):
            print(f'{os.path.basename(cfile)}: COMPILE FAILED')
            return -1
        hits = scan_object(obj)
        for off, name, ins in hits:
            print(f'  0x{off:04x}  {name}, then {ins}')
        print(f'{os.path.basename(cfile)}: {len(hits)} D1 read(s)')
        return len(hits)
    finally:
        shutil.rmtree(work, ignore_errors=True)


def main():
    if len(sys.argv) > 2 and sys.argv[1] == '--src':
        rc = 0
        for f in sys.argv[2:]:
            rc |= (check_source(f) > 0)
        return rc
    binp = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, 'build/ESQ')
    mapp = sys.argv[2] if len(sys.argv) > 2 else os.path.join(ROOT, 'build/ESQ.map')
    if not os.path.exists(binp) or not os.path.exists(mapp):
        sys.exit(f'need {binp} and {mapp} -- build with C_REPLACEMENTS first')

    code = load_code(binp)
    sym = code_symbols(mapp)
    contrib = contributors(mapp)

    def owner_obj(addr):
        for lo, hi, name in contrib:
            if lo <= addr < hi:
                return name
        return '?'
    targets = {sym[h] for h in HELPERS if h in sym}

    # The map lists a symbol only when something RELOCATES against it. Calls to
    # these helpers are same-section PC-relative and carry no relocation, so the
    # helpers themselves are absent from the symbol list. Recover their
    # addresses from the object that defines them: the map's `Files:` section
    # gives that object's placement, and the object's own XDEF table gives each
    # label's offset inside it. Byte-signature matching was tried first and is
    # not safe -- ESQ_FARCALLS rewrites branches, so the bytes move.
    # An assembly contributor keeps its own name in the map, so it can be matched
    # directly. Only the C objects are all called `u.c`, and none of the helpers
    # live in one.
    for ln in open(mapp, errors='replace'):
        m = re.match(r'\s+(\S+\.asm):\s+S_0\s+([0-9a-f]+)\(', ln)
        if not m or 'unknown22_p0' not in m.group(1):
            continue
        base = int(m.group(2), 16)
        obj = os.path.join(ROOT, 'build/obj', m.group(1)[:-4] + '.o')
        if not os.path.exists(obj):
            continue
        out = subprocess.run([sys.executable,
                              os.path.join(ROOT, 'tools/objbytes.py'), obj],
                             capture_output=True, text=True).stdout
        for name, off in re.findall(r'(\w+)@(0x[0-9a-f]+)', out):
            if name in HELPERS:
                targets.add(base + int(off, 16))
                sym.setdefault(name, base + int(off, 16))

    if not targets:
        sys.exit('could not locate any divide helper in the linked image.\n'
                 'The map and build/objlist must come from the SAME link.')
    byaddr = {}
    for n, a in sym.items():
        byaddr.setdefault(a, n)
    owner = sorted((a, n) for n, a in sym.items())

    def enclosing(addr):
        lo, name = None, '?'
        for a, n in owner:
            if a <= addr:
                lo, name = a, n
            else:
                break
        return name

    # Scan for the CALL OPCODES rather than disassembling the whole hunk. A
    # linear sweep desyncs on the embedded jump tables and misses most calls --
    # it reported 0 of 106 before this was changed. Only the short window AFTER
    # each call is disassembled, and that starts on a known boundary.
    md = capstone.Cs(capstone.CS_ARCH_M68K, capstone.CS_MODE_BIG_ENDIAN)
    md.detail = False

    def s16(v):
        return v - 0x10000 if v & 0x8000 else v

    def s8(v):
        return v - 0x100 if v & 0x80 else v

    calls = 0
    reads = []
    n = len(code)
    i = 0
    while i + 1 < n:
        op = int.from_bytes(code[i:i + 2], 'big')
        tgt = after = None
        if op == 0x4eb9 and i + 6 <= n:                       # JSR abs.L
            tgt, after = int.from_bytes(code[i + 2:i + 6], 'big'), i + 6
        elif op == 0x4eba and i + 4 <= n:                     # JSR (d16,PC)
            tgt, after = i + 2 + s16(int.from_bytes(code[i + 2:i + 4], 'big')), i + 4
        elif op == 0x6100 and i + 4 <= n:                     # BSR.W
            tgt, after = i + 2 + s16(int.from_bytes(code[i + 2:i + 4], 'big')), i + 4
        elif (op >> 8) == 0x61 and (op & 0xff) not in (0x00, 0xff):   # BSR.S
            tgt, after = i + 2 + s8(op & 0xff), i + 2
        if tgt is not None and tgt in targets:
            calls += 1
            for ins in md.disasm(code[after:after + 24], after):
                verdict = classify(ins)
                mn = ins.mnemonic.lower()
                if verdict == 'READ':
                    reads.append((i, f'{enclosing(i)}  [{owner_obj(i)}]',
                                  byaddr.get(tgt, hex(tgt)),
                                  f'{ins.mnemonic} {ins.op_str}'))
                    break
                if verdict == 'KILL':
                    break
                if mn.startswith(('b', 'j', 'dbf', 'db', 'rts', 'rte')):
                    break
        i += 2

    print(f'calls to a divide helper in the linked image: {calls}')
    print(f'sites that READ the remainder from D1:        {len(reads)}')
    for addr, fn, tgt, ins in reads:
        print(f'  0x{addr:06x}  in {fn}')
        print(f'              -> {tgt}, then {ins}')
    if reads:
        print('\nThe divide helpers CANNOT become C while any of these remain.')
        print('Rewrite each `a % b` as `a - (a / b) * b`, which reads only D0.')
    return 1 if reads else 0


if __name__ == '__main__':
    sys.exit(main())
