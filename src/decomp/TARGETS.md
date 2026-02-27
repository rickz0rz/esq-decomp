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

## Target 007: `modules/submodules/unknown34.s` (`LIST_InitHeader`)

Status: promoted (GCC gate)

Why this target:
- Small struct-field initialization function.
- Good bridge from loop/call targets into pointer-field write patterns.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/list_init_header_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_list_init_header_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_list_init.awk`
- Promotion gate: `src/decomp/scripts/promote_list_init_header_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_list_init_header_trial_gcc.sh`
- `bash src/decomp/scripts/promote_list_init_header_target_gcc.sh`

Current notes:
- GCC may encode the `+4` head adjustment via `LEA` temporary pointer and use indexed displacement syntax (`(4,a0)`/`(8,a0)`), but semantics remain equivalent.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 008: `modules/submodules/unknown34.s` (`DOS_ReadByIndex`)

Status: promoted (GCC gate)

Why this target:
- First promoted target in this workflow with two helper calls plus error-state branch mapping.
- Extends the same module cluster as Targets 005/007 toward module-level confidence.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_read_by_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_read_by_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_read_idx.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_read_by_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_read_by_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_read_by_index_target_gcc.sh`

Current notes:
- GCC emits tighter stack/call setup than source assembly and uses global-symbol addressing form for `Global_DosIoErr`; semantic gate validates the key behavior (entry lookup, null guard, read call, ioerr test, `-1` error path).
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 009: `modules/submodules/unknown11.s` (`DOS_SeekByIndex`)

Status: promoted (GCC gate)

Why this target:
- Companion to Target 008 with the same handle+ioerr control-flow pattern, but seek-specific helper call.
- Reinforces confidence in this class of “lookup + operation + ioerr mapping” conversions.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_seek_by_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_seek_by_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_seek_idx.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_seek_by_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_seek_by_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_seek_by_index_target_gcc.sh`

Current notes:
- GCC emits a compact stack setup and branch layout relative to original register-save heavy sequence, but semantic gate validates lookup call, null guard, seek call, ioerr test, and `-1` fallback behavior.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 010: `modules/submodules/unknown6.s` (`STRING_AppendAtNull`)

Status: promoted (GCC gate)

Why this target:
- Compact two-loop pointer/string function with no helper calls.
- Strengthens confidence in C-string idiom equivalence (scan-to-NUL then copy-through-NUL).

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_append_at_null_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_append_at_null_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_append.awk`
- Promotion gate: `src/decomp/scripts/promote_string_append_at_null_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_append_at_null_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_append_at_null_target_gcc.sh`

Current notes:
- GCC may avoid the explicit `SUBQ #1,A0` by preserving a pre-increment-safe write pointer in a second register; semantic gate treats both forms as equivalent.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 011: `modules/submodules/unknown5.s` (`STRING_AppendN`)

Status: promoted (GCC gate)

Why this target:
- First promoted bounded-append string helper in the `unknown5.s` string utility cluster.
- Adds a min-bound selection pattern (`min(src_len, max_bytes)`) on top of dual end-scan loops and copy/NUL writeback.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_append_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_append_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_append_n.awk`
- Promotion gate: `src/decomp/scripts/promote_string_append_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_append_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_append_n_target_gcc.sh`

Current notes:
- GCC emits a denser counted-copy loop and register allocation pattern than source assembly; semantic gate validates src/dst end-scans, bound clamp behavior, bounded copy loop, explicit NUL termination, and destination-pointer return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 012: `modules/submodules/unknown5.s` (`STRING_CopyPadNul`)

Status: promoted (GCC gate)

Why this target:
- Complements Target 011 with a bounded copy + NUL-padding behavior.
- Expands the promoted `unknown5.s` string helper cluster with a second bounded write primitive.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_copy_pad_nul_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_copy_pad_nul_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_copy_pad.awk`
- Promotion gate: `src/decomp/scripts/promote_string_copy_pad_nul_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_copy_pad_nul_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_copy_pad_nul_target_gcc.sh`

Current notes:
- GCC may expand copy/pad loops with `DBEQ/DBRA`-style counted forms and split byte-copy into load/store pairs; semantic gate validates copy-until-NUL behavior, pad loop behavior, countdown control, and destination-pointer return semantics.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 013: `modules/submodules/unknown5.s` (`STRING_CompareN`)

Status: promoted (GCC gate)

Why this target:
- Core bounded string-compare primitive from the same utility cluster as Targets 011/012.
- Adds signed difference-return behavior and tail-state mapping (`+1/-1/0`) to the promoted set.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_compare_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_compare_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_compare_n.awk`
- Promotion gate: `src/decomp/scripts/promote_string_compare_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_compare_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_compare_n_target_gcc.sh`

Current notes:
- GCC may express the `-1/0/+1` tail logic with booleanization idioms (`SNE/EXT`) and direct `D0` nonzero-return branches after `SUB`; semantic gate accepts these equivalent compiler forms.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 014: `modules/submodules/unknown5.s` (`STRING_CompareNoCase`)

Status: promoted (GCC gate)

Why this target:
- Case-insensitive comparator companion to Target 013.
- Expands promoted behavior to include ASCII case-normalization semantics.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_compare_nocase_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_compare_nocase_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_compare_nocase.awk`
- Promotion gate: `src/decomp/scripts/promote_string_compare_nocase_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_compare_nocase_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_compare_nocase_target_gcc.sh`

Current notes:
- GCC may either inline `a..z` casefold checks or outline them into a helper call (`to_upper_ascii`) depending on optimization/code shape; semantic gate accepts both forms.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 015: `modules/submodules/unknown5.s` (`STRING_CompareNoCaseN`)

Status: promoted (GCC gate)

Why this target:
- Bounded case-insensitive compare companion to Targets 013/014.
- Extends promoted string-compare semantics to the max-length + `-1/0/+1` tail-state variant with casefold helper calls.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_compare_nocase_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_compare_nocase_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_compare_nocase_n.awk`
- Promotion gate: `src/decomp/scripts/promote_string_compare_nocase_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_compare_nocase_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_compare_nocase_n_target_gcc.sh`

Current notes:
- GCC is allowed to reshuffle local save/restore and helper-call temp handling (`STRING_ToUpperChar`) while preserving bounded-compare semantics.
- Semantic gate validates max-length guard, dual NUL guards, casefold-call presence, diff-return branch, length decrement, and tail `+1/-1/0` outcomes.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 016: `modules/submodules/unknown4.s` (`STRING_ToUpperInPlace`)

Status: promoted (GCC gate)

Why this target:
- Next string-helper step after scalar `STRING_ToUpperChar` (Target 004): in-place full-string transform loop.
- Adds a straightforward pointer-walk + conditional uppercase conversion pattern using the character-class table semantics.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_toupper_inplace_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_toupper_inplace_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_toupper_inplace.awk`
- Promotion gate: `src/decomp/scripts/promote_string_toupper_inplace_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_toupper_inplace_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_toupper_inplace_target_gcc.sh`

Current notes:
- GCC may represent uppercase detection either via direct table-bit tests (`Global_CharClassTable`/`BTST`) or equivalent compare/subtract sequences; semantic gate allows either pattern.
- Semantic gate validates input pointer load, loop guard, byte load/store path, uppercase transform presence, pointer increment, and returning the original pointer.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 017: `modules/submodules/unknown7.s` (`STR_FindChar`)

Status: promoted (GCC gate)

Why this target:
- Small, standalone string-scan primitive with no helper calls.
- Adds pointer-return-on-match and zero-on-NUL-not-found semantics used by multiple wrappers/callers in `unknown7.s`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/str_find_char_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_str_find_char_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_find_char.awk`
- Promotion gate: `src/decomp/scripts/promote_str_find_char_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_str_find_char_trial_gcc.sh`
- `bash src/decomp/scripts/promote_str_find_char_target_gcc.sh`

Current notes:
- GCC may fold pointer advance and NUL test into a single post-increment load path; semantic gate accepts equivalent instruction ordering.
- Semantic gate validates target-byte compare, match-pointer return, continue-scan path, and zero return on not-found.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 018: `modules/submodules/unknown7.s` (`STR_FindCharPtr`)

Status: promoted (GCC gate)

Why this target:
- Direct wrapper companion to Target 017 with stable ABI usage across jump-table callsites.
- Low-risk promotion that validates call-through wrapper patterns under GCC.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/str_find_char_ptr_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_str_find_char_ptr_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_find_char_ptr.awk`
- Promotion gate: `src/decomp/scripts/promote_str_find_char_ptr_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_str_find_char_ptr_trial_gcc.sh`
- `bash src/decomp/scripts/promote_str_find_char_ptr_target_gcc.sh`

Current notes:
- GCC may emit wrapper calls as direct `BSR/JSR STR_FindChar` or via register-indirect call sequences; semantic gate allows either.
- Semantic gate validates argument load path, call presence, stack cleanup (if used), epilogue restore, and final return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 019: `modules/submodules/unknown7.s` (`STR_FindAnyCharInSet`)

Status: promoted (GCC gate)

Why this target:
- Core set-membership scanner in the same small string-helper cluster as Targets 017/018.
- Adds nested-loop compare semantics (`input byte` vs `charset bytes`) with pointer return on first match.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/str_find_any_char_in_set_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_str_find_any_char_in_set_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_find_any_char_in_set.awk`
- Promotion gate: `src/decomp/scripts/promote_str_find_any_char_in_set_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_str_find_any_char_in_set_trial_gcc.sh`
- `bash src/decomp/scripts/promote_str_find_any_char_in_set_target_gcc.sh`

Current notes:
- GCC may represent the inner charset scan with temporary pointer spills or register-only loops; semantic gate accepts equivalent patterns.
- Semantic gate validates outer input guard, inner charset guard, byte compare, match-pointer return, pointer advances, and zero return on no match.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 020: `modules/submodules/unknown7.s` (`STR_FindAnyCharPtr`)

Status: promoted (GCC gate)

Why this target:
- ABI-preserving wrapper companion to Target 019.
- Low-risk call-shim target that validates wrapper patterns for two-pointer arguments.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/str_find_any_char_ptr_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_str_find_any_char_ptr_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_find_char_ptr.awk`
- Promotion gate: `src/decomp/scripts/promote_str_find_any_char_ptr_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_str_find_any_char_ptr_trial_gcc.sh`
- `bash src/decomp/scripts/promote_str_find_any_char_ptr_target_gcc.sh`

Current notes:
- GCC often emits a minimal wrapper (`arg pushes + JSR + stack pop + RTS`) with no explicit register-save prologue; semantic gate allows that compact shape.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 021: `modules/submodules/unknown7.s` (`STR_SkipClass3Chars`)

Status: promoted (GCC gate)

Why this target:
- Last small standalone helper in the `unknown7.s` cluster after Targets 017-020.
- Adds char-class-table bit-test loop semantics (`bit 3`) and pointer-return behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/str_skip_class3_chars_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_str_skip_class3_chars_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_skip_class3_chars.awk`
- Promotion gate: `src/decomp/scripts/promote_str_skip_class3_chars_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_str_skip_class3_chars_trial_gcc.sh`
- `bash src/decomp/scripts/promote_str_skip_class3_chars_target_gcc.sh`

Current notes:
- GCC may implement the class-bit check via direct `BTST #3` on `Global_CharClassTable` or equivalent masked-byte tests; semantic gate accepts either.
- Semantic gate validates byte load, class-table access, bit-3 test, loop advance on class match, and pointer return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 022: `modules/submodules/unknown13.s` (`FORMAT_CallbackWriteChar`)

Status: promoted (GCC gate)

Why this target:
- Small stateful callback in the formatter pipeline with clear success/overflow branches.
- Adds first promoted target that mutates callback buffer state and conditionally calls `STREAM_BufferedPutcOrFlush`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/format_callback_write_char_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_format_callback_write_char_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_format_callback_write_char.awk`
- Promotion gate: `src/decomp/scripts/promote_format_callback_write_char_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_format_callback_write_char_trial_gcc.sh`
- `bash src/decomp/scripts/promote_format_callback_write_char_target_gcc.sh`

Current notes:
- GCC may reorder local byte-normalization and pointer update instructions while preserving behavior.
- Semantic gate validates callback byte-count increment, buffer-pointer load, remaining-space decrement/overflow branch, local store path, and overflow helper call.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 023: `modules/submodules/unknown13.s` (`FORMAT_FormatToCallbackBuffer`)

Status: promoted (GCC gate)

Why this target:
- Direct companion to Target 022 in the formatter callback pipeline.
- Adds global callback-state setup + `WDISP_FormatWithCallback` invocation + flush tail semantics.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/format_to_callback_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_format_to_callback_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_format_to_callback_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_format_to_callback_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_format_to_callback_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_format_to_callback_buffer_target_gcc.sh`

Current notes:
- GCC may alter stack/temporary handling for the varargs pointer passed into `WDISP_FormatWithCallback`; semantic gate focuses on behavior-critical markers.
- Semantic gate validates callback byte-count clear, callback-buffer global set, formatter callback call path, flush call with `-1`, and return of `Global_FormatCallbackByteCount`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 024: `modules/submodules/unknown9.s` (`FORMAT_U32ToOctalString`)

Status: promoted (GCC gate)

Why this target:
- Compact arithmetic formatter helper with no external calls.
- Complements decimal formatter (Target 006) with bit-mask/shift octal digit extraction.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/format_u32_to_octal_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_format_u32_octal_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_u32oct.awk`
- Promotion gate: `src/decomp/scripts/promote_format_u32_octal_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_format_u32_octal_trial_gcc.sh`
- `bash src/decomp/scripts/promote_format_u32_octal_target_gcc.sh`

Current notes:
- GCC may alter temp-buffer register allocation but preserves mask/shift/reverse-emit behavior.
- Semantic gate validates digit extraction (`&7`, `+ '0'`, `>>3`), reverse emission, NUL terminator write, and length-return path.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 025: `modules/submodules/unknown10.s` (`FORMAT_U32ToHexString`)

Status: promoted (GCC gate)

Why this target:
- Same reversible-digit formatter family as Targets 006/024 with lookup-table digit mapping.
- Adds nibble-table indexing behavior (`kHexDigitTable`) to the promoted arithmetic/string pipeline.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/format_u32_to_hex_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_format_u32_hex_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_u32hex.awk`
- Promotion gate: `src/decomp/scripts/promote_format_u32_hex_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_format_u32_hex_trial_gcc.sh`
- `bash src/decomp/scripts/promote_format_u32_hex_target_gcc.sh`

Current notes:
- GCC may emit equivalent nibble mask forms (`ANDI #15`, `AND #$F`) and vary pointer-increment placement around temp stores.
- Semantic gate validates nibble mask, hex-table lookup, `>>4`, reverse emission, NUL termination, and length-return path.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 026: `modules/submodules/unknown10.s` (`UNKNOWN10_PrintfPutcToBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small formatter-output helper with direct global pointer/count side effects.
- Bridges promoted formatter primitives toward `WDISP_SPrintf` by validating per-character append semantics.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/printf_putc_to_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_printf_putc_to_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_printf_putc_to_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_printf_putc_to_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_printf_putc_to_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_printf_putc_to_buffer_target_gcc.sh`

Current notes:
- GCC may express pointer increment either as post-increment store or explicit `LEA/ADDQ` before store-back.
- Semantic gate validates byte-count increment, buffer-pointer load/store-back, byte write, pointer advance, and function return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 027: `modules/submodules/unknown10.s` (`WDISP_SPrintf`)

Status: promoted (GCC gate)

Why this target:
- Direct companion to Target 026 in the local printf pipeline.
- Adds callback setup and output NUL-termination semantics for caller-provided buffer formatting.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/wdisp_sprintf_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_wdisp_sprintf_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_wdisp_sprintf.awk`
- Promotion gate: `src/decomp/scripts/promote_wdisp_sprintf_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_wdisp_sprintf_trial_gcc.sh`
- `bash src/decomp/scripts/promote_wdisp_sprintf_target_gcc.sh`

Current notes:
- GCC may vary stack/temporary handling for the varargs pointer passed into `WDISP_FormatWithCallback`.
- Semantic gate validates printf-count clear, printf-buffer global set, callback reference/call path, NUL termination at current write pointer, and count return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 028: `modules/submodules/unknown10.s` (`PARSE_ReadSignedLong_NoBranch`)

Status: promoted (GCC gate)

Why this target:
- Self-contained numeric parser loop with optional sign handling and no external calls.
- Adds first promoted parse primitive with arithmetic accumulation and consumed-length return.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parse_read_signed_long_nobranch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parse_read_signed_long_nobranch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parse_signed_long_nobranch.awk`
- Promotion gate: `src/decomp/scripts/promote_parse_read_signed_long_nobranch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parse_read_signed_long_nobranch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parse_read_signed_long_nobranch_target_gcc.sh`

Current notes:
- GCC may implement multiply-by-10 with shift/add chains or a multiply instruction sequence; semantic gate allows both.
- Semantic gate validates sign checks, digit conversion/range guards, accumulation step, conditional negate, output store, and consumed-length return math.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 029: `modules/submodules/unknown10.s` (`PARSE_ReadSignedLong`)

Status: promoted (GCC gate)

Why this target:
- Sibling parser entrypoint to Target 028 with near-identical numeric semantics.
- Promotes the paired signed-long parse path used by existing callsites.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parse_read_signed_long_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parse_read_signed_long_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parse_signed_long_nobranch.awk`
- Promotion gate: `src/decomp/scripts/promote_parse_read_signed_long_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parse_read_signed_long_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parse_read_signed_long_target_gcc.sh`

Current notes:
- GCC shape differences mirror Target 028 (sign byte cached in register; digit conversion via add against `-48` literal).
- Semantic gate reuse is intentional; it validates sign handling, digit guards, accumulation, negate-on-minus, output store, and consumed-length return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 030: `modules/submodules/unknown7.s` (`STR_CopyUntilAnyDelimN`)

Status: promoted (GCC gate)

Why this target:
- Remaining compact standalone helper in the already-promoted `unknown7.s` string cluster.
- Adds bounded-copy semantics with delimiter-set stop behavior and source-tail pointer return.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/str_copy_until_any_delim_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_str_copy_until_any_delim_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_str_copy_until_any_delim_n.awk`
- Promotion gate: `src/decomp/scripts/promote_str_copy_until_any_delim_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_str_copy_until_any_delim_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_str_copy_until_any_delim_n_target_gcc.sh`

Current notes:
- GCC may lower delimiter scanning as either index-based or post-increment pointer loops while preserving stop-on-delimiter semantics.
- Semantic gate validates max-length guard, source/delimiter tests, delimiter compare loop, copy path, destination NUL termination, and `src + copied` return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 031: `modules/submodules/unknown15.s` (`STREAM_ReadLineWithLimit`)

Status: promoted (GCC gate)

Why this target:
- Compact stream helper with bounded loop, refill helper call, and clear return-state split.
- Adds first promoted line-reader primitive with EOF/newline/length stop conditions.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/stream_read_line_with_limit_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_stream_read_line_with_limit_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_stream_read_line_with_limit.awk`
- Promotion gate: `src/decomp/scripts/promote_stream_read_line_with_limit_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_stream_read_line_with_limit_trial_gcc.sh`
- `bash src/decomp/scripts/promote_stream_read_line_with_limit_target_gcc.sh`

Current notes:
- GCC may represent stream-byte fast-path as post-increment pointer loads and express length loops with `DBRA` or equivalent counter branches.
- Semantic gate validates limit guard, stream count decrement, refill call path, EOF check, destination write loop, newline stop, NUL termination, and dual return modes (`0` vs start pointer).
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 032: `modules/submodules/unknown17.s` (`DOS_WriteWithErrorState`)

Status: promoted (GCC gate)

Why this target:
- Small DOS wrapper with well-defined error-state side effects.
- Extends promoted DOS helper coverage from index wrappers to the direct write path.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_write_with_error_state_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_write_with_error_state_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_write_with_error_state.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_write_with_error_state_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_write_with_error_state_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_write_with_error_state_target_gcc.sh`

Current notes:
- GCC may call DOS write/ioerr helpers through different symbol spellings than the original LVO form; semantic gate accepts either helper-name family.
- Semantic gate validates optional signal callback path, `Global_DosIoErr` clear, write call, `-1` error check, ioerr capture, `Global_AppErrorCode=5`, and result return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 033: `modules/submodules/unknown19.s` (`DOS_ReadWithErrorState`)

Status: promoted (GCC gate)

Why this target:
- Direct companion to Target 032 with the same error-state side effects on the read path.
- Builds a matched read/write pair for DOS wrapper coverage before moving into larger handle/open flows.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_read_with_error_state_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_read_with_error_state_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_read_with_error_state.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_read_with_error_state_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_read_with_error_state_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_read_with_error_state_target_gcc.sh`

Current notes:
- GCC may call DOS read/ioerr helpers through different symbol spellings than the original LVO form; semantic gate accepts either helper-name family.
- Semantic gate validates optional signal callback path, `Global_DosIoErr` clear, read call, `-1` error check, ioerr capture, `Global_AppErrorCode=5`, and result return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 034: `modules/submodules/unknown18.s` (`DOS_SeekWithErrorState`)

Status: promoted (GCC gate)

Why this target:
- Companion to Targets 032/033, completing the core direct DOS read/write/seek wrapper trio.
- Adds mode-dependent return adjustments and second-seek path semantics on top of standard error-state tracking.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_seek_with_error_state_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_seek_with_error_state_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_seek_with_error_state.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_seek_with_error_state_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_seek_with_error_state_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_seek_with_error_state_target_gcc.sh`

Current notes:
- GCC may call seek/ioerr helpers through either plain helper symbols (`DOS_Seek`/`DOS_IoErr`) or LVO forms; semantic gate accepts both.
- Semantic gate validates signal callback path, ioerr clear, initial seek call (`mode-2`), error capture with `Global_AppErrorCode=22`, mode-branch logic, mode-1 return adjustment (`seek_result + offset`), mode-0 direct offset return, and mode-2 second seek path.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 035: `modules/submodules/unknown30.s` (`EXEC_CallVector_348`)

Status: promoted (GCC gate)

Why this target:
- Very small register-forwarding wrapper with no local control-flow complexity.
- Good low-risk target to expand non-DOS system-call wrapper coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/exec_call_vector_348_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_exec_call_vector_348_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_exec_call_vector_348.awk`
- Promotion gate: `src/decomp/scripts/promote_exec_call_vector_348_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_exec_call_vector_348_trial_gcc.sh`
- `bash src/decomp/scripts/promote_exec_call_vector_348_target_gcc.sh`

Current notes:
- GCC lane uses an inline-asm body to preserve this register-passthrough wrapper shape and avoid optimizer-introduced argument shuffling.
- Semantic gate validates saved-register prologue, argument register loads from stack, `_LVOFreeTrap` call presence, restore epilogue, and final `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 036: `modules/submodules/unknown23.s` (`HANDLE_GetEntryByIndex`)

Status: promoted (GCC gate)

Why this target:
- Small pure-logic helper with no external calls and high fan-out across DOS/index paths.
- Adds a foundational bounds+entry-validation primitive to the promoted set.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/handle_get_entry_by_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_handle_get_entry_by_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_handle_get_entry_by_index.awk`
- Promotion gate: `src/decomp/scripts/promote_handle_get_entry_by_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_handle_get_entry_by_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_handle_get_entry_by_index_target_gcc.sh`

Current notes:
- GCC may choose different index-scaling idioms (`ASL #3` vs additive sequence) and alternate compare ordering for bounds checks.
- Semantic gate validates `Global_DosIoErr` clear, negative/upper bound guards, table-index scaling, entry-flag validity test, invalid-path `Global_AppErrorCode=9` with null return, and valid pointer return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 037: `modules/submodules/unknown22.s` (`DOS_CloseWithSignalCheck`)

Status: promoted (GCC gate)

Why this target:
- Very small wrapper with one optional side-path and fixed return value.
- Completes a close-path companion to the already-promoted read/write/seek wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_close_with_signal_check_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_close_with_signal_check_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_close_with_signal_check.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_close_with_signal_check_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_close_with_signal_check_target_gcc.sh`

Current notes:
- GCC may call close through `DOS_Close` helper symbol or `_LVOClose` form; semantic gate accepts either.
- Semantic gate validates signal-callback test/call path, close call presence, explicit zero return, and final `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 038: `modules/submodules/unknown21.s` (`IOSTDREQ_Free`)

Status: promoted (GCC gate)

Why this target:
- Small, isolated cleanup helper with fixed-size free and a few deterministic field writes.
- Good next step before the more complex msgport/signal cleanup routine in the same module.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/iostdreq_free_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_iostdreq_free_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_iostdreq_free.awk`
- Promotion gate: `src/decomp/scripts/promote_iostdreq_free_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_iostdreq_free_trial_gcc.sh`
- `bash src/decomp/scripts/promote_iostdreq_free_target_gcc.sh`

Current notes:
- GCC lane keeps the FreeMem LVO call in inline asm to maintain call shape while allowing C for the fixed field invalidation writes.
- Semantic gate validates writes of invalid markers at offsets `+8`, `+20`, `+24`, fixed size argument `48`, FreeMem call presence, and final `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 039: `modules/submodules/unknown21.s` (`IOSTDREQ_CleanupSignalAndMsgport`)

Status: promoted (GCC gate)

Why this target:
- Direct companion cleanup routine to Target 038 in the same small subsystem.
- Adds conditional port removal path plus signal and memory cleanup sequencing.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/iostdreq_cleanup_signal_and_msgport_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_iostdreq_cleanup_signal_and_msgport.awk`
- Promotion gate: `src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`
- `bash src/decomp/scripts/promote_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`

Current notes:
- GCC lane uses inline LVO calls for `RemPort`, `FreeSignal`, and `FreeMem`, with C preserving field update logic and call ordering.
- Semantic gate validates linked-port test, optional `RemPort` call, field invalidation writes (`+8`, `+20`), signal-number load from `+15`, `FreeSignal`, fixed free size `34`, and final `FreeMem` call.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 040: `modules/submodules/unknown22.s` (`MATH_Mulu32`)

Status: promoted (GCC gate)

Why this target:
- Small standalone arithmetic helper with no external state and no side effects.
- Good low-risk bridge from wrapper/IO-heavy targets into pure numeric helper coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/math_mulu32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_math_mulu32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_math_mulu32.awk`
- Promotion gate: `src/decomp/scripts/promote_math_mulu32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_math_mulu32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_math_mulu32_target_gcc.sh`

Current notes:
- GCC may lower `u32` multiply via `MULU` instructions or helper-call sequences depending on profile/allocator; semantic gate accepts either.
- Semantic gate validates multiplication presence, return path, and final `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 041: `modules/submodules/unknown26.s` (`DOS_WriteByIndex`)

Status: promoted (GCC gate)

Why this target:
- Direct companion to already-promoted index wrappers (`DOS_ReadByIndex`, `DOS_SeekByIndex`) using the same handle-entry lookup pattern.
- Adds optional seek-before-write branch via handle-flag bit test.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_write_by_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_write_by_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_write_by_index.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_write_by_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_write_by_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_write_by_index_target_gcc.sh`

Current notes:
- GCC may represent the seek-bit test either as direct `BTST #3` or masked-byte logic against entry offset `+3`; semantic gate accepts both.
- Semantic gate validates handle lookup call, null-entry guard, optional seek call path, write call path, ioerr test, and `-1` error mapping.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 042: `modules/submodules/unknown22.s` (`ALLOCATE_AllocAndInitializeIOStdReq`)

Status: promoted (GCC gate)

Why this target:
- Compact allocation helper with one guard path and deterministic initialization writes.
- Useful bridge between memory wrappers and more complex msgport/device allocation routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/allocate_alloc_and_initialize_iostdreq_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_allocate_alloc_and_initialize_iostdreq_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_allocate_alloc_and_initialize_iostdreq.awk`
- Promotion gate: `src/decomp/scripts/promote_allocate_alloc_and_initialize_iostdreq_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_allocate_alloc_and_initialize_iostdreq_trial_gcc.sh`
- `bash src/decomp/scripts/promote_allocate_alloc_and_initialize_iostdreq_target_gcc.sh`

Current notes:
- GCC lane keeps `AllocMem` as inline LVO call while preserving null-guard behavior and message-header field writes in C.
- Semantic gate validates null-arg guard, alloc size/flags, alloc call and null-result guard, message `type/pri/reply-port` stores, and return mode (`0` or allocated pointer).
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 043: `modules/submodules/unknown22.s` (`MATH_DivS32`)

Status: promoted (GCC gate)

Why this target:
- Compact signed-wrapper helper around already-known unsigned division core (`MATH_DivU32`).
- Adds sign-normalization and result-sign restoration control flow to promoted arithmetic coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/math_divs32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_math_divs32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_math_divs32.awk`
- Promotion gate: `src/decomp/scripts/promote_math_divs32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_math_divs32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_math_divs32_target_gcc.sh`

Current notes:
- GCC may fold sign tests and negations into alternate branch orderings, but still preserve the same divide-core call and sign-fix semantics.
- Semantic gate validates sign tests, dividend/divisor negations, `MATH_DivU32` call presence, possible result negation, and function return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 044: `modules/submodules/unknown21.s` (`DOS_OpenNewFileIfMissing`)

Status: promoted (GCC gate)

Why this target:
- Medium-small DOS helper with clear behavior: fail-fast if file exists, otherwise open new file.
- Extends promoted filesystem-open flows before tackling larger delete/recreate and mode-routing paths.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_open_new_file_if_missing_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_open_new_file_if_missing_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_open_new_file_if_missing.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_open_new_file_if_missing_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_open_new_file_if_missing_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_open_new_file_if_missing_target_gcc.sh`

Current notes:
- GCC may express lock/open checks with reordered branch labels, but semantics remain: signal callback, ioerr clear, lock test, unlock-on-exists, open-newfile path, ioerr capture, `AppErrorCode=2`, and `-1` error return.
- Semantic gate validates all behavior-critical calls and state writes independent of register allocation differences.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 045: `modules/submodules/unknown21.s` (`DOS_DeleteAndRecreateFile`)

Status: promoted (GCC gate)

Why this target:
- Direct companion to Target 044 in the same module and call-family.
- Adds delete-on-exists behavior before new-file open while keeping the same ioerr/error-code mapping.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_delete_and_recreate_file_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_delete_and_recreate_file_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_delete_and_recreate_file.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_delete_and_recreate_file_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_delete_and_recreate_file_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_delete_and_recreate_file_target_gcc.sh`

Current notes:
- GCC may reorder lock-check branches but preserves the key sequence: lock, unlock/delete when present, open MODE_NEWFILE, ioerr capture, and `AppErrorCode=2` on open failure.
- Semantic gate validates signal callback path, lock/unlock/delete/open/ioerr call presence, ioerr store, `-1` mapping, and error-code write behavior.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 046: `modules/submodules/unknown22.s` (`SIGNAL_CreateMsgPortWithSignal`)

Status: promoted (GCC gate)

Why this target:
- Compact Exec utility with one allocation-failure unwind and deterministic MsgPort initialization writes.
- Complements already-promoted `ALLOCATE_AllocAndInitializeIOStdReq` and `IOSTDREQ_CleanupSignalAndMsgport` by covering MsgPort creation.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/signal_create_msgport_with_signal_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_signal_create_msgport_with_signal_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_signal_create_msgport_with_signal.awk`
- Promotion gate: `src/decomp/scripts/promote_signal_create_msgport_with_signal_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_signal_create_msgport_with_signal_trial_gcc.sh`
- `bash src/decomp/scripts/promote_signal_create_msgport_with_signal_target_gcc.sh`

Current notes:
- GCC may vary branch shape around name-null `AddPort` vs local-list initialization, but semantic behavior remains equivalent.
- Semantic gate validates alloc-signal/alloc-mem/free-signal paths, MsgPort field stores, task binding (`FindTask`), optional `AddPort`, local-list initialization, and return mode.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 047: `modules/submodules/unknown40.s` (`DOS_Delay`)

Status: promoted (GCC gate)

Why this target:
- Very small DOS wrapper with a single LVO call and one argument move, ideal for fast incremental coverage.
- Starts promotion coverage for `unknown40.s` runtime wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_delay_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_delay_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_delay.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_delay_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_delay_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_delay_target_gcc.sh`

Current notes:
- GCC may choose different stack/register setup around the argument load, but still routes the tick count through `D1` and dispatches `_LVODelay` with the DOS base.
- Semantic gate validates DOS library base usage, `D1` argument flow, delay call presence, and function return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 048: `modules/submodules/unknown40.s` (`BATTCLOCK_GetSecondsFromBatteryBackedClock`)

Status: promoted (GCC gate)

Why this target:
- Minimal read-wrapper with no branching, useful for quickly expanding promoted call-wrapper coverage.
- Pairs naturally with existing clock/time promotion work while staying low-risk.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/battclock_get_seconds_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_battclock_get_seconds_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_battclock_get_seconds.awk`
- Promotion gate: `src/decomp/scripts/promote_battclock_get_seconds_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_battclock_get_seconds_trial_gcc.sh`
- `bash src/decomp/scripts/promote_battclock_get_seconds_target_gcc.sh`

Current notes:
- GCC may choose different save/restore placement for `A6`, but still loads the battclock resource base and dispatches `_LVOReadBattClock`.
- Semantic gate validates resource-base usage, battclock read call presence, and return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 049: `modules/submodules/unknown40.s` (`BATTCLOCK_WriteSecondsToBatteryBackedClock`)

Status: promoted (GCC gate)

Why this target:
- Direct write companion to Target 048, with similarly low control-flow complexity.
- Expands coverage of battery clock wrappers and validates D0 argument-through-call behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/battclock_write_seconds_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_battclock_write_seconds_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_battclock_write_seconds.awk`
- Promotion gate: `src/decomp/scripts/promote_battclock_write_seconds_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_battclock_write_seconds_trial_gcc.sh`
- `bash src/decomp/scripts/promote_battclock_write_seconds_target_gcc.sh`

Current notes:
- GCC may vary prologue shape, but still loads `Global_REF_BATTCLOCK_RESOURCE` into `A6`, routes the input seconds in `D0`, and calls `_LVOWriteBattClock`.
- Semantic gate validates resource-base usage, D0 argument flow, write call presence, and return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 050: `modules/submodules/unknown40.s` (`DOS_SystemTagList`)

Status: promoted (GCC gate)

Why this target:
- Small DOS wrapper with two register arguments and one LVO call.
- Complements Target 047 (`DOS_Delay`) and rounds out simple `unknown40.s` DOS call wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_system_taglist_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_system_taglist_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_system_taglist.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_system_taglist_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_system_taglist_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_system_taglist_target_gcc.sh`

Current notes:
- GCC may choose different register-save ordering, but still loads DOS base, routes arguments through `D1/D2`, and calls `_LVOSystemTagList`.
- Semantic gate validates DOS base usage, `D1`/`D2` flow, system-tag call presence, and return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 051: `modules/submodules/unknown40.s` (`EXEC_CallVector_48`)

Status: promoted (GCC gate)

Why this target:
- Final small wrapper in `unknown40.s`, with a single library-vector dispatch.
- Extends coverage of register-heavy wrapper patterns (`A0/A1/D1/A2` argument forwarding).

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/exec_call_vector_48_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_exec_call_vector_48_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_exec_call_vector_48.awk`
- Promotion gate: `src/decomp/scripts/promote_exec_call_vector_48_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_exec_call_vector_48_trial_gcc.sh`
- `bash src/decomp/scripts/promote_exec_call_vector_48_target_gcc.sh`

Current notes:
- GCC may reorder prologue register saves, but still loads `INPUTDEVICE_LibraryBaseFromConsoleIo`, forwards `A0/A1/D1/A2`, and calls `_LVOexecPrivate3`.
- Semantic gate validates input-device base usage, register flow (`A0/A1/D1/A2`), vector call presence, and return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 052: `modules/submodules/unknown42.s` (`PARALLEL_CheckReadyStub`)

Status: promoted (GCC gate)

Why this target:
- Minimal deterministic stub with a single `MOVEQ #-1,D0; RTS` sequence.
- Good low-risk bridge into `unknown42.s` before larger parallel formatting routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_check_ready_stub_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_check_ready_stub_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_check_ready_stub.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_check_ready_stub_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_check_ready_stub_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_check_ready_stub_target_gcc.sh`

Current notes:
- GCC may emit equivalent constant-load forms for `-1`, but behavior remains fixed: return negative ready-state sentinel.
- Semantic gate validates `-1` return constant path and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 053: `modules/submodules/unknown2a.s` (`UNKNOWN2A_Stub0`)

Status: promoted (GCC gate)

Why this target:
- Smallest standalone XDEF in the set (pure `RTS`) and trivial to lock down.
- Expands promoted coverage into `unknown2a.s` with near-zero risk.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown2a_stub0_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown2a_stub0_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown2a_stub0.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown2a_stub0_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown2a_stub0_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown2a_stub0_target_gcc.sh`

Current notes:
- GCC may add/remove no-op prologue details depending on profile, but function semantics remain empty-return.
- Semantic gate validates `RTS` presence.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 054: `modules/submodules/unknown42.s` (`PARALLEL_CheckReady`)

Status: promoted (GCC gate)

Why this target:
- Thin wrapper directly above Target 052 with one call + return.
- Confirms simple local-call wrappers in `unknown42.s` before deeper parallel routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_check_ready_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_check_ready_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_check_ready.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_check_ready_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_check_ready_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_check_ready_target_gcc.sh`

Current notes:
- GCC may vary call syntax (`BSR`/`JSR`) but preserves single dispatch to `PARALLEL_CheckReadyStub` and immediate return.
- Semantic gate validates stub-call presence and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 055: `modules/submodules/unknown42.s` (`PARALLEL_WriteCharD0`)

Status: promoted (GCC gate)

Why this target:
- Another single-call wrapper (`PARALLEL_WriteCharHw`) with no branching.
- Establishes parity for D0-based parallel output wrapper behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_write_char_d0_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_write_char_d0_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_write_char_d0.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_write_char_d0_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_write_char_d0_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_write_char_d0_target_gcc.sh`

Current notes:
- GCC may model the call as external symbol dispatch with minor prologue differences, but still forwards the character and returns immediately.
- Semantic gate validates `PARALLEL_WriteCharHw` call presence and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 056: `modules/submodules/unknown42.s` (`CLOCK_SecondsFromEpoch`)

Status: promoted (GCC gate)

Why this target:
- Compact utility-library wrapper with one pointer argument and one LVO call.
- Extends promoted coverage for `unknown42.s` clock conversion wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/clock_seconds_from_epoch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_clock_seconds_from_epoch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_clock_seconds_from_epoch.awk`
- Promotion gate: `src/decomp/scripts/promote_clock_seconds_from_epoch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_clock_seconds_from_epoch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_clock_seconds_from_epoch_target_gcc.sh`

Current notes:
- GCC may vary stack/register shuffling but still loads `Global_REF_UTILITY_LIBRARY`, forwards the input pointer via `A0`, and calls `_LVODate2Amiga`.
- Semantic gate validates utility base usage, `A0` argument flow, call presence, and return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 057: `modules/submodules/unknown42.s` (`CLOCK_CheckDateOrSecondsFromEpoch`)

Status: promoted (GCC gate)

Why this target:
- Companion wrapper to Target 056 with same call pattern but different utility LVO (`CheckDate`).
- Increases confidence in utility wrapper lowering consistency.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/clock_check_date_or_seconds_from_epoch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_clock_check_date_or_seconds_from_epoch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_clock_check_date_or_seconds_from_epoch.awk`
- Promotion gate: `src/decomp/scripts/promote_clock_check_date_or_seconds_from_epoch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_clock_check_date_or_seconds_from_epoch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_clock_check_date_or_seconds_from_epoch_target_gcc.sh`

Current notes:
- GCC may choose alternate register-save order, but behavior remains utility-base load + `A0` arg + `_LVOCheckDate` dispatch + return.
- Semantic gate validates utility base usage, `A0` flow, call presence, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 058: `modules/submodules/unknown42.s` (`PARALLEL_WaitReady`)

Status: promoted (GCC gate)

Why this target:
- Small control-flow step up from wrappers: single polling loop with no side-effects besides repeated readiness checks.
- Builds confidence in loop-shape preservation in the same module.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_wait_ready_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_wait_ready_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_wait_ready.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_wait_ready_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_wait_ready_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_wait_ready_target_gcc.sh`

Current notes:
- GCC may use different branch mnemonics around the negative test, but preserves repeated `PARALLEL_CheckReady` calls until non-negative.
- Semantic gate validates readiness-check call presence, loop branch presence, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 059: `modules/submodules/unknown42.s` (`PARALLEL_WriteStringLoop`)

Status: promoted (GCC gate)

Why this target:
- Simple byte-stream loop that repeatedly dispatches to already-promoted `PARALLEL_WriteCharD0`.
- Keeps momentum in `unknown42.s` while adding first string-output loop primitive.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_write_string_loop_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_write_string_loop_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_write_string_loop.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_write_string_loop_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_write_string_loop_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_write_string_loop_target_gcc.sh`

Current notes:
- GCC may vary compare/branch mnemonics around the NUL terminator test, but preserves byte load, zero-test, per-byte `PARALLEL_WriteCharD0` dispatch, and loop backedge.
- Semantic gate validates byte-load, termination test, write-call presence, loop branch, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 060: `modules/submodules/unknown42.s` (`PARALLEL_RawDoFmt`)

Status: promoted (GCC gate)

Why this target:
- Self-contained exec-library wrapper for `RawDoFmt` in the same module family.
- Establishes first promoted target that wires callback register `A2` to `PARALLEL_WriteCharHw`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_raw_dofmt_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_raw_dofmt_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_raw_dofmt.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_raw_dofmt_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_raw_dofmt_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_raw_dofmt_target_gcc.sh`

Current notes:
- GCC may omit the original explicit `MOVEM` save/restore pair, but preserves callback pointer setup (`PARALLEL_WriteCharHw` via `A2`), exec base load, `_LVORawDoFmt` dispatch, and return.
- Semantic gate validates callback-pointer setup, exec-base usage, RawDoFmt call presence, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 061: `modules/submodules/unknown42.s` (`PARALLEL_WriteCharHw`)

Status: promoted (GCC gate)

Why this target:
- Core low-level parallel output primitive used by promoted wrappers.
- Introduces first promoted hardware polling loop (`CIAB_PRA bit0`) plus LF-to-CR/LF behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_write_char_hw_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_write_char_hw_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_write_char_hw.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_write_char_hw_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_write_char_hw_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_write_char_hw_target_gcc.sh`

Current notes:
- GCC reorders loop blocks versus original but preserves LF check, ready-bit polling loop, and writes to `CIAA_DDRB`/`CIAA_PRB`.
- Semantic gate validates LF check presence, wait-loop pattern, hardware register writes, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 062: `modules/submodules/unknown42.s` (`PARALLEL_RawDoFmtStackArgs`)

Status: promoted (GCC gate)

Why this target:
- Compact wrapper that prepares stack-based vararg stream and forwards into `PARALLEL_RawDoFmtCommon`.
- Extends promoted coverage across the `PARALLEL_RawDoFmt*` wrapper family.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_raw_dofmt_stack_args_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_raw_dofmt_stack_args_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_raw_dofmt_stack_args.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_raw_dofmt_stack_args_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_raw_dofmt_stack_args_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_raw_dofmt_stack_args_target_gcc.sh`

Current notes:
- Original uses fallthrough into `PARALLEL_RawDoFmtCommon` while GCC emits explicit stack setup + call; both preserve format/arg-stream forwarding semantics.
- Semantic gate validates format-setup, arg-stream setup, common-dispatch presence, and return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 063: `modules/submodules/unknown42.s` (`PARALLEL_RawDoFmtCommon`)

Status: promoted (GCC gate)

Why this target:
- Central dispatch helper for the parallel RawDoFmt wrappers.
- Bridges promoted stack-wrapper behavior (`Target 062`) to promoted RawDoFmt core (`Target 060`).

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parallel_raw_dofmt_common_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parallel_raw_dofmt_common_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parallel_raw_dofmt_common.awk`
- Promotion gate: `src/decomp/scripts/promote_parallel_raw_dofmt_common_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parallel_raw_dofmt_common_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parallel_raw_dofmt_common_target_gcc.sh`

Current notes:
- Original includes callback-save/setup details around the call path, while GCC collapses to a compact forwarding wrapper; both preserve dispatch to `PARALLEL_RawDoFmt` and return.
- Semantic gate validates RawDoFmt reference presence and return.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 064: `modules/submodules/unknown25.s` (`STRUCT_FreeWithSizeField`)

Status: promoted (GCC gate)

Why this target:
- Small, isolated lifecycle helper with one Exec call and clear field-side effects.
- Opens follow-on promotion path for companion allocator `STRUCT_AllocWithOwner`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/struct_free_with_size_field_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_struct_free_with_size_field_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_struct_free_with_size_field.awk`
- Promotion gate: `src/decomp/scripts/promote_struct_free_with_size_field_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_struct_free_with_size_field_trial_gcc.sh`
- `bash src/decomp/scripts/promote_struct_free_with_size_field_target_gcc.sh`

Current notes:
- GCC uses equivalent idioms (`ST` for `0xFF`, register `-1` stores) while preserving size-load-from-`+18`, `FreeMem` dispatch, and return.
- Semantic gate validates invalidation store, `-1` field stores, size load, `FreeMem` call presence, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 065: `modules/submodules/unknown25.s` (`STRUCT_AllocWithOwner`)

Status: promoted (GCC gate)

Why this target:
- Companion allocator for Target 064 with straightforward owner guard, `AllocMem`, and fixed field initialization.
- Extends coverage for struct lifecycle helpers in `unknown25.s`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/struct_alloc_with_owner_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_struct_alloc_with_owner_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_struct_alloc_with_owner.awk`
- Promotion gate: `src/decomp/scripts/promote_struct_alloc_with_owner_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_struct_alloc_with_owner_trial_gcc.sh`
- `bash src/decomp/scripts/promote_struct_alloc_with_owner_target_gcc.sh`

Current notes:
- GCC may reorder guard/initialization blocks but preserves owner-null check, `AllocMem` dispatch, and struct field writes (`+8/+9/+14/+18`).
- Semantic gate validates owner check presence, alloc call, field initialization, size store, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 066: `modules/submodules/unknown20.s` (`DOS_OpenWithErrorState`)

Status: promoted (GCC gate)

Why this target:
- Completes parity with existing error-state wrappers (`DOS_Read/Seek/WriteWithErrorState`).
- Compact control-flow shape with clear side effects (`Global_DosIoErr`, `Global_AppErrorCode`).

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_open_with_error_state_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_open_with_error_state_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_open_with_error_state.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_open_with_error_state_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_open_with_error_state_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_open_with_error_state_target_gcc.sh`

Current notes:
- GCC may vary zero-check idioms around handle failure, but preserves signal callback check, `DOS_Open` call, `DOS_IoErr` path, app error code set to `2`, and `-1` failure return.
- Semantic gate validates callback test/call, ioerr clear+store, open/ioerr calls, failure code path, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 067: `modules/submodules/unknown37.s` (`HANDLE_CloseByIndex`)

Status: promoted (GCC gate)

Why this target:
- Natural follow-on after `HANDLE_GetEntryByIndex` and `DOS_CloseWithSignalCheck` promotions.
- Consolidates handle lifecycle behavior (entry lookup, optional close, clear, IoErr-driven status).

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/handle_close_by_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_handle_close_by_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_handle_close_by_index.awk`
- Promotion gate: `src/decomp/scripts/promote_handle_close_by_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_handle_close_by_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_handle_close_by_index_target_gcc.sh`

Current notes:
- GCC may emit different branch/register idioms for null/flag checks, but preserves entry lookup, non-closable fast-clear path, close path, entry clear, and IoErr-based `-1` status.
- Semantic gate validates get-entry call, null/flag checks, close call, entry clear, ioerr test, return shapes, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 068: `modules/submodules/unknown35.s` (`HANDLE_OpenWithMode`)

Status: promoted (GCC gate)

Why this target:
- Natural next step in handle lifecycle after `HANDLE_CloseByIndex` and earlier handle-table targets.
- Captures scan-for-free + fallback-allocate flow and dispatch into mode-string open helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/handle_open_with_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_handle_open_with_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_handle_open_with_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_handle_open_with_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_handle_open_with_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_handle_open_with_mode_target_gcc.sh`

Current notes:
- GCC may rearrange loop/branch structure, but preserves prealloc scan, `ALLOC_AllocFromFreeList(34)` fallback, zero-init on fresh alloc, and `HANDLE_OpenFromModeString` dispatch.
- Semantic gate validates scan symbols, alloc call + size, zero-init behavior, open-mode call, null-return path, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 069: `modules/submodules/unknown33.s` (`STRING_FindSubstring`)

Status: promoted (GCC gate)

Why this target:
- Small, self-contained string-search routine with no external helper calls.
- Good next step after the `STR_Find*` family to cover direct two-pointer compare loops.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/string_find_substring_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_string_find_substring_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_string_find_substring.awk`
- Promotion gate: `src/decomp/scripts/promote_string_find_substring_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_string_find_substring_trial_gcc.sh`
- `bash src/decomp/scripts/promote_string_find_substring_target_gcc.sh`

Current notes:
- GCC may choose different mismatch/advance block ordering versus source, but preserves byte-compare loop behavior, early null-fail paths, successful match pointer return, and `RTS`.
- Semantic gate validates needle-end tests, byte-compare presence, start-advance progression, null/success return forms, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 070: `modules/submodules/unknown38.s` (`SIGNAL_PollAndDispatch`)

Status: promoted (GCC gate)

Why this target:
- Small control-flow helper with one Exec call plus optional callback dispatch path.
- Natural follow-on after existing signal and close-wrapper promotions.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/signal_poll_and_dispatch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_signal_poll_and_dispatch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_signal_poll_and_dispatch.awk`
- Promotion gate: `src/decomp/scripts/promote_signal_poll_and_dispatch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_signal_poll_and_dispatch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_signal_poll_and_dispatch_target_gcc.sh`

Current notes:
- GCC may alter callback branch layout and register assignment, but preserves `_LVOSetSignal` poll, `0x3000` mask check, callback test/call, callback clear on non-zero result, close-with-code dispatch, and return path.
- Semantic gate validates those invariants directly.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 071: `modules/submodules/unknown24.s` (`PARSE_ReadSignedLongSkipClass3`)

Status: promoted (GCC gate)

Why this target:
- Small parse wrapper with null guard and two helper calls.
- Good bridge target in `unknown24.s` before larger MEMLIST routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parse_read_signed_long_skip_class3_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parse_read_signed_long_skip_class3_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parse_read_signed_long_skip_class3.awk`
- Promotion gate: `src/decomp/scripts/promote_parse_read_signed_long_skip_class3_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parse_read_signed_long_skip_class3_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parse_read_signed_long_skip_class3_target_gcc.sh`

Current notes:
- GCC may simplify frame/save handling versus original A3-preserving wrapper, but preserves null-input early return, class3 skip call, signed-long parse call, and parsed value return.
- Semantic gate validates null-guard, zero-return path, skip call, parse call, value-return form, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 072: `modules/submodules/unknown24.s` (`PARSE_ReadSignedLongSkipClass3_Alt`)

Status: promoted (GCC gate)

Why this target:
- Companion wrapper to Target 071 with the same shape but alternate parse helper call.
- Efficient incremental promotion inside `unknown24.s` with minimal new risk.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parse_read_signed_long_skip_class3_alt_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parse_read_signed_long_skip_class3_alt.awk`
- Promotion gate: `src/decomp/scripts/promote_parse_read_signed_long_skip_class3_alt_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parse_read_signed_long_skip_class3_alt_target_gcc.sh`

Current notes:
- GCC uses the same compact wrapper style as Target 071; key behavior is preserved: null guard, class3 skip call, `PARSE_ReadSignedLong_NoBranch` dispatch, parsed-value return.
- Semantic gate validates those invariants explicitly.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 073: `modules/submodules/unknown24.s` (`MEMLIST_FreeAll`)

Status: promoted (GCC gate)

Why this target:
- First non-wrapper stateful routine in `unknown24.s` with a short list-walk loop.
- Good entry point before larger allocator routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/memlist_free_all_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_memlist_free_all_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_memlist_free_all.awk`
- Promotion gate: `src/decomp/scripts/promote_memlist_free_all_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_memlist_free_all_trial_gcc.sh`
- `bash src/decomp/scripts/promote_memlist_free_all_target_gcc.sh`

Current notes:
- GCC may vary register and loop-block layout, but behavior remains: load memlist head, iterate nodes, free each block with its size, then clear both head/tail globals.
- Semantic gate validates load/next/size/call/loop/clear invariants and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 074: `modules/submodules/unknown32.s` (`UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode`)

Status: promoted (GCC gate)

Why this target:
- Tiny jump-table stub with single-target dispatch.
- Low-risk promotion that extends `unknown32.s` coverage before the larger handle-close routine.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown32_jmptbl_esq_return_with_stack_code_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown32_jmptbl_esq_return_with_stack_code_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown32_jmptbl_esq_return_with_stack_code.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown32_jmptbl_esq_return_with_stack_code_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown32_jmptbl_esq_return_with_stack_code_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown32_jmptbl_esq_return_with_stack_code_target_gcc.sh`

Current notes:
- Original uses direct `JMP ESQ_ReturnWithStackCode`; GCC may emit call/return form instead. Both preserve single-target forward dispatch semantics.
- Semantic gate validates target dispatch presence and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 075: `modules/submodules/unknown32.s` (`HANDLE_CloseAllAndReturnWithCode`)

Status: promoted (GCC gate)

Why this target:
- Core loop helper in `unknown32.s` with concrete handle-table semantics.
- Builds naturally on promoted `DOS_CloseWithSignalCheck` and Target 074 jump-stub dispatch.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/handle_close_all_and_return_with_code_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_handle_close_all_and_return_with_code_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_handle_close_all_and_return_with_code.awk`
- Promotion gate: `src/decomp/scripts/promote_handle_close_all_and_return_with_code_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_handle_close_all_and_return_with_code_trial_gcc.sh`
- `bash src/decomp/scripts/promote_handle_close_all_and_return_with_code_target_gcc.sh`

Current notes:
- GCC may alter loop/index register layout, but preserves count-based descending iteration, handle-entry flag read, bit-4 skip behavior, close-call dispatch for eligible entries, and final return-code dispatch via `UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode`.
- Semantic gate validates those loop/call invariants and terminal return path.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 076: `modules/submodules/unknown24.s` (`MEMLIST_AllocTracked`)

Status: promoted (GCC gate)

Why this target:
- Remaining non-trivial routine in `unknown24.s` after Targets 071-073.
- Extends MEMLIST coverage from free-path into allocate/link path with concrete global-state updates.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/memlist_alloc_tracked_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_memlist_alloc_tracked_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_memlist_alloc_tracked.awk`
- Promotion gate: `src/decomp/scripts/promote_memlist_alloc_tracked_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_memlist_alloc_tracked_trial_gcc.sh`
- `bash src/decomp/scripts/promote_memlist_alloc_tracked_target_gcc.sh`

Current notes:
- GCC may collapse A4-relative head/tail addressing into absolute-symbol loads/stores and may route `AllocMem` through a local helper, while preserving `size+12` allocation, null-return fast path, node link updates (head/tail/next/prev), first-node latch, and `node+12` return pointer.
- Semantic gate validates those invariants directly.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 077: `modules/submodules/unknown2a.s` (`FORMAT_RawDoFmtWithScratchBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small wrapper in `unknown2a.s` with straightforward argument forwarding.
- Extends coverage from prior `PARALLEL_RawDoFmtStackArgs` and formatter helper targets to this call-composition entrypoint.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/format_raw_dofmt_with_scratch_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_format_raw_dofmt_with_scratch_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`

Current notes:
- GCC may omit the small local spill slot and use direct stack argument addressing, while preserving scratch-buffer reference, `FORMAT_FormatToBuffer2` call, `PARALLEL_RawDoFmtStackArgs` call, and return path.
- Semantic gate validates those invariants directly.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 078: `modules/submodules/unknown2b.s` (`ESQ_MainEntryNoOpHook`)

Status: promoted (GCC gate)

Why this target:
- Trivial single-instruction no-op hook with stable semantics.
- Fast confidence target in `unknown2b.s` before larger stream and DOS helper routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esq_main_entry_noop_hook_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esq_main_entry_noop_hook_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esq_main_entry_noop_hook.awk`
- Promotion gate: `src/decomp/scripts/promote_esq_main_entry_noop_hook_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esq_main_entry_noop_hook_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esq_main_entry_noop_hook_target_gcc.sh`

Current notes:
- Original and GCC outputs reduce to `RTS` with minimal wrapper text differences.
- Semantic gate validates terminal `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 079: `modules/submodules/unknown2b.s` (`ESQ_MainExitNoOpHook`)

Status: promoted (GCC gate)

Why this target:
- Companion no-op hook to Target 078 with identical low-risk shape.
- Quickly increases `unknown2b.s` callable coverage while preserving strict binary gates.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esq_main_exit_noop_hook_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esq_main_exit_noop_hook_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esq_main_exit_noop_hook.awk`
- Promotion gate: `src/decomp/scripts/promote_esq_main_exit_noop_hook_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esq_main_exit_noop_hook_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esq_main_exit_noop_hook_target_gcc.sh`

Current notes:
- Original and GCC outputs reduce to `RTS` with minimal wrapper text differences.
- Semantic gate validates terminal `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 080: `modules/submodules/unknown2b.s` (`DOS_OpenFileWithMode`)

Status: promoted (GCC gate)

Why this target:
- Small DOS wrapper with concrete call semantics and no extra state side effects.
- Good bridge from no-op hooks into substantive `unknown2b.s` runtime helpers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_open_file_with_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_open_file_with_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_open_file_with_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_open_file_with_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_open_file_with_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_open_file_with_mode_target_gcc.sh`

Current notes:
- GCC may route argument setup through a local helper wrapper while preserving pass-through DOS Open semantics (`name`, `mode`, open-call, return code).
- Semantic gate validates argument forwarding/call/return invariants.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 081: `modules/submodules/unknown2b.s` (`GRAPHICS_AllocRaster`)

Status: promoted (GCC gate)

Why this target:
- Small graphics.library wrapper with stable two-argument call semantics.
- Natural next step in `unknown2b.s` before the paired free wrapper and larger stream code.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/graphics_alloc_raster_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_graphics_alloc_raster_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_graphics_alloc_raster.awk`
- Promotion gate: `src/decomp/scripts/promote_graphics_alloc_raster_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_graphics_alloc_raster_trial_gcc.sh`
- `bash src/decomp/scripts/promote_graphics_alloc_raster_target_gcc.sh`

Current notes:
- GCC may use a helper-call forwarding shape, while preserving width/height argument flow, graphics-library call path, and returned raster pointer.
- Semantic gate validates argument forwarding, alloc call presence, and terminal return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 082: `modules/submodules/unknown2b.s` (`GRAPHICS_FreeRaster`)

Status: promoted (GCC gate)

Why this target:
- Direct companion wrapper to Target 081 in the same module.
- Keeps `unknown2b.s` graphics wrapper pair aligned in C while preserving simple call semantics.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/graphics_free_raster_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_graphics_free_raster_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_graphics_free_raster.awk`
- Promotion gate: `src/decomp/scripts/promote_graphics_free_raster_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_graphics_free_raster_trial_gcc.sh`
- `bash src/decomp/scripts/promote_graphics_free_raster_target_gcc.sh`

Current notes:
- GCC may choose a compact register-forwarding form, while preserving raster pointer + width/height argument flow, graphics-library call path, and terminal return form.
- Semantic gate validates argument forwarding, free call presence, and `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 083: `modules/submodules/unknown2b.s` (`DOS_MovepWordReadCallback`)

Status: promoted (GCC gate)

Why this target:
- Tiny exported callback/code-label body used by translated write path.
- High-confidence low-risk step before larger buffered stream routines in the same module.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/dos_movep_word_read_callback_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_dos_movep_word_read_callback_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_dos_movep_word_read_callback.awk`
- Promotion gate: `src/decomp/scripts/promote_dos_movep_word_read_callback_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_dos_movep_word_read_callback_trial_gcc.sh`
- `bash src/decomp/scripts/promote_dos_movep_word_read_callback_target_gcc.sh`

Current notes:
- This symbol is emitted as a raw asm label body (not a normal C ABI wrapper), preserving the `MOVEP.W 0(A2),D6` + pad-word shape used by callback-pointer callsites.
- Semantic gate validates `MOVEP` callback body plus trailing pad word.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 084: `modules/submodules/unknown.s` (`UNKNOWN_ParseListAndUpdateEntries`)

Status: promoted (GCC gate)

Why this target:
- First non-trivial parse/update routine promoted from `unknown.s`, expanding coverage beyond wrapper-style helpers.
- Exercises wildcard match, day normalization, parsed numeric fields, and row update semantics through a single exported function.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown_parse_list_and_update_entries_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown_parse_list_and_update_entries_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown_parse_list_and_update_entries.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown_parse_list_and_update_entries_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown_parse_list_and_update_entries_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown_parse_list_and_update_entries_target_gcc.sh`

Current notes:
- C candidate preserves the 0x12-terminated list-name parse, wildcard guard, fixed row initialization (`4x`, stride `20`), and `+`-record field update semantics including `?` and `-999` sentinels.
- Semantic gate validates wildcard/normalize/copy/parse/multiply call presence plus required global/state references and terminal `RTS`.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 085: `modules/submodules/unknown29.s` (`ESQ_ParseCommandLineAndRun`)

Status: promoted (GCC gate)

Why this target:
- Major startup control-path routine that stitches together argument parsing, handle setup, and handoff into main init/run.
- Extends promotion coverage from helper wrappers into a high-leverage orchestration function.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esq_parse_command_line_and_run_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esq_parse_command_line_and_run_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esq_parse_command_line_and_run.awk`
- Promotion gate: `src/decomp/scripts/promote_esq_parse_command_line_and_run_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esq_parse_command_line_and_run_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esq_parse_command_line_and_run_target_gcc.sh`

Current notes:
- C candidate preserves quoted/unquoted argv tokenization, zero-arg console-name fallback setup, DOS input/output/open handle wiring, default open-flag propagation, and final dispatch into `UNKNOWN29_JMPTBL_ESQ_MainInitAndRun` followed by `BUFFER_FlushAllAndCloseWithCode`.
- Semantic gate validates required global/state references, parser constants (`space/tab/newline/quote`, length `40`), DOS/Exec call paths, and terminal return path invariants.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 086: `modules/submodules/unknown2b.s` (`STREAM_BufferedWriteString`)

Status: promoted (GCC gate)

Why this target:
- First stream-write routine in `unknown2b.s` promoted beyond wrapper/callback-level targets.
- Captures buffer-cursor/update flow and flush fallback behavior in a compact loop-based routine.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/stream_buffered_write_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_stream_buffered_write_string_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_stream_buffered_write_string.awk`
- Promotion gate: `src/decomp/scripts/promote_stream_buffered_write_string_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_stream_buffered_write_string_trial_gcc.sh`
- `bash src/decomp/scripts/promote_stream_buffered_write_string_target_gcc.sh`

Current notes:
- C candidate preserves byte-at-a-time write loop, `WriteRemaining` decrement and overflow fallback via `STREAM_BufferedPutcOrFlush`, trailing `-1` flush call, and length return behavior.
- Semantic gate validates length-scan/load flow, required `Global_PreallocHandleNode1_*` references, flush sentinel path, and terminal return invariants.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 087: `modules/submodules/unknown29.s` (`UNKNOWN29_JMPTBL_ESQ_MainInitAndRun`)

Status: promoted (GCC gate)

Why this target:
- Tiny exported jump-stub companion to Target 085 in the same module.
- Low-risk coverage step that keeps startup-path exports fully represented in the GCC promotion set.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown29_jmptbl_esq_main_init_and_run_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown29_jmptbl_esq_main_init_and_run_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown29_jmptbl_esq_main_init_and_run.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown29_jmptbl_esq_main_init_and_run_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown29_jmptbl_esq_main_init_and_run_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown29_jmptbl_esq_main_init_and_run_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_MainInitAndRun`; GCC may emit jump/call-return form, both accepted as equivalent stub dispatch in the semantic gate.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 088: `modules/groups/_main/b/xjump.s` (`GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `_main/b/xjump.s` with direct forward-dispatch semantics.
- Low-risk bridge that starts covering group-level jump stubs tied to already-promoted stream routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_b_jmptbl_stream_buffered_write_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_b_jmptbl_stream_buffered_write_string_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_stream_buffered_write_string.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_b_jmptbl_stream_buffered_write_string_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_b_jmptbl_stream_buffered_write_string_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_b_jmptbl_stream_buffered_write_string_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STREAM_BufferedWriteString`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 089: `modules/groups/_main/b/xjump.s` (`GROUP_MAIN_B_JMPTBL_MATH_Mulu32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `_main/b/xjump.s` with direct forward-dispatch semantics.
- Low-risk companion to Target 088 that extends group-level jump-stub coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_b_jmptbl_math_mulu32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_b_jmptbl_math_mulu32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_math_mulu32.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_b_jmptbl_math_mulu32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_b_jmptbl_math_mulu32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_b_jmptbl_math_mulu32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_Mulu32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 090: `modules/groups/_main/b/xjump.s` (`GROUP_MAIN_B_JMPTBL_DOS_Delay`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `_main/b/xjump.s` with direct forward-dispatch semantics.
- Low-risk companion to Targets 088/089 that expands `_main/b` stub coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_b_jmptbl_dos_delay_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_b_jmptbl_dos_delay_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_dos_delay.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_b_jmptbl_dos_delay_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_b_jmptbl_dos_delay_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_b_jmptbl_dos_delay_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DOS_Delay`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 091: `modules/groups/_main/b/xjump.s` (`GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `_main/b/xjump.s` with direct forward-dispatch semantics.
- Completes coverage of the exported `_main/b` jump stubs in this module.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_b_jmptbl_buffer_flush_all_and_close_with_code_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_b_jmptbl_buffer_flush_all_and_close_with_code.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_b_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BUFFER_FlushAllAndCloseWithCode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).
