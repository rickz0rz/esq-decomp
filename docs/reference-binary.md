# What the reference hash actually is

`test-hash.sh` targets
`6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2` (297,016
bytes). **This is not the shipped ESQ binary.** It is a `vasm -Fhunkexe` rebuild
of Ari's disassembly, which is itself a lightly-modified fork of the original.

Measured against the genuine article at `~/Downloads/Prevue/ESQ.decompressed`
(the unpacked form of `ESQ.original`, which ships packed):

| | true original | reference build |
|---|---:|---:|
| CODE hunk | 211,748 B | 211,348 B (**400 smaller**) |
| CODE relocations | 8,839 | 8,791 |
| DATA hunk emitted | 32,104 B (trailing zeros trimmed) | 55,820 B (in full) |
| DATA hunk declared | 55,820 B | 55,820 B |
| reloc encoding | all `HUNK_RELOC32` | hybrid `RELOC32SHORT` + `RELOC32` |

The DATA sections differ in only **32 bytes** across their overlap (0.10%), and
the first divergence is literally `F0:FONTS` → `H2:FONTS`. That matches the repo
README, where Ari records hardcoding `DF0:` to `DH2:`, adding a "bootleg
InjectCTRL command" subfunction, and changing the version string to
"Ver 10.0 Build 69". The ~400 extra code bytes are consistent with that added
subfunction.

## Why this matters

1. `test-hash.sh` is a **self-consistency** check, not a fidelity check. Keeping
   it green proves a change did not alter the program; it does not prove the
   program matches what Prevue shipped.
2. The reconstruction target is Ari's variant. A decompilation that reaches 100%
   is a decompilation *of the fork*.
3. Container encoding is not evidence of anything. The true original, vasm, and
   vlink each emit a different relocation encoding for identical content — which
   is precisely why `build-split.sh` compares content rather than file bytes.
   Note the split build's container (all-long relocs, trimmed DATA hunk) is
   actually *closer* to the true original's than the monolithic vasm build is.

## If you ever want to retarget

Backing out the fork to match `ESQ.decompressed` byte-for-byte looks tractable —
32 data bytes and ~400 code bytes — and would give a decompilation of the real
shipped program. It was considered and deliberately deferred; the current target
was kept so work could start immediately. Revisit once the C pipeline is proven.

## Reproducing these numbers

`tools/hunkcmp.py` prints hunk structure and content deltas for any two hunk
executables:

```sh
python3 tools/hunkcmp.py ~/Downloads/Prevue/ESQ.decompressed build/ESQ_reference
```
