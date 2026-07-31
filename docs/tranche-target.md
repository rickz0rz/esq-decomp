# Current tranche target

**Restore every unblocked function under 400 bytes.**

| | bytes | share |
|---|---:|---:|
| start (2026-07-30) | 94,344 | 48.8% |
| target | 133,520 | **69.0%** |
| work | 39,176 in 206 functions | +20.2 points |

`python3 tools/worklist.py` prints what is left, smallest first. It reads
`coverage.survey()` on every run, so a name leaves the list as soon as its
restoration lands. Never keep a copy of that list anywhere.

`python3 tools/worklist.py --bands` shows what the next size band would add.
**97.7% is the ceiling.** Only 4,368 bytes in 35 functions are truly blocked, and
`docs/blocked-shapes.md` says what each class would take. An earlier version of
this file said 89.8%, which was wrong: `coverage.py` counted 30 ordinary
functions as unrestorable because their epilogue sits under a `_Return` label.
Do not treat 100% as the goal, but do not trust a ceiling you have not checked.

Work smallest first. Small functions restore fastest, each one is verified on its
own, and a run that ends mid-list loses nothing. One large function left half-read
loses everything.

## The loop, once per function

Read `AGENTS.md` first. It holds the reasoning; this is only the order of
operations.

1. Read the original. `python3 tools/refbytes.py <Label>` gives the bytes.
   Find the module with `grep -rl '^<Label>:' src/modules/`.
2. Look for a sibling in `src/c/` that already models the same structs and
   globals. Reuse its modeling. `newgrid_draw_grid_frame_alt.c` and
   `newgrid_draw_grid_frame_variant3.c` are two worked examples of one family.
3. Write the C. Follow **Source shapes that change the emitted bytes** in
   `AGENTS.md`. `TST.L`/`BPL`/`ADDQ #1`/`ASR.L #1` is a signed `/ 2`.
4. `tools/cmatch.sh <file.c> <Label>` to compile and compare.
5. If it does not match, `/tmp/.capvenv/bin/python tools/casm.py <file.c> <Label>`
   itemises the delta and says whether the items add up.
6. Write the header. Record the real numbers, and record what you TRIED and
   rejected. A rejected form that is not written down gets retried.
7. `python3 tools/rename_for_c.py <Label>`, then `./test-hash.sh`. The rename is
   byte-neutral, so the hash must not move.
8. If `worklist.py` said **SPLIT**, run
   `python3 tools/split_module.py modules/<path>.s <_Label>`. The path is
   relative to `src/`, without the `src/` prefix. Then run BOTH gates: content
   and order do not change, so a split that moves the hash is a bug.
9. `python3 tools/gen_all_manifest.py`, and check the count went up by one. If it
   did not, the module still holds more than one label.

## Every few functions, not every function

```sh
ESQ_FARCALLS=1 SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \
  C_REPLACEMENTS=src/c/replacements-all.txt ./build-split.sh
/tmp/.capvenv/bin/python tools/a6_audit.py
./tools/soak_esq.sh build/ESQ <label> 150 15
```

`ESQ_FARCALLS=1` is required. Without it the link fails with `Error 28` and blames
an assembly unit rather than any restoration.

The soak exits nonzero on a frozen display. Check the numbers it prints as well:
`frames with Amiga content` below 10 of 10 means the capture is broken, not the
build.

**A green soak is not enough on its own.** Compare a colour statistic against the
known-good build, because a wrong constant draws a wrong picture while the display
keeps animating. That is how the register-argument class was found:

```sh
./tools/soak_esq.sh ~/Downloads/Prevue/ESQ.known-good-36cf56ed kg 150 15
# then compare per-frame colour between the two label sets
```

## Rules that cost real time when broken

- **Refresh the derived numbers** in `README.md` and `AGENTS.md` at the end of
  every run. The procedure is at the top of `AGENTS.md`. Run the commands. Never
  copy a number from a previous session.
- **A prose warning in a header protects nothing.** If a restoration must not be
  linked, write `DO-NOT-LINK:` in the header. Fifteen files said "not linkable"
  in prose only, and seven of them were linked into manifests called
  verified-good.
- **Never add inline assembly.** SAS/C 6.51 has none, and `asm()` compiles into a
  silent call to `_asm`. If a function seems to need it, leave it in assembly and
  ask.
- **Equal size is not evidence of fidelity.** Report the region count next to the
  size, and prefer the form that matches the original's STRUCTURE over the form
  that matches its byte count.
