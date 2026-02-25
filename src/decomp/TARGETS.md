# Decomp Targets

## Target 001: `modules/groups/_main/a/xjump.s`

Status: promoted (GCC gate) + wired (vbcc lane retained)

Why this target:
- Very small module (4 jump-stub entry points).
- No local data tables or side effects.
- Ideal for validating module replacement plumbing before deeper function conversion.

Exported symbols:
- `GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook`
- `GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook`
- `GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll`
- `GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun`

Next step:
- Keep this module as the baseline canary for the decomp replacement pipeline.
- Choose a second target with simple arithmetic/control flow for first C body equivalence trials.

## Target 002: `modules/submodules/memory.s`

Status: promoted (GCC gate) + wired (vbcc lane retained)

Why this target:
- Small, readable routines with real logic and side effects.
- Contains simple branch behavior (`ptr != 0` and `size != 0` guard path).
- Calls known library vectors (`AllocMem`, `FreeMem`) and updates known globals.

Exported symbols:
- `MEMORY_AllocateMemory`
- `MEMORY_DeallocateMemory`

First equivalence checklist:
- Keep exact symbol names and call ABI.
- Preserve counter semantics exactly (`MEMORY_AllocateMemory` increments counters even on alloc failure).
- Preserve guard behavior in `MEMORY_DeallocateMemory` (update counters only when both ptr and size are non-zero).
- Verify with `./decomp-build.sh` after each edit.

Trial artifacts:
- C candidate (allocate): `src/decomp/c/replacements/memory_allocate.c`
- GCC C candidate (allocate): `src/decomp/c/replacements/memory_allocate_gcc.c`
- C candidate (deallocate): `src/decomp/c/replacements/memory_deallocate.c`
- GCC C candidate (deallocate): `src/decomp/c/replacements/memory_deallocate_gcc.c`
- Minimal declarations: `src/decomp/c/include/memory_target.h`
- Compile/compare script (allocate): `src/decomp/scripts/compare_memory_allocate_trial.sh`
- GCC compile/compare script (allocate): `src/decomp/scripts/compare_memory_allocate_trial_gcc.sh`
- Compile/compare script (deallocate): `src/decomp/scripts/compare_memory_deallocate_trial.sh`
- GCC compile/compare script (deallocate): `src/decomp/scripts/compare_memory_deallocate_trial_gcc.sh`

Run:
- `CROSS_CC=m68k-amigaos-gcc bash src/decomp/scripts/compare_memory_allocate_trial.sh`
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_memory_allocate_trial_gcc.sh`
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_memory_deallocate_trial_gcc.sh`
- `VBCC_ROOT=/Users/rj/Downloads/vbcc_installer bash src/decomp/scripts/compare_memory_allocate_trial.sh`
- `VBCC_ROOT=/Users/rj/Downloads/vbcc_installer bash src/decomp/scripts/compare_memory_deallocate_trial.sh`

Current convergence notes:
- With `VBCC_CFLAGS=-use-framepointer`, vbcc now emits `LINK/UNLK A5`.
- Trial uses `__reg("d7")`/`__reg("d6")` arguments and now saves/restores `D6/D7`.
- vbcc trial emits direct Exec LVO call shape (`move.l 4,a6` + `jsr -198(a6)`).
- Remaining diffs are in temporary handling and ABI book-keeping (extra `A6` save and local-slot traffic around return value).
- Option-1 trial (inline asm for counter updates only) is wired; counter ops now emit explicit `add.l d7` / `addq.l #1`, but return-value local-slot traffic (`-12(a5)`) remains.
- Option-1.1 tuning switched to `__reg("d0")` return with no local return variable; this removed the `-12(a5)` return spill (now `link.w a5,#-8`), leaving mainly `A6` save/restore and vbcc inline-asm label noise.
- Option-1.2 tuning replaced helper-call with direct inline LVO setup/call (`move.l d7,d0`, `move.l d6,d1`, `move.l 4,a6`, `jsr -198(a6)`), which removed vbcc's extra `A6` save/restore.
- Option-1.3 tuning switched to `__stdargs` + single multiline asm block and forced a 4-byte local pad to get `LINK.W A5,#-4`. Core call/update/save sequence now mirrors original more closely, but vbcc still emits one extra setup move (`move.l (8,a5),(-4,a5)`) before the inline block.
- Option-1.4 tuning changed the pad init to `0`, so the unavoidable extra setup op became `move.l #0,(-4,a5)` instead of copying an argument.
- Deallocate trial baseline is wired and preserving guard semantics (`ptr==0 || size==0` early return) with inline `FreeMem` + counter update block.
- Deallocate tuning moved full guard/call/update sequence into one inline asm block, yielding near-shape parity (`LINK.W A5,#0`, `MOVEM D7/A3` save/restore, `16/20(A5)` loads, `MOVEA.L 4,A6; JSR -210(A6)`, and guarded counter updates). Remaining deltas are mostly vbcc wrapper labels and symbol underscore/name formatting.
- Allocate/deallocate inline blocks now use original-style symbol names (no C underscore prefix) and `.return` label naming, further reducing textual diffs versus source assembly.
- Additional aggressive backend flag probes (`-no-reserve-regs`, `-no-peephole`, and combination) do not materially change wrapper labels/prologue noise for these inline-asm-heavy functions.
- GCC mixed-C deallocate pass is now wired (`memory_deallocate_gcc.c`): guard/counter logic in C with inline FreeMem call. Best observed GCC profile so far is `-O1 -fno-omit-frame-pointer` (plus m68k freestanding flags), which restores `LINK` frame shape and keeps branch structure close, though save/restore and register-copy noise remains.
- GCC mixed-C allocate pass is now wired (`memory_allocate_gcc.c`): counter updates in C with inline AllocMem call. Under the same `-O1 -fno-omit-frame-pointer` profile, GCC keeps a stable frame/call/update sequence but still introduces extra save/restore and temporary-register traffic versus the original `D6/D7`-centric pattern.
- GCC memory compare scripts now emit semantic post-filter outputs (`*.semantic.txt`) to compare behavioral blocks (args/call/counter/branch invariants) independent of register-allocation noise.
- Promotion gate script is wired: `src/decomp/scripts/promote_memory_target_gcc.sh` validates Target 002 GCC lanes by running compare scripts, requiring semantic parity, allowing only allowlisted normalized diffs, then enforcing `decomp-build.sh` and canonical `test-hash.sh`.
- Current promotion decision: pass (on GCC profile `-O1 -fno-omit-frame-pointer` + m68k freestanding flags).

## Target 003: `modules/submodules/unknown41.s` (`CLOCK_ConvertAmigaSecondsToClockData`)

Status: promoted (GCC gate) + wired (vbcc lane retained)

Why this target:
- Very small utility wrapper with a tight instruction sequence.
- Good candidate for evaluating wrapper/prologue noise with minimal logic complexity.

Artifacts:
- C candidate: `src/decomp/c/replacements/clock_convert_amiga_seconds.c`
- GCC C candidate: `src/decomp/c/replacements/clock_convert_amiga_seconds_gcc.c`
- Compile/compare script: `src/decomp/scripts/compare_clock_convert_trial.sh`
- GCC compile/compare script: `src/decomp/scripts/compare_clock_convert_trial_gcc.sh`

Run:
- `VBCC_ROOT=/Users/rj/Downloads/vbcc_installer bash src/decomp/scripts/compare_clock_convert_trial.sh`
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_clock_convert_trial_gcc.sh`

Current notes:
- Inline asm body matches core wrapper sequence (`A6` save, utility base load, `Amiga2Date` call, `A6` restore).
- vbcc still wraps with function prologue/epilogue scaffolding (`LINK/UNLK`, local labels).
- GCC lane uses a `naked` function with full body emitted via inline asm to suppress GCC prologue/epilogue.
- Promotion gate script is wired: `src/decomp/scripts/promote_clock_target_gcc.sh` validates Target 003 GCC lane by running compare script, enforcing canonicalized normalized equivalence, then enforcing `decomp-build.sh` and canonical `test-hash.sh`.
- Current promotion decision: pass (on GCC profile `-O0 -fomit-frame-pointer` + m68k freestanding flags).

## Target 004: `modules/submodules/unknown3.s` (`STRING_ToUpperChar`)

Status: promoted (GCC gate)

Why this target:
- Small non-wrapper logic function with real control flow.
- Good first scalar/branch C decomp candidate beyond library-call wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_to_upper_char_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_toupper_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_toupper.awk`
- Promotion gate: `src/decomp/scripts/promote_string_toupper_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_toupper_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_toupper_target_gcc.sh`

Current notes:
- GCC emits a compact range-normalization idiom (`ADD.B #-97` + `CMP.B #25` + `JHI`) rather than two explicit `'a'/'z'` compares.
- Semantic filter accepts both forms as equivalent lowercase-range checks.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 005: `modules/submodules/unknown34.s` (`MEM_Move`)

Status: promoted (GCC gate)

Why this target:
- Small non-wrapper loop function with overlap-sensitive control flow.
- Good first byte-copy loop target after scalar branch-only Target 004.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/mem_move_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_mem_move_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_memmove.awk`
- Promotion gate: `src/decomp/scripts/promote_mem_move_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_mem_move_trial_gcc.sh`
- `bash src/decomp/scripts/promote_mem_move_target_gcc.sh`

Current notes:
- GCC emits a different but equivalent loop idiom (`DBRA`-driven counted loops with `JCC` tail) and may swap A0/A1 argument register roles.
- Semantic gate validates overlap-branch behavior plus presence of forward/backward byte-copy loops and decrement/count progression.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 006: `modules/submodules/unknown8.s` (`FORMAT_U32ToDecimalString`)

Status: promoted (GCC gate)

Why this target:
- Small function with both helper-call and loop-heavy logic.
- Exercises the next tier: arithmetic helper call (`MATH_DivU32`) + digit accumulation + reverse emit loop.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/format_u32_to_decimal_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_format_u32_decimal_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_u32dec.awk`
- Promotion gate: `src/decomp/scripts/promote_format_u32_decimal_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_format_u32_decimal_trial_gcc.sh`
- `bash src/decomp/scripts/promote_format_u32_decimal_target_gcc.sh`

Current notes:
- GCC emits a different frame/layout and copy-loop structure, but preserves the required behavior: division step, ASCII digit conversion, reverse emit loop, NUL termination, and length return path.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).
