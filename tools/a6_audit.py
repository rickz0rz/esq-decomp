#!/usr/bin/env python3
"""Find C restorations that call a library through a STALE A6.

    /tmp/.capvenv/bin/python tools/a6_audit.py            # audit src/c/*.c
    /tmp/.capvenv/bin/python tools/a6_audit.py <file.o>   # audit one object

This is an ABI check, not a byte check, and no existing gate can see it.

SAS/C assumes A6 is preserved across a call, because its own generated code
saves A6 whenever it uses it. So having loaded a library base into A6 for one
call it will happily reuse the register for the next, across intervening calls:

    MOVEA.L DOSBase,A6
    JSR     _LVOLock(A6)
    JSR     _MEMORY_AllocateMemory      <- ESQ assembly
    JSR     _LVOInfo(A6)                <- A6 is ExecBase by now

ESQ's hand-written assembly does not honour that convention -- MEMORY_AllocateMemory
loads AbsExecBase into A6 and returns without restoring it, and its own comment
lists A6 as clobbered. The second call therefore enters a different library at
the same offset. DISKIO_QueryDiskUsagePercentAndSetBufferSize did exactly this
and reset the machine on the first Info() call.

The original reloads the base before every single call, which is why this shows
up as the recorded `reload-vs-cache` byte divergence -- that divergence was
never cosmetic, it was this bug.

A call to another C function is safe, but the object cannot say which externs
are C and which are assembly, so any intervening call counts. That is the right
bias: a false positive costs one base reload, which is what the original emits
anyway; a false negative resets the machine.
"""
import os
import re
import subprocess
import sys

from capstone import Cs, CS_ARCH_M68K, CS_MODE_M68K_000

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MD = Cs(CS_ARCH_M68K, CS_MODE_M68K_000)


def code_of(obj):
    """(bytes, {offset: symbol}) for the object's first code hunk."""
    out = subprocess.run([sys.executable if 'capvenv' not in sys.executable else 'python3',
                          os.path.join(ROOT, 'tools', 'objbytes.py'), obj],
                         capture_output=True, text=True).stdout
    m = re.search(r'^bytes: ([0-9a-f]+)', out, re.M)
    return bytes.fromhex(m.group(1)) if m else b''


def audit(code):
    """Offsets of `JSR d16(A6)` reached with A6 possibly clobbered."""
    bad, base_live, last_load = [], False, None
    for ins in MD.disasm(code, 0):
        op, s = ins.mnemonic, ins.op_str

        # a library base going into A6 makes it live again
        if op.startswith('movea') and s.endswith(', a6'):
            base_live, last_load = True, ins.address
            continue

        # a call through A6 -- the thing being checked
        if op == 'jsr' and 'a6)' in s:
            if not base_live:
                bad.append((ins.address, s, last_load))
            continue

        # any other call may return with A6 pointing somewhere else
        if op in ('jsr', 'bsr') or op.startswith('bsr'):
            base_live = False
    return bad


def main():
    if len(sys.argv) > 1:
        for o in sys.argv[1:]:
            for a, s, _ in audit(code_of(o)):
                print(f'{o}  0x{a:x}  jsr {s}')
        return

    # audit every object the maximum-C build produced, mapped back to its source
    objs = sorted(f for f in os.listdir(os.path.join(ROOT, 'build', 'obj'))
                  if re.match(r'c_repl_\d+\.o$', f)) if \
        os.path.isdir(os.path.join(ROOT, 'build', 'obj')) else []
    if not objs:
        sys.exit('no build/obj/c_repl_*.o -- run a C build first')

    names = {}
    for d in os.listdir(os.path.join(ROOT, 'build')):
        m = re.match(r'cwork_(\d+)$', d)
        if m:
            p = os.path.join(ROOT, 'build', d, 'u.c')
            if os.path.exists(p):
                h = re.search(r'RESTORES:\s*(\S+)', open(p).read())
                names[int(m.group(1))] = h.group(1) if h else d

    hits = 0
    for o in sorted(objs, key=lambda x: int(re.findall(r'\d+', x)[0])):
        n = int(re.findall(r'\d+', o)[0])
        bad = audit(code_of(os.path.join(ROOT, 'build', 'obj', o)))
        if bad:
            hits += 1
            print(f'STALE-A6  {names.get(n, o)}   ({len(bad)} call site(s))')
            for a, s, _ in bad:
                print(f'              0x{a:<4x} jsr {s}')
    print(f'\n{hits} of {len(objs)} objects call a library through a stale A6')
    sys.exit(1 if hits else 0)


if __name__ == '__main__':
    main()
