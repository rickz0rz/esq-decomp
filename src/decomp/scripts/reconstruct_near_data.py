#!/usr/bin/env python3
"""Reconstruct the near-data as a single relocatable blob with A4-name labels
placed at their exact section offsets (vasm drops the offset when XDEF'ing an
equate `label+const`, but a real label at the live PC, and a `dc.l base+const`
reloc addend, both export/relocate correctly)."""
import struct,sys,re,os
pass1=sys.argv[1]; outasm=sys.argv[2]
d=open(pass1,"rb").read()
def u32(o):return struct.unpack(">I",d[o:o+4])[0]
# --- walk hunks: DATA bytes, internal RELOC32, HUNK_EXT (defs=labels, refs=externs) ---
data=b""; defs={}; abseq={}; extref={}; relocs=set()
o=0
while o<len(d)-4:
    t=u32(o)&0x3fffffff
    if t in (0x3e7,0x3e8):              # UNIT / NAME
        nl=u32(o+4); o+=8+nl*4
    elif t==0x3ea:                      # DATA
        sz=u32(o+4); data=d[o+8:o+8+sz*4]; o+=8+sz*4
    elif t==0x3e9:                      # CODE
        sz=u32(o+4); o+=8+sz*4
    elif t==0x3eb: o+=8                 # BSS
    elif t==0x3ec:                      # RELOC32 (internal)
        p2=o+4
        while True:
            c=u32(p2);p2+=4
            if c==0:break
            hn=u32(p2);p2+=4
            for i in range(c): relocs.add(u32(p2)); p2+=4
        o=p2
    elif t==0x3ef:                      # HUNK_EXT (defs + refs)
        p2=o+4
        while True:
            w=u32(p2);p2+=4
            if w==0:break
            typ=(w>>24)&0xff; nl=w&0xffffff
            nm=d[p2:p2+nl*4].split(b'\x00')[0].decode('latin1'); p2+=nl*4
            if typ==1:                  # EXT_DEF: relocatable near-data label -> offset
                defs.setdefault(u32(p2),[]).append(nm); p2+=4
            elif typ==2:                # EXT_ABS: absolute equate (from includes) -> seed only
                abseq[nm]=u32(p2); p2+=4
            elif typ==130:              # EXT_COMMON: size + refs
                p2+=4; c=u32(p2);p2+=4
                for i in range(c): extref[u32(p2)]=nm; p2+=4
            elif typ in (129,131,132,133,134,135,136,137):  # EXT_REF*: count + offsets
                c=u32(p2);p2+=4
                for i in range(c): extref[u32(p2)]=nm; p2+=4
            else:
                p2+=4
        o=p2
    elif t==0x3f0:                      # SYMBOL (debug) - skip (EXT defs are authoritative;
        p2=o+4                          # debug symbols can carry stale offsets -> duplicates)
        while True:
            nl=u32(p2);p2+=4
            if nl==0:break
            p2+=nl*4+4
        o=p2
    elif t==0x3f2: o+=4
    else: o+=4
DATA_LEN=len(data)

# --- alias offsets: reuse the evaluator (label-seeded) to map each a4/missing
#     A4 global to its section offset; only those landing inside the near-data. ---
ROOT=os.getcwd()
provided=set()
import glob
for p in glob.glob(os.path.join(ROOT,"src","data","*.s")):
    for line in open(p,errors="replace"):
        m=re.match(r'^([A-Za-z_]\w*)\s*:',line)
        if m: provided.add(m.group(1))
for rel in ("src/lvo-offsets.s","src/hardware-addresses.s","src/structs.s"):
    for line in open(os.path.join(ROOT,rel),errors="replace"):
        m=re.match(r'^([A-Za-z_]\w*)\s*(?::|=|\s+EQU\b)',line)
        if m: provided.add(m.group(1))
refd=set()
for p in glob.glob(os.path.join(ROOT,"src","decomp","sas_c","*.c")):
    src=re.sub(r'/\*.*?\*/','',open(p,errors="replace").read(),flags=re.DOTALL)
    for line in src.splitlines():
        if 'extern' in line:
            for m in re.finditer(r'\bextern\b[^;(]*?\b([A-Za-z_]\w+)\s*(?:\[|;|,)',line): refd.add(m.group(1))
try: cdefined=set(open(os.path.join(ROOT,"build/decomp/phase3/cdefined.txt")).read().split())
except Exception: cdefined=set()
export=sorted(s for s in refd if s not in provided and s not in cdefined)
# label addresses (offsets) for seeding
labaddr={nm:off for off,nl in defs.items() for nm in nl}
env=dict(labaddr); env.update(abseq); env.update({"Type_Long_Size":4,"Type_Word_Size":2,"Type_Byte_Size":1})
A4=labaddr.get("Global_REF_LONG_FILE_SCRATCH"); 
if A4 is not None: env["A4_Base"]=A4
consts={}
for rel in ("src/lvo-offsets.s","src/hardware-addresses.s","src/structs.s","src/macros.s"):
    if not os.path.exists(rel):continue
    for m in re.finditer(r'^([A-Za-z_]\w*)\s*(?:=|\s+EQU\s+)\s*(.+?)\s*(?:;.*)?$',open(rel,errors="replace").read(),re.M):
        consts.setdefault(m.group(1),m.group(2).strip())
eqs={}
for m in re.finditer(r'^\s*([A-Za-z_]\w*)\s*=\s*(.+?)\s*(?:;.*)?$',open("src/Prevue.asm",errors="replace").read(),re.M):
    eqs.setdefault(m.group(1),m.group(2).strip())
def val(n,seen):
    if n in env:return env[n]
    if n in seen:return None
    seen=seen|{n}; e=eqs.get(n,consts.get(n))
    if e is None:return None
    out=[]
    for tk in re.findall(r'[A-Za-z_]\w*|\$[0-9A-Fa-f]+|\d+|[-+*/()]|\S',e):
        if re.match(r'^[A-Za-z_]\w*$',tk):
            v=val(tk,seen)
            if v is None:return None
            out.append("("+str(v)+")")
        elif tk.startswith('$'):out.append(str(int(tk[1:],16)))
        else:out.append(tk)
    try:r=eval("".join(out),{"__builtins__":{}},{})
    except:return None
    env[n]=r;return r
alias_at={}   # offset -> [alias C-names (with underscore)]
fresh=[]
for s in export:
    v=val(s,set()) if (A4 is not None and s in eqs) else None
    off=(A4+v) if v is not None else None
    if off is not None and 0<=off<DATA_LEN: alias_at.setdefault(off,[]).append(s)
    else: fresh.append(s)

# --- labels to place: all near-data asm labels (non-underscore) + aliases ---
labels_at={}   # offset -> set of "raw" asm labels to emit (name:) 
for off,nl in defs.items():
    for nm in nl:
        if not nm.startswith("_"):
            labels_at.setdefault(off,set()).add(nm)

# --- emit reconstructed asm ---
out=open(outasm,"w")
w=out.write
w("; AUTO-GENERATED near-data blob (reconstructed so A4-name labels land at exact\n")
w("; offsets; vasm drops offsets on XDEF'd equates, but real labels + dc.l addends\n")
w("; relocate correctly).\n")
w("    SECTION datasegment,DATA\n")
w("_DSEG_BASE:\n")
i=0
def flush(buf):
    # emit a run of raw bytes as dc.b lines
    for j in range(0,len(buf),16):
        w("    dc.b "+",".join(str(b) for b in buf[j:j+16])+"\n")
buf=bytearray()
while i<DATA_LEN:
    # place any labels/aliases at this offset (flush pending bytes first)
    lbls=labels_at.get(i); als=alias_at.get(i)
    if lbls or als:
        flush(buf); buf=bytearray()
        for nm in sorted(lbls or []): w(f"{nm}:\n")
        for a in (als or []):
            w(f"    XDEF _{a}\n_{a}:\n")
    if i in relocs:
        flush(buf); buf=bytearray()
        target=struct.unpack(">I",data[i:i+4])[0]   # stored addend = section offset of target
        w(f"    dc.l _DSEG_BASE+{target}\n")
        i+=4
    elif i in extref:
        flush(buf); buf=bytearray()
        addend=struct.unpack(">I",data[i:i+4])[0]
        nm=extref[i]
        w(f"    XREF {nm}\n")
        w(f"    dc.l {nm}+{addend}\n" if addend else f"    dc.l {nm}\n")
        i+=4
    else:
        buf.append(data[i]); i+=1
flush(buf)
# trailing labels exactly at DATA_LEN (end)
for nm in sorted(labels_at.get(DATA_LEN,set())): w(f"{nm}:\n")
for a in alias_at.get(DATA_LEN,[]): w(f"    XDEF _{a}\n_{a}:\n")
# fresh storage for non-A4 referenced globals
for s in fresh: w(f"    XDEF _{s}\n_{s}:\n    ds.b 2048\n")
out.close()
print(f"reconstructed: DATA={DATA_LEN} bytes, {len(relocs)} relocs, "
      f"{sum(len(v) for v in labels_at.values())} labels, "
      f"{sum(len(v) for v in alias_at.values())} aliases, {len(fresh)} fresh")
