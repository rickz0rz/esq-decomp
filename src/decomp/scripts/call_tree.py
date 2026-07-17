#!/usr/bin/env python3
"""
call_tree.py -- transitive call tree of one or more root functions across the
original ASM (src/modules + src/interrupts + src/*.s). Follows JSR/BSR/JMP to
named labels, resolving JMPTBL wrappers to their target. Emits the reachable
function set (the "hot path") in BFS order with depth, so verification can be
prioritized. Usage: call_tree.py ROOT [ROOT2 ...]
"""
import os, re, sys, glob, collections

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
ASM_DIRS = ["src/modules", "src/interrupts", "src"]

# index every label -> (file, body-lines)
label_body = {}
label_file = {}

def index():
    seen = set()
    files = []
    for d in ASM_DIRS:
        for p in glob.glob(os.path.join(ROOT, d, "**", "*.s"), recursive=True):
            if p not in seen:
                seen.add(p); files.append(p)
        for p in glob.glob(os.path.join(ROOT, d, "*.asm")):
            if p not in seen:
                seen.add(p); files.append(p)
    lbl_re = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*):')
    for p in files:
        try:
            lines = open(p, encoding="utf-8", errors="replace").read().splitlines()
        except Exception:
            continue
        cur = None; body = []
        for ln in lines:
            m = lbl_re.match(ln)
            if m:
                if cur is not None:
                    label_body[cur] = body
                cur = m.group(1); body = []
                label_file.setdefault(cur, p)
            elif cur is not None:
                body.append(ln)
        if cur is not None:
            label_body[cur] = body

CALL_RE = re.compile(r'\b(?:JSR|BSR|JMP)\b[^;]*?\b([A-Za-z_][A-Za-z0-9_]*)\b')

def callees(fn):
    out = []
    for ln in label_body.get(fn, []):
        code = ln.split(';', 1)[0]
        m = CALL_RE.search(code)
        if m:
            out.append(m.group(1))
    return out

def resolve(name):
    # a JMPTBL wrapper is usually a single JMP to the real target
    body = label_body.get(name)
    if body and 'JMPTBL' in name:
        for ln in body:
            m = re.search(r'\bJMP\b\s+([A-Za-z_][A-Za-z0-9_]*)', ln.split(';',1)[0])
            if m:
                return m.group(1)
    return name

def main():
    roots = sys.argv[1:]
    if not roots:
        print("usage: call_tree.py ROOT [ROOT2 ...]"); return
    index()
    depth = {r: 0 for r in roots}
    order = list(roots)
    q = collections.deque(roots)
    while q:
        fn = q.popleft()
        for c in callees(fn):
            c = resolve(c)
            if c not in depth and c in label_body:
                depth[c] = depth[fn] + 1
                order.append(c); q.append(c)
    # only report functions that have a body (defined in the ASM)
    print(f"# reachable functions: {len(order)}")
    for fn in order:
        f = os.path.relpath(label_file.get(fn, "?"), ROOT)
        print(f"{depth[fn]}\t{fn}\t{f}")

if __name__ == "__main__":
    main()
