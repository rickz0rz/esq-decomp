#!/usr/bin/env python3
"""
Trust-nothing audit of the restored SAS/C in src/decomp/sas_c/ for the recurring
prior-LLM bug classes that the semantic compare MISSES (false negatives) and that
cause runtime crashes / graphical corruption:

  Class 1  aggregate-declared-as-pointer:  a data-segment STRUCT/BUFFER (src/data/*.s
           label + DS.B/DS.L) declared `extern void*`/`extern T*` and used BY VALUE
           (assigned/passed without &).  e.g. Global_REF_696_400_BITMAP, BRUSH_SnapshotHeader.
           Symptom: garbage pointer -> wild read/write -> AN_MemCorrupt / address error.
  Class 2  bare-OS-call:  SetAPen/RectFill/Move/Text/... (or DOS/exec) called WITHOUT a
           base arg -> resolves to an amiga.lib stub that uses an UNINITIALIZED _GfxBase
           (this program keeps its base in Global_REF_GRAPHICS_LIBRARY). Must be the
           base-explicit `_LVOxxx(Global_REF_GRAPHICS_LIBRARY, ...)` form.
  Class 3  ABI arg-width:  a JMPTBL/extern declared with WORD x,y where the real callee
           takes LONG (asm pushes PEA nn.W = 32-bit) -> pushed args misaligned.

Each hit is a CANDIDATE -- confirm by checking the src/data/*.s definition + the ASM
(compare_sasc_*_trial.sh semantic diff is NOT authoritative here; it misses class 2/3).
Fixed so far: esqiff2_show_attention_overlay (all 3), +4 BITMAP files, +2 bare-graphics files.
"""
import re, glob, collections, os

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
SAS = os.path.join(ROOT, 'src/decomp/sas_c')

def class1():
    decl = collections.defaultdict(set)
    declre = re.compile(r'^\s*extern\s+(.+?)\b([A-Za-z_]\w*)\s*(\[\s*\d*\s*\])?\s*;')
    for f in glob.glob(SAS + '/*.c'):
        for line in open(f, encoding='latin-1'):
            m = declre.match(line)
            if not m: continue
            pre, name, arr = m.group(1), m.group(2), m.group(3)
            kind = ('PTR' if ('*' in pre and not arr) else 'ARR' if arr
                    else 'STRUCT' if 'struct' in pre else 'SCALAR')
            decl[name].add((kind, os.path.basename(f)))
    print("=== CLASS 1: symbols declared inconsistently (PTR vs ARR/STRUCT) ===")
    for name in sorted(decl):
        ks = {k for k, _ in decl[name]}
        if 'PTR' in ks and (ks & {'ARR', 'STRUCT'}):
            print(f"  {name}: " + ", ".join(f"{k}:{fn}" for k, fn in sorted(decl[name])))

def class2():
    GFX = ['SetAPen','SetBPen','SetDrMd','RectFill','Move','Text','Draw','WritePixel',
           'InitRastPort','InitBitMap','BltBitMapRastPort','BltClear','SetFont','TextLength']
    print("\n=== CLASS 2: files with BARE graphics calls (extern void SetAPen... + call) ===")
    for f in glob.glob(SAS + '/*.c'):
        txt = open(f, encoding='latin-1').read()
        bare = [fn for fn in GFX if re.search(r'^\s*extern\s+[\w ]*\b'+fn+r'\s*\(', txt, re.M)]
        if bare:
            print(f"  {os.path.basename(f)}: {bare}")

if __name__ == '__main__':
    class1()
    class2()
