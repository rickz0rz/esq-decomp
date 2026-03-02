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

## Target 092: `modules/groups/a/r/xjump.s` (`GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/r/xjump.s` with direct forward-dispatch semantics.
- Low-risk expansion into a new group-level jump-stub file.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ar_jmptbl_parseini_write_error_log_entry_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ar_jmptbl_parseini_write_error_log_entry_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ar_jmptbl_parseini_write_error_log_entry.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ar_jmptbl_parseini_write_error_log_entry_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ar_jmptbl_parseini_write_error_log_entry_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ar_jmptbl_parseini_write_error_log_entry_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_WriteErrorLogEntry`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 093: `modules/groups/a/r/xjump.s` (`GROUP_AR_JMPTBL_STRING_AppendAtNull`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/r/xjump.s` with direct forward-dispatch semantics.
- Companion to Target 092 that completes coverage of exports in this stub file.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ar_jmptbl_string_append_at_null_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ar_jmptbl_string_append_at_null_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ar_jmptbl_string_append_at_null.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ar_jmptbl_string_append_at_null_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ar_jmptbl_string_append_at_null_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ar_jmptbl_string_append_at_null_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_AppendAtNull`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 094: `modules/groups/a/a/xjump.s` (`GROUP_AA_JMPTBL_STRING_CompareN`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/a/xjump.s` with direct forward-dispatch semantics.
- Low-risk bridge into the `GROUP_AA` stub cluster while reusing an already-promoted callee.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aa_jmptbl_string_compare_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aa_jmptbl_string_compare_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aa_jmptbl_string_compare_n.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aa_jmptbl_string_compare_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aa_jmptbl_string_compare_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aa_jmptbl_string_compare_n_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CompareN`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 095: `modules/groups/a/a/xjump.s` (`GROUP_AA_JMPTBL_STRING_CompareNoCase`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/a/xjump.s` with direct forward-dispatch semantics.
- Companion to Target 094 that increments `GROUP_AA` coverage with another string helper stub.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aa_jmptbl_string_compare_nocase_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aa_jmptbl_string_compare_nocase_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aa_jmptbl_string_compare_nocase.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aa_jmptbl_string_compare_nocase_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aa_jmptbl_string_compare_nocase_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aa_jmptbl_string_compare_nocase_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CompareNoCase`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 096: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_MEMORY_DeallocateMemory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Low-risk bridge into `GROUP_AG` stubs using an already-promoted memory helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_memory_deallocate_memory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_memory_deallocate_memory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_memory_deallocate_memory.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_memory_deallocate_memory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_memory_deallocate_memory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_memory_deallocate_memory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEMORY_DeallocateMemory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 097: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_MEMORY_AllocateMemory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Companion to Target 096 that extends `GROUP_AG` memory-stub coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_memory_allocate_memory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_memory_allocate_memory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_memory_allocate_memory.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_memory_allocate_memory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_memory_allocate_memory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_memory_allocate_memory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEMORY_AllocateMemory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 098: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_STRUCT_AllocWithOwner`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Low-risk companion in the same `GROUP_AG` cluster using an already-promoted struct helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_struct_alloc_with_owner_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_struct_alloc_with_owner_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_struct_alloc_with_owner.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_struct_alloc_with_owner_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_struct_alloc_with_owner_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_struct_alloc_with_owner_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRUCT_AllocWithOwner`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 099: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Companion to Target 098 that extends `GROUP_AG` struct-stub coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_struct_free_with_size_field_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_struct_free_with_size_field_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_struct_free_with_size_field.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_struct_free_with_size_field_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_struct_free_with_size_field_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_struct_free_with_size_field_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRUCT_FreeWithSizeField`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 100: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_MATH_DivS32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Low-risk arithmetic-stub promotion using an already-promoted math helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_math_divs32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_math_divs32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_math_divs32.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_math_divs32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_math_divs32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_math_divs32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_DivS32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 116: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_MEMORY_AllocateMemory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion to Target 113 using an already-promoted memory helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_memory_allocate_memory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_memory_allocate_memory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_memory_allocate_memory.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_memory_allocate_memory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_memory_allocate_memory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_memory_allocate_memory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEMORY_AllocateMemory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 117: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_DOS_OpenFileWithMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Low-risk DOS wrapper-stub promotion using an already-promoted open helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_dos_open_file_with_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_dos_open_file_with_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_dos_open_file_with_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_dos_open_file_with_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_dos_open_file_with_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_dos_open_file_with_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DOS_OpenFileWithMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 118: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_MATH_Mulu32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion to Target 111 that extends `ESQIFF` arithmetic-stub coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_math_mulu32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_math_mulu32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_math_mulu32.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_math_mulu32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_math_mulu32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_math_mulu32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_Mulu32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 119: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_DISKIO_ResetCtrlInputStateIfIdle`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Low-risk runtime-state helper stub that is frequently called from `esqiff.s`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_diskio_reset_ctrl_input_state_if_idle_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_ResetCtrlInputStateIfIdle`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 120: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Low-risk companion to other `DISKIO` stubs already promoted in the same `ESQIFF` table.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_diskio_get_filesize_from_handle_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_diskio_get_filesize_from_handle_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_diskio_get_filesize_from_handle.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_diskio_get_filesize_from_handle_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_diskio_get_filesize_from_handle_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_diskio_get_filesize_from_handle_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_GetFilesizeFromHandle`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 121: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_DISKIO_ForceUiRefreshIfIdle`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- No-arg UI-refresh forwarder with stable call signature and side effects delegated entirely to the callee.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_diskio_force_ui_refresh_if_idle_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_diskio_force_ui_refresh_if_idle_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_diskio_force_ui_refresh_if_idle.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_diskio_force_ui_refresh_if_idle_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_diskio_force_ui_refresh_if_idle_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_diskio_force_ui_refresh_if_idle_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_ForceUiRefreshIfIdle`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 122: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_ESQ_IncCopperListsTowardsTargets`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- High-frequency no-arg copper-update forwarder with no local control flow in the stub itself.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_esq_inc_copper_lists_towards_targets_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_esq_inc_copper_lists_towards_targets_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_inc_copper_lists_towards_targets.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_esq_inc_copper_lists_towards_targets_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_esq_inc_copper_lists_towards_targets_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_esq_inc_copper_lists_towards_targets_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_IncCopperListsTowardsTargets`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 123: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_ESQ_DecCopperListsPrimary`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion to Target 122 completing the copper-list increment/decrement stub pair.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_esq_dec_copper_lists_primary_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_esq_dec_copper_lists_primary_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_dec_copper_lists_primary.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_esq_dec_copper_lists_primary_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_esq_dec_copper_lists_primary_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_esq_dec_copper_lists_primary_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_DecCopperListsPrimary`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 124: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- No-argument task-start forwarder with documented callee signature in `ctasks.s`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_ctasks_start_iff_task_process_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_ctasks_start_iff_task_process_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_ctasks_start_iff_task_process.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_ctasks_start_iff_task_process_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_ctasks_start_iff_task_process_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_ctasks_start_iff_task_process_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CTASKS_StartIffTaskProcess`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 125: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- No-argument script-control helper with simple enable-gated side effects in callee.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_script_assert_ctrl_line_if_enabled_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_script_assert_ctrl_line_if_enabled_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_script_assert_ctrl_line_if_enabled.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_script_assert_ctrl_line_if_enabled_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_script_assert_ctrl_line_if_enabled_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_script_assert_ctrl_line_if_enabled_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_AssertCtrlLineIfEnabled`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 126: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Two-argument copper-entry helper stub with call signature recovered from `app2.s` header annotations.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_esq_move_copper_entry_toward_start_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_esq_move_copper_entry_toward_start_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_move_copper_entry_toward_start.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_start_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_esq_move_copper_entry_toward_start_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_start_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_MoveCopperEntryTowardStart`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 127: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion to Target 126 covering the reverse-direction copper-entry movement helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_esq_move_copper_entry_toward_end_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_esq_move_copper_entry_toward_end_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_move_copper_entry_toward_end.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_end_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_esq_move_copper_entry_toward_end_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_esq_move_copper_entry_toward_end_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_MoveCopperEntryTowardEnd`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 128: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_CloneBrushRecord`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- One-argument brush helper wrapper with documented callee stack signature.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_clone_brush_record_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_clone_brush_record_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_clone_brush_record.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_clone_brush_record_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_clone_brush_record_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_clone_brush_record_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_CloneBrushRecord`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 129: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_FindType3Brush`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- One-argument brush-search helper with stable callee signature.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_find_type3_brush_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_find_type3_brush_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_find_type3_brush.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_find_type3_brush_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_find_type3_brush_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_find_type3_brush_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_FindType3Brush`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 130: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_PopBrushHead`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- One-argument brush-list helper that composes existing promoted memory/list routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_pop_brush_head_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_pop_brush_head_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_pop_brush_head.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_pop_brush_head_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_pop_brush_head_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_pop_brush_head_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_PopBrushHead`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 131: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_AllocBrushNode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- No-argument brush allocator wrapper with straightforward return-through behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_alloc_brush_node_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_alloc_brush_node_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_alloc_brush_node.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_alloc_brush_node_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_alloc_brush_node_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_alloc_brush_node_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_AllocBrushNode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 132: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Two-argument brush lookup helper with conservative stack-arg signature from `brush.s` headers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_find_brush_by_predicate_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_find_brush_by_predicate_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_find_brush_by_predicate.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_find_brush_by_predicate_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_find_brush_by_predicate_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_find_brush_by_predicate_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_FindBrushByPredicate`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 133: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_FreeBrushList`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Multi-argument brush cleanup helper wrapper using conservative stack-arg pass-through.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_free_brush_list_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_free_brush_list_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_free_brush_list.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_free_brush_list_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_free_brush_list_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_free_brush_list_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_FreeBrushList`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 134: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_SelectBrushByLabel`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- One-argument label-selection wrapper with straightforward dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_select_brush_by_label_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_select_brush_by_label_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_select_brush_by_label.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_by_label_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_select_brush_by_label_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_by_label_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_SelectBrushByLabel`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 135: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- One-argument text-match lookup wrapper with stable pointer-arg call shape.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_textdisp_find_entry_index_by_wildcard_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_FindEntryIndexByWildcard`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 136: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Two-argument text-display wrapper; callee side effects remain fully delegated.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_textdisp_draw_channel_banner_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_textdisp_draw_channel_banner_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_textdisp_draw_channel_banner.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_textdisp_draw_channel_banner_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_textdisp_draw_channel_banner_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_textdisp_draw_channel_banner_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_DrawChannelBanner`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 137: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Two-argument NEWGRID validator wrapper with straightforward pass-through behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_newgrid_validate_selection_code_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_newgrid_validate_selection_code_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_newgrid_validate_selection_code.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_newgrid_validate_selection_code_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_newgrid_validate_selection_code_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_newgrid_validate_selection_code_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP NEWGRID_ValidateSelectionCode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 138: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_PopulateBrushList`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Three-argument brush-population helper wrapper with return-through dispatch.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_populate_brush_list_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_populate_brush_list_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_populate_brush_list.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_populate_brush_list_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_populate_brush_list_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_populate_brush_list_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_PopulateBrushList`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 139: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Three-argument script transition helper wrapper with explicit return value propagation.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_script_begin_banner_char_transition_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_script_begin_banner_char_transition_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_script_begin_banner_char_transition.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_script_begin_banner_char_transition_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_script_begin_banner_char_transition_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_script_begin_banner_char_transition_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_BeginBannerCharTransition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 140: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Three-argument display-context wrapper that fans into a heavily used rendering helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_tliba3_build_display_context_for_view_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_tliba3_build_display_context_for_view_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_BuildDisplayContextForViewMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 141: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_BRUSH_SelectBrushSlot`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Seven-argument brush selection wrapper used in ESQIFF weather/status brush blit paths.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_brush_select_brush_slot_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_brush_select_brush_slot_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_brush_select_brush_slot.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_slot_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_brush_select_brush_slot_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_brush_select_brush_slot_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_SelectBrushSlot`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 142: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Three-argument wrapper for the same display-context builder already validated via ESQIFF lane stubs.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_tliba3_build_display_context_for_view_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_tliba3_build_display_context_for_view_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_BuildDisplayContextForViewMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 143: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Matching three-argument wrapper in the `GROUP_AD` lane, reusing the same callee shape.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_tliba3_build_display_context_for_view_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_build_display_context_for_view_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_build_display_context_for_view_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_BuildDisplayContextForViewMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 144: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_MEM_Move`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Low-risk forwarder to already-promoted `MEM_Move`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_mem_move_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_mem_move_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_mem_move.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_mem_move_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_mem_move_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_mem_move_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEM_Move`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 145: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_STRING_CopyPadNul`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Low-risk forwarder to already-promoted `STRING_CopyPadNul`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_string_copy_pad_nul_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_string_copy_pad_nul_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_string_copy_pad_nul.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_string_copy_pad_nul_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_string_copy_pad_nul_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_string_copy_pad_nul_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CopyPadNul`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 401: `modules/groups/a/k/xjump2.s` (`GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump2.s` with direct forward-dispatch semantics.
- Continues `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_esq_set_copper_effect_all_on_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_all_on_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esq_set_copper_effect_all_on.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_all_on_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_all_on_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_all_on_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SetCopperEffect_AllOn`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 402: `modules/groups/a/k/xjump2.s` (`GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump2.s` with direct forward-dispatch semantics.
- Continues `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_script_assert_ctrl_line_now_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_script_assert_ctrl_line_now_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_script_assert_ctrl_line_now.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_script_assert_ctrl_line_now_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_script_assert_ctrl_line_now_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_script_assert_ctrl_line_now_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_AssertCtrlLineNow`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 403: `modules/groups/a/k/xjump2.s` (`GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump2.s` with direct forward-dispatch semantics.
- Continues `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_tliba3_draw_view_mode_guides_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_tliba3_draw_view_mode_guides_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_tliba3_draw_view_mode_guides.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_tliba3_draw_view_mode_guides_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_tliba3_draw_view_mode_guides_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_tliba3_draw_view_mode_guides_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_DrawViewModeGuides`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 404: `modules/groups/a/k/xjump2.s` (`GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump2.s` with direct forward-dispatch semantics.
- Continues `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_gcommand_copy_gfx_to_work_if_available_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_CopyGfxToWorkIfAvailable`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 405: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Starts `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_right_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BEVEL_DrawBevelFrameWithTopRight`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 406: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevel`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_bevel_draw_vertical_bevel_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_vertical_bevel_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_vertical_bevel.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_vertical_bevel_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BEVEL_DrawVerticalBevel`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 407: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTop`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_bevel_frame_with_top_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BEVEL_DrawBevelFrameWithTop`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 408: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_bevel_draw_beveled_frame_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_beveled_frame_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_beveled_frame.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_beveled_frame_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_beveled_frame_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_beveled_frame_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BEVEL_DrawBeveledFrame`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 409: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_BEVEL_DrawVerticalBevelPair`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_vertical_bevel_pair_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BEVEL_DrawVerticalBevelPair`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 410: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_bevel_draw_horizontal_bevel_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_horizontal_bevel_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_horizontal_bevel.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_horizontal_bevel_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BEVEL_DrawHorizontalBevel`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 411: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_coi_select_anim_field_pointer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_coi_select_anim_field_pointer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_coi_select_anim_field_pointer.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_coi_select_anim_field_pointer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_coi_select_anim_field_pointer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_coi_select_anim_field_pointer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP COI_SelectAnimFieldPointer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 412: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_SetCurrentLineIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_set_current_line_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_set_current_line_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_set_current_line_index.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_current_line_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_set_current_line_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_current_line_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_SetCurrentLineIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 413: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_layout_and_append_to_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_layout_and_append_to_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_layout_and_append_to_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_and_append_to_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_layout_and_append_to_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_and_append_to_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_LayoutAndAppendToBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 414: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_GetTotalLineCount`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_get_total_line_count_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_get_total_line_count_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_get_total_line_count.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_get_total_line_count_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_get_total_line_count_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_get_total_line_count_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_GetTotalLineCount`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 415: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_tliba_find_first_wildcard_match_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_tliba_find_first_wildcard_match_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_tliba_find_first_wildcard_match_index.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_tliba_find_first_wildcard_match_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA_FindFirstWildcardMatchIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 416: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_build_layout_for_source_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_build_layout_for_source_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_build_layout_for_source.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_build_layout_for_source_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_build_layout_for_source_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_build_layout_for_source_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_BuildLayoutForSource`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 417: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_GetEntryAuxPointerByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 418: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_LayoutSourceToLines`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_layout_source_to_lines_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_layout_source_to_lines_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_layout_source_to_lines.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_source_to_lines_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_layout_source_to_lines_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_layout_source_to_lines_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_LayoutSourceToLines`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 419: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_cleanup_update_entry_flag_bytes_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_update_entry_flag_bytes_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_cleanup_update_entry_flag_bytes.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_update_entry_flag_bytes_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_update_entry_flag_bytes_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_update_entry_flag_bytes_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_UpdateEntryFlagBytes`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 420: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_COI_RenderClockFormatEntryVariant`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_coi_render_clock_format_entry_variant_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_coi_render_clock_format_entry_variant_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_coi_render_clock_format_entry_variant.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_coi_render_clock_format_entry_variant_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_coi_render_clock_format_entry_variant_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_coi_render_clock_format_entry_variant_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP COI_RenderClockFormatEntryVariant`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 421: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_test_entry_bits0_and2_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_TestEntryBits0And2`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 422: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_compute_visible_line_count_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_compute_visible_line_count_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_compute_visible_line_count.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_visible_line_count_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_compute_visible_line_count_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_visible_line_count_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_ComputeVisibleLineCount`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 423: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_GetEntryPointerByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 424: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_RenderCurrentLine`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_render_current_line_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_render_current_line_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_render_current_line.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_render_current_line_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_render_current_line_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_render_current_line_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_RenderCurrentLine`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 425: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_coi_process_entry_selection_state_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_coi_process_entry_selection_state_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_coi_process_entry_selection_state.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_coi_process_entry_selection_state_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_coi_process_entry_selection_state_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_coi_process_entry_selection_state_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP COI_ProcessEntrySelectionState`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 426: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_cleanup_format_clock_format_entry_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_format_clock_format_entry_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_cleanup_format_clock_format_entry.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_format_clock_format_entry_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_format_clock_format_entry_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_format_clock_format_entry_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_FormatClockFormatEntry`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 427: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_esq_get_half_hour_slot_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_esq_get_half_hour_slot_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esq_get_half_hour_slot_index.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_esq_get_half_hour_slot_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_esq_get_half_hour_slot_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_esq_get_half_hour_slot_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_GetHalfHourSlotIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 428: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_STR_SkipClass3Chars`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_str_skip_class3_chars_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_str_skip_class3_chars_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_str_skip_class3_chars.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_str_skip_class3_chars_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_str_skip_class3_chars_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_str_skip_class3_chars_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STR_SkipClass3Chars`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 429: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_STRING_AppendN`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_string_append_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_string_append_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_string_append_n.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_string_append_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_string_append_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_string_append_n_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_AppendN`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 430: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_esqdisp_compute_schedule_offset_for_row_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_ComputeScheduleOffsetForRow`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 431: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSE_ReadSignedLongSkipClass3_Alt`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 432: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_cleanup_test_entry_flag_y_and_bit1_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_TestEntryFlagYAndBit1`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 433: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_is_current_line_last_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_is_current_line_last_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_is_current_line_last.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_current_line_last_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_is_current_line_last_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_current_line_last_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_IsCurrentLineLast`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 434: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_IsLastLineSelected`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends `NEWGRID2` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_is_last_line_selected_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_is_last_line_selected_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_is_last_line_selected.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_last_line_selected_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_is_last_line_selected_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_is_last_line_selected_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_IsLastLineSelected`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 399: `modules/groups/a/n/esqdisp.s` (`ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqdisp.s` with direct forward-dispatch semantics.
- Extends `ESQDISP` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqdisp_jmptbl_newgrid_processgridmessages_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqdisp_jmptbl_newgrid_processgridmessages_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqdisp_jmptbl_newgrid_processgridmessages.awk`
- Promotion gate: `src/decomp/scripts/promote_esqdisp_jmptbl_newgrid_processgridmessages_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqdisp_jmptbl_newgrid_processgridmessages_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqdisp_jmptbl_newgrid_processgridmessages_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP NEWGRID_ProcessGridMessages`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 400: `modules/groups/a/n/esqdisp.s` (`ESQDISP_JMPTBL_GRAPHICS_AllocRaster`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqdisp.s` with direct forward-dispatch semantics.
- Extends `ESQDISP` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqdisp_jmptbl_graphics_allocraster_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqdisp_jmptbl_graphics_allocraster_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqdisp_jmptbl_graphics_allocraster.awk`
- Promotion gate: `src/decomp/scripts/promote_esqdisp_jmptbl_graphics_allocraster_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqdisp_jmptbl_graphics_allocraster_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqdisp_jmptbl_graphics_allocraster_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GRAPHICS_AllocRaster`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 146: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Two-argument forwarder matching the already-proven `TEXTDISP_DrawChannelBanner` wrapper shape.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_textdisp_draw_channel_banner_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_draw_channel_banner_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_draw_channel_banner.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_channel_banner_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_textdisp_draw_channel_banner_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_channel_banner_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_DrawChannelBanner`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 147: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Companion text-display forwarder in the same `GROUP_AD` jump-table cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_textdisp_format_entry_time_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_format_entry_time_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_format_entry_time.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_format_entry_time_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_textdisp_format_entry_time_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_format_entry_time_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_FormatEntryTime`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 148: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Low-risk forwarder in the existing `GROUP_AD` TLIBA3 jump-stub cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_tliba3_get_view_mode_height_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_height_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_get_view_mode_height.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_height_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_height_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_height_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_GetViewModeHeight`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 149: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TLIBA3_GetViewModeRastPort`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Companion TLIBA3 forwarder in the same `GROUP_AD` xjump cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_tliba3_get_view_mode_rast_port_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_rast_port_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba3_get_view_mode_rast_port.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_rast_port_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_tliba3_get_view_mode_rast_port_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_tliba3_get_view_mode_rast_port_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_GetViewModeRastPort`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 150: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Low-risk DATETIME forwarder adjacent to already-promoted `GROUP_AD` wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_datetime_normalize_month_range_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_datetime_normalize_month_range_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_datetime_normalize_month_range.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_datetime_normalize_month_range_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_datetime_normalize_month_range_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_datetime_normalize_month_range_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DATETIME_NormalizeMonthRange`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 151: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Companion DATETIME forwarder in the same `GROUP_AD` jump-table cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_datetime_adjust_month_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_datetime_adjust_month_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_datetime_adjust_month_index.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_datetime_adjust_month_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_datetime_adjust_month_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_datetime_adjust_month_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DATETIME_AdjustMonthIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 152: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Low-risk script helper forwarder in the `GROUP_AD` xjump cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_UpdateSerialShadowFromCtrlByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 153: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_ESQIFF_RunCopperRiseTransition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Companion forwarder around ESQIFF copper transition logic.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_esqiff_run_copper_rise_transition_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_esqiff_run_copper_rise_transition_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_esqiff_run_copper_rise_transition.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_esqiff_run_copper_rise_transition_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_RunCopperRiseTransition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 154: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Text-display helper forwarder adjacent to already-promoted `TEXTDISP` wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_textdisp_build_entry_short_name_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_build_entry_short_name_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_build_entry_short_name.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_entry_short_name_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_textdisp_build_entry_short_name_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_entry_short_name_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_BuildEntryShortName`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 155: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Graphics helper forwarder in the same jump-table cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_graphics_blt_bit_map_rast_port_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_graphics_blt_bit_map_rast_port_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_graphics_blt_bit_map_rast_port.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_graphics_blt_bit_map_rast_port_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_graphics_blt_bit_map_rast_port_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_graphics_blt_bit_map_rast_port_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GRAPHICS_BltBitMapRastPort`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 156: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Companion copper-transition forwarder in the same `GROUP_AD` jump-stub cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_esqiff_run_copper_drop_transition_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_esqiff_run_copper_drop_transition_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_esqiff_run_copper_drop_transition.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_esqiff_run_copper_drop_transition_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_RunCopperDropTransition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 157: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Low-risk TLIBA1 forwarder between already-promoted `GROUP_AD` wrappers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_tliba1_build_clock_format_entry_if_visible_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA1_BuildClockFormatEntryIfVisible`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 158: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Companion text-display helper forwarder in the `GROUP_AD` text cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_textdisp_build_channel_label_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_build_channel_label_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_build_channel_label.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_channel_label_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_textdisp_build_channel_label_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_build_channel_label_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_BuildChannelLabel`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 159: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Additional text-display forwarder adjacent to promoted `GROUP_AD` text stubs.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_textdisp_draw_inset_rect_frame_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_draw_inset_rect_frame_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_draw_inset_rect_frame.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_inset_rect_frame_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_textdisp_draw_inset_rect_frame_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_draw_inset_rect_frame_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_DrawInsetRectFrame`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 160: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Additional `TEXTDISP` helper forwarder adjacent to other promoted `GROUP_AD` text stubs.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_textdisp_trim_text_to_pixel_width_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_textdisp_trim_text_to_pixel_width.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_textdisp_trim_text_to_pixel_width_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_TrimTextToPixelWidth`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 161: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Low-risk `ESQFUNC` forwarder in the same `GROUP_AD` xjump lane.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_esqfunc_select_and_apply_brush_for_current_entry_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_SelectAndApplyBrushForCurrentEntry`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 162: `modules/groups/a/d/xjump.s` (`GROUP_AD_JMPTBL_DST_ComputeBannerIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/d/xjump.s` with direct forward-dispatch semantics.
- Companion forwarder for DST banner-index logic in the `GROUP_AD` cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ad_jmptbl_dst_compute_banner_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ad_jmptbl_dst_compute_banner_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ad_jmptbl_dst_compute_banner_index.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ad_jmptbl_dst_compute_banner_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ad_jmptbl_dst_compute_banner_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ad_jmptbl_dst_compute_banner_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_ComputeBannerIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 163: `modules/groups/_main/a/xjump.s` (`GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/_main/a/xjump.s` with direct forward-dispatch semantics.
- Low-risk `_main/a` bridge to an already-promoted no-op helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_a_jmptbl_esq_main_exit_noop_hook_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_a_jmptbl_esq_main_exit_noop_hook_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_esq_main_exit_noop_hook.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_exit_noop_hook_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_a_jmptbl_esq_main_exit_noop_hook_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_exit_noop_hook_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_MainExitNoOpHook`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 164: `modules/groups/_main/a/xjump.s` (`GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/_main/a/xjump.s` with direct forward-dispatch semantics.
- Companion `_main/a` no-op forwarder adjacent to Target 163.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_a_jmptbl_esq_main_entry_noop_hook_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_a_jmptbl_esq_main_entry_noop_hook_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_esq_main_entry_noop_hook.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_entry_noop_hook_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_a_jmptbl_esq_main_entry_noop_hook_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_a_jmptbl_esq_main_entry_noop_hook_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_MainEntryNoOpHook`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 165: `modules/groups/_main/a/xjump.s` (`GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/_main/a/xjump.s` with direct forward-dispatch semantics.
- Low-risk forwarding bridge to already-promoted `MEMLIST_FreeAll`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_a_jmptbl_memlist_free_all_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_a_jmptbl_memlist_free_all_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_memlist_free_all.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_a_jmptbl_memlist_free_all_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_a_jmptbl_memlist_free_all_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_a_jmptbl_memlist_free_all_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEMLIST_FreeAll`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 166: `modules/groups/_main/a/xjump.s` (`GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/_main/a/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper to keep `_main/a` jump-table exports aligned with promoted base helpers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_main_a_jmptbl_esq_parse_command_line_and_run_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_main_a_jmptbl_esq_parse_command_line_and_run_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_main_a_jmptbl_esq_parse_command_line_and_run.awk`
- Promotion gate: `src/decomp/scripts/promote_group_main_a_jmptbl_esq_parse_command_line_and_run_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_main_a_jmptbl_esq_parse_command_line_and_run_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_main_a_jmptbl_esq_parse_command_line_and_run_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_ParseCommandLineAndRun`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 167: `modules/groups/a/l/xjump.s` (`GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/l/xjump.s` with direct forward-dispatch semantics.
- Low-risk bridge to `LADFUNC_ComposePackedPenByte`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_al_jmptbl_ladfunc_pack_nibbles_to_byte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_pack_nibbles_to_byte.awk`
- Promotion gate: `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_pack_nibbles_to_byte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_ComposePackedPenByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 168: `modules/groups/a/l/xjump.s` (`GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/l/xjump.s` with direct forward-dispatch semantics.
- Companion helper bridge to `LADFUNC_GetPackedPenLowNibble`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_al_jmptbl_ladfunc_extract_low_nibble_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_extract_low_nibble_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_extract_low_nibble.awk`
- Promotion gate: `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_low_nibble_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_al_jmptbl_ladfunc_extract_low_nibble_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_low_nibble_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_GetPackedPenLowNibble`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 169: `modules/groups/a/l/xjump.s` (`GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/l/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to `LADFUNC_UpdateEntryFromTextAndAttrBuffers`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index.awk`
- Promotion gate: `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_update_entry_buffers_for_ad_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_UpdateEntryFromTextAndAttrBuffers`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 170: `modules/groups/a/l/xjump.s` (`GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/l/xjump.s` with direct forward-dispatch semantics.
- Low-risk bridge to already-promoted decimal formatting helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_al_jmptbl_esq_write_dec_fixed_width_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_al_jmptbl_esq_write_dec_fixed_width_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_al_jmptbl_esq_write_dec_fixed_width.awk`
- Promotion gate: `src/decomp/scripts/promote_group_al_jmptbl_esq_write_dec_fixed_width_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_al_jmptbl_esq_write_dec_fixed_width_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_al_jmptbl_esq_write_dec_fixed_width_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_WriteDecFixedWidth`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 171: `modules/groups/a/l/xjump.s` (`GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/l/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to `LADFUNC_BuildEntryBuffersOrDefault`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_al_jmptbl_ladfunc_build_entry_buffers_or_default_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_build_entry_buffers_or_default.awk`
- Promotion gate: `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_build_entry_buffers_or_default_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_BuildEntryBuffersOrDefault`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 172: `modules/groups/a/l/xjump.s` (`GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/l/xjump.s` with direct forward-dispatch semantics.
- Companion helper bridge to `LADFUNC_GetPackedPenHighNibble`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_al_jmptbl_ladfunc_extract_high_nibble_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_al_jmptbl_ladfunc_extract_high_nibble_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_al_jmptbl_ladfunc_extract_high_nibble.awk`
- Promotion gate: `src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_high_nibble_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_al_jmptbl_ladfunc_extract_high_nibble_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_al_jmptbl_ladfunc_extract_high_nibble_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_GetPackedPenHighNibble`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 173: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper forwarding to DISKIO text-buffer parsing helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_consume_cstring_from_work_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_ConsumeCStringFromWorkBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 174: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to numeric parse helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_diskio_parse_long_from_work_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_diskio_parse_long_from_work_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_parse_long_from_work_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_diskio_parse_long_from_work_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_diskio_parse_long_from_work_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_parse_long_from_work_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_ParseLongFromWorkBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 175: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_DISKIO_WriteDecimalField`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to buffered decimal writer.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_diskio_write_decimal_field_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_diskio_write_decimal_field_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_write_decimal_field.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_decimal_field_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_diskio_write_decimal_field_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_decimal_field_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_WriteDecimalField`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 176: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to buffered write helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_diskio_write_buffered_bytes_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_diskio_write_buffered_bytes_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_write_buffered_bytes.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_buffered_bytes_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_diskio_write_buffered_bytes_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_write_buffered_bytes_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_WriteBufferedBytes`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 177: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to file close/flush helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_diskio_close_buffered_file_and_flush_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_diskio_close_buffered_file_and_flush_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_close_buffered_file_and_flush.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_diskio_close_buffered_file_and_flush_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_diskio_close_buffered_file_and_flush_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_close_buffered_file_and_flush_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_CloseBufferedFileAndFlush`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 178: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_STRING_CompareNoCaseN`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper forwarding to already-promoted string helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_string_compare_nocase_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_string_compare_nocase_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_string_compare_nocase_n.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_string_compare_nocase_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_string_compare_nocase_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_string_compare_nocase_n_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CompareNoCaseN`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 179: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_MATH_Mulu32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Low-risk arithmetic helper wrapper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_math_mulu32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_math_mulu32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_math_mulu32.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_math_mulu32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_math_mulu32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_math_mulu32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_Mulu32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 180: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to buffered file-load helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_diskio_load_file_to_work_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_diskio_load_file_to_work_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_load_file_to_work_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_diskio_load_file_to_work_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_diskio_load_file_to_work_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_load_file_to_work_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_LoadFileToWorkBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 181: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Wrapper bridges callsite alias (`ReadCiaBBit5Mask`) to underlying helper (`SCRIPT_ReadHandshakeBit5Mask`).

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_script_read_ciab_bit5_mask_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_script_read_ciab_bit5_mask_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_script_read_ciab_bit5_mask.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_script_read_ciab_bit5_mask_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_script_read_ciab_bit5_mask_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_script_read_ciab_bit5_mask_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_ReadHandshakeBit5Mask`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 182: `modules/groups/a/y/xjump.s` (`GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/y/xjump.s` with direct forward-dispatch semantics.
- Final wrapper in file; compare lane trims trailing file-level `RTS` sentinel from source slice.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ay_jmptbl_diskio_open_file_with_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ay_jmptbl_diskio_open_file_with_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ay_jmptbl_diskio_open_file_with_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ay_jmptbl_diskio_open_file_with_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ay_jmptbl_diskio_open_file_with_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ay_jmptbl_diskio_open_file_with_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_OpenFileWithBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 183: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper forwarding to inline text-alignment helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_displib_apply_inline_alignment_padding_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_displib_apply_inline_alignment_padding_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_displib_apply_inline_alignment_padding.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_displib_apply_inline_alignment_padding_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_displib_apply_inline_alignment_padding_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_displib_apply_inline_alignment_padding_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPLIB_ApplyInlineAlignmentPadding`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 184: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to copper-rise transition helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_esqiff_run_copper_rise_transition_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_esqiff_run_copper_rise_transition_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_esqiff_run_copper_rise_transition.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_esqiff_run_copper_rise_transition_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_rise_transition_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_RunCopperRiseTransition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 185: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to copper-drop transition helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_esqiff_run_copper_drop_transition_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_esqiff_run_copper_drop_transition_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_esqiff_run_copper_drop_transition.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_esqiff_run_copper_drop_transition_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_esqiff_run_copper_drop_transition_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_RunCopperDropTransition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 186: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to positioned text renderer.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_displib_display_text_at_position_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_displib_display_text_at_position_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_displib_display_text_at_position.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_displib_display_text_at_position_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_displib_display_text_at_position_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_displib_display_text_at_position_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPLIB_DisplayTextAtPosition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 187: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_WDISP_SPrintf`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Wrapper forwards into shared display formatter used elsewhere in promoted set.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_wdisp_sprintf_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_wdisp_sprintf_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_wdisp_sprintf.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_wdisp_sprintf_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_wdisp_sprintf_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_wdisp_sprintf_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP WDISP_SPrintf`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 188: `modules/groups/a/w/xjump.s` (`GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/w/xjump.s` with direct forward-dispatch semantics.
- Last unresolved wrapper in this file before the existing `GROUP_AW_JMPTBL_STRING_CopyPadNul` bridge.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aw_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SetCopperEffect_OffDisableHighlight`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 189: `modules/groups/a/s/xjump.s` (`GROUP_AS_JMPTBL_STR_FindCharPtr`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/s/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper forwarding to an already-promoted string helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_as_jmptbl_str_find_char_ptr_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_as_jmptbl_str_find_char_ptr_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_as_jmptbl_str_find_char_ptr.awk`
- Promotion gate: `src/decomp/scripts/promote_group_as_jmptbl_str_find_char_ptr_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_as_jmptbl_str_find_char_ptr_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_as_jmptbl_str_find_char_ptr_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STR_FindCharPtr`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 190: `modules/groups/a/s/xjump.s` (`GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/s/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to case-fold substring helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_as_jmptbl_esq_find_substring_case_fold_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_as_jmptbl_esq_find_substring_case_fold_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_as_jmptbl_esq_find_substring_case_fold.awk`
- Promotion gate: `src/decomp/scripts/promote_group_as_jmptbl_esq_find_substring_case_fold_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_as_jmptbl_esq_find_substring_case_fold_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_as_jmptbl_esq_find_substring_case_fold_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_FindSubstringCaseFold`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 191: `modules/groups/a/t/xjump.s` (`GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/t/xjump.s` with direct forward-dispatch semantics.
- Low-risk wait/bit-clear wrapper in the `GROUP_AT` control path.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0.awk`
- Promotion gate: `src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit0_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ED1_WaitForFlagAndClearBit0`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 192: `modules/groups/a/t/xjump.s` (`GROUP_AT_JMPTBL_DOS_SystemTagList`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/t/xjump.s` with direct forward-dispatch semantics.
- Companion DOS wrapper reusing an already-promoted system tag helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_at_jmptbl_dos_system_taglist_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_at_jmptbl_dos_system_taglist_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_at_jmptbl_dos_system_taglist.awk`
- Promotion gate: `src/decomp/scripts/promote_group_at_jmptbl_dos_system_taglist_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_at_jmptbl_dos_system_taglist_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_at_jmptbl_dos_system_taglist_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DOS_SystemTagList`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 193: `modules/groups/a/t/xjump.s` (`GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit1`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/t/xjump.s` with direct forward-dispatch semantics.
- Final wrapper in file; compare lane tolerates trailing alignment bytes in source slice.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1.awk`
- Promotion gate: `src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_at_jmptbl_ed1_wait_for_flag_and_clear_bit1_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ED1_WaitForFlagAndClearBit1`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 194: `modules/groups/a/u/xjump.s` (`GROUP_AU_JMPTBL_BRUSH_AppendBrushNode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/u/xjump.s` with direct forward-dispatch semantics.
- Low-risk brush-list wrapper in a compact two-entry jump table.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_au_jmptbl_brush_append_brush_node_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_au_jmptbl_brush_append_brush_node_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_au_jmptbl_brush_append_brush_node.awk`
- Promotion gate: `src/decomp/scripts/promote_group_au_jmptbl_brush_append_brush_node_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_au_jmptbl_brush_append_brush_node_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_au_jmptbl_brush_append_brush_node_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_AppendBrushNode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 195: `modules/groups/a/u/xjump.s` (`GROUP_AU_JMPTBL_BRUSH_PopulateBrushList`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/u/xjump.s` with direct forward-dispatch semantics.
- Companion brush helper wrapper in same file.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_au_jmptbl_brush_populate_brush_list_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_au_jmptbl_brush_populate_brush_list_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_au_jmptbl_brush_populate_brush_list.awk`
- Promotion gate: `src/decomp/scripts/promote_group_au_jmptbl_brush_populate_brush_list_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_au_jmptbl_brush_populate_brush_list_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_au_jmptbl_brush_populate_brush_list_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_PopulateBrushList`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 196: `modules/groups/a/x/xjump.s` (`GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer`)

Status: promoted (GCC gate)

Why this target:
- Single jump-table export in `groups/a/x/xjump.s` with direct forward-dispatch semantics.
- Low-risk formatter wrapper that bridges to already-promoted raw DoFmt helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ax_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP FORMAT_RawDoFmtWithScratchBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 197: `modules/groups/a/z/xjump.s` (`GROUP_AZ_JMPTBL_ESQ_ColdReboot`)

Status: promoted (GCC gate)

Why this target:
- Single jump-table export in `groups/a/z/xjump.s` with direct forward-dispatch semantics.
- Final wrapper in file; compare lane tolerates trailing alignment/epilogue bytes in source slice.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_az_jmptbl_esq_cold_reboot_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_az_jmptbl_esq_cold_reboot_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_az_jmptbl_esq_cold_reboot.awk`
- Promotion gate: `src/decomp/scripts/promote_group_az_jmptbl_esq_cold_reboot_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_az_jmptbl_esq_cold_reboot_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_az_jmptbl_esq_cold_reboot_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_ColdReboot`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 198: `modules/groups/a/a/xjump.s` (`GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/a/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper that forwards to the already-promoted `GCOMMAND_FindPathSeparator`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aa_jmptbl_gcommand_find_path_separator_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aa_jmptbl_gcommand_find_path_separator_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aa_jmptbl_gcommand_find_path_separator.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aa_jmptbl_gcommand_find_path_separator_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aa_jmptbl_gcommand_find_path_separator_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aa_jmptbl_gcommand_find_path_separator_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_FindPathSeparator`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 199: `modules/groups/a/a/xjump.s` (`GROUP_AA_JMPTBL_GRAPHICS_AllocRaster`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/a/xjump.s` with direct forward-dispatch semantics.
- Companion graphics wrapper in the same `GROUP_AA` jump-table cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aa_jmptbl_graphics_alloc_raster_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aa_jmptbl_graphics_alloc_raster_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aa_jmptbl_graphics_alloc_raster.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aa_jmptbl_graphics_alloc_raster_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aa_jmptbl_graphics_alloc_raster_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aa_jmptbl_graphics_alloc_raster_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GRAPHICS_AllocRaster`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 200: `modules/groups/a/f/xjump.s` (`GROUP_AF_JMPTBL_GCOMMAND_SaveBrushResult`)

Status: promoted (GCC gate)

Why this target:
- Single jump-table export in `groups/a/f/xjump.s` with direct forward-dispatch semantics.
- File-end wrapper with adjacent alignment bytes that are ignored by the semantic gate.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_af_jmptbl_gcommand_save_brush_result_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_af_jmptbl_gcommand_save_brush_result_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_af_jmptbl_gcommand_save_brush_result.awk`
- Promotion gate: `src/decomp/scripts/promote_group_af_jmptbl_gcommand_save_brush_result_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_af_jmptbl_gcommand_save_brush_result_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_af_jmptbl_gcommand_save_brush_result_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_SaveBrushResult`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate tolerates trailing alignment/epilogue bytes while checking dispatch and terminal control-flow.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 201: `modules/groups/a/i/xjump.s` (`GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/i/xjump.s` with direct forward-dispatch semantics.
- First wrapper in a dense `GROUP_AI` dispatch cluster used by UI/grid flows.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ai_jmptbl_newgrid_set_selection_markers_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ai_jmptbl_newgrid_set_selection_markers_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ai_jmptbl_newgrid_set_selection_markers.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ai_jmptbl_newgrid_set_selection_markers_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ai_jmptbl_newgrid_set_selection_markers_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ai_jmptbl_newgrid_set_selection_markers_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP NEWGRID_SetSelectionMarkers`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 202: `modules/groups/a/i/xjump.s` (`GROUP_AI_JMPTBL_STR_FindCharPtr`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/i/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper in the same dispatch block forwarding to a promoted string helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ai_jmptbl_str_find_char_ptr_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ai_jmptbl_str_find_char_ptr_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ai_jmptbl_str_find_char_ptr.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ai_jmptbl_str_find_char_ptr_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ai_jmptbl_str_find_char_ptr_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ai_jmptbl_str_find_char_ptr_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STR_FindCharPtr`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 203: `modules/groups/a/i/xjump.s` (`GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/i/xjump.s` with direct forward-dispatch semantics.
- Wrapper exposes a hot text-layout helper already used by other promoted lanes.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ai_jmptbl_tliba1_draw_text_with_inset_segments_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ai_jmptbl_tliba1_draw_text_with_inset_segments.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ai_jmptbl_tliba1_draw_text_with_inset_segments_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA1_DrawTextWithInsetSegments`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 204: `modules/groups/a/i/xjump.s` (`GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/i/xjump.s` with direct forward-dispatch semantics.
- Formatter wrapper is a stable bridge to already-promoted formatting routines.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ai_jmptbl_format_format_to_buffer2_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ai_jmptbl_format_format_to_buffer2_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ai_jmptbl_format_format_to_buffer2.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ai_jmptbl_format_format_to_buffer2_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ai_jmptbl_format_format_to_buffer2_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ai_jmptbl_format_format_to_buffer2_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP FORMAT_FormatToBuffer2`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 205: `modules/groups/a/i/xjump.s` (`GROUP_AI_JMPTBL_STR_SkipClass3Chars`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/i/xjump.s` with direct forward-dispatch semantics.
- Companion string-parser wrapper in the same dispatch sequence.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ai_jmptbl_str_skip_class3_chars_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ai_jmptbl_str_skip_class3_chars_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ai_jmptbl_str_skip_class3_chars.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ai_jmptbl_str_skip_class3_chars_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ai_jmptbl_str_skip_class3_chars_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ai_jmptbl_str_skip_class3_chars_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STR_SkipClass3Chars`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 206: `modules/groups/a/i/xjump.s` (`GROUP_AI_JMPTBL_STRING_AppendAtNull`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/i/xjump.s` with direct forward-dispatch semantics.
- Wrapper forwards to core string append helper and is isolated enough for low-risk promotion.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ai_jmptbl_string_append_at_null_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ai_jmptbl_string_append_at_null_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ai_jmptbl_string_append_at_null.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ai_jmptbl_string_append_at_null_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ai_jmptbl_string_append_at_null_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ai_jmptbl_string_append_at_null_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_AppendAtNull`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 207: `modules/groups/a/i/xjump.s` (`GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN`)

Status: promoted (GCC gate)

Why this target:
- Final jump-table export in `groups/a/i/xjump.s` for this wrapper cluster.
- File-end wrapper with alignment bytes after the symbol, handled by semantic filtering.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ai_jmptbl_str_copy_until_any_delim_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ai_jmptbl_str_copy_until_any_delim_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ai_jmptbl_str_copy_until_any_delim_n.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ai_jmptbl_str_copy_until_any_delim_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ai_jmptbl_str_copy_until_any_delim_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ai_jmptbl_str_copy_until_any_delim_n_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STR_CopyUntilAnyDelimN`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate tolerates trailing alignment bytes while checking dispatch and terminal control-flow.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 208: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper forwarding to an already-used ESQPARS teardown helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_esqpars_remove_group_entry_and_release_strings_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPARS_RemoveGroupEntryAndReleaseStrings`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 209: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper in the same cleanup-oriented dispatch cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_esqfunc_free_line_text_buffers_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_esqfunc_free_line_text_buffers_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqfunc_free_line_text_buffers.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_esqfunc_free_line_text_buffers_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_esqfunc_free_line_text_buffers_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_esqfunc_free_line_text_buffers_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_FreeLineTextBuffers`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 210: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Wrapper forwards into an existing ESQIFF resource-release helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_esqiff_deallocate_ads_and_logo_lst_data_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_DeallocateAdsAndLogoLstData`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 211: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Companion deallocation wrapper in the same resource-cleanup table.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_ladfunc_free_banner_rect_entries_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_ladfunc_free_banner_rect_entries_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_ladfunc_free_banner_rect_entries.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_ladfunc_free_banner_rect_entries_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_ladfunc_free_banner_rect_entries_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_ladfunc_free_banner_rect_entries_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_FreeBannerRectEntries`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 212: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_UNKNOWN2A_Stub0`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Stable wrapper over an already-promoted utility stub in the UNKNOWN2A cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_unknown2_a_stub0_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_unknown2_a_stub0_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_unknown2_a_stub0.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_unknown2_a_stub0_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_unknown2_a_stub0_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_unknown2_a_stub0_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP UNKNOWN2A_Stub0`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 213: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Wrapper forwards to NEWGRID shutdown path and is side-effect free at the stub level.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_newgrid_shutdown_grid_resources_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_newgrid_shutdown_grid_resources_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_newgrid_shutdown_grid_resources.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_newgrid_shutdown_grid_resources_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_newgrid_shutdown_grid_resources_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_newgrid_shutdown_grid_resources_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP NEWGRID_ShutdownGridResources`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 214: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to LOCAVAIL resource cleanup.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_locavail_free_resource_chain_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_locavail_free_resource_chain_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_locavail_free_resource_chain.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_locavail_free_resource_chain_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_locavail_free_resource_chain_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_locavail_free_resource_chain_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_FreeResourceChain`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 215: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_GRAPHICS_FreeRaster`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Wrapper pairs cleanly with already-promoted allocation/free raster helpers.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_graphics_free_raster_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_graphics_free_raster_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_graphics_free_raster.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_graphics_free_raster_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_graphics_free_raster_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_graphics_free_raster_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GRAPHICS_FreeRaster`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 216: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_IOSTDREQ_Free`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/b/xjump.s` with direct forward-dispatch semantics.
- Straight wrapper into an established I/O request teardown helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_iostdreq_free_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_iostdreq_free_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_iostdreq_free.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_iostdreq_free_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_iostdreq_free_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_iostdreq_free_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP IOSTDREQ_Free`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 217: `modules/groups/a/b/xjump.s` (`GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode`)

Status: promoted (GCC gate)

Why this target:
- Final jump-table export in `groups/a/b/xjump.s` for this cleanup wrapper cluster.
- File-end wrapper with alignment bytes following the symbol, handled by semantic filtering.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ab_jmptbl_esqiff2_clear_line_head_tail_by_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF2_ClearLineHeadTailByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate tolerates trailing alignment bytes while checking dispatch and terminal control-flow.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 218: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper forwarding to the PARSEINI clock refresh helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_parseini_update_clock_from_rtc_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_parseini_update_clock_from_rtc_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_parseini_update_clock_from_rtc.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_parseini_update_clock_from_rtc_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_UpdateClockFromRtc`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 219: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper in the diagnostics/status UI dispatch cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_esqfunc_draw_diagnostics_screen_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_draw_diagnostics_screen.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_diagnostics_screen_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_DrawDiagnosticsScreen`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 220: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Companion wrapper for memory-status display path.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_esqfunc_draw_memory_status_screen_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_memory_status_screen_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_draw_memory_status_screen.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_memory_status_screen_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_memory_status_screen_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_memory_status_screen_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_DrawMemoryStatusScreen`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 221: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Wrapper for a central SCRIPT control update routine.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_script_update_ctrl_state_machine_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_script_update_ctrl_state_machine_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_script_update_ctrl_state_machine.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_state_machine_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_script_update_ctrl_state_machine_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_state_machine_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_UpdateCtrlStateMachine`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 222: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Banner-boundary wrapper with isolated dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_gcommand_update_banner_bounds_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_gcommand_update_banner_bounds_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_gcommand_update_banner_bounds.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_gcommand_update_banner_bounds_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_gcommand_update_banner_bounds_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_gcommand_update_banner_bounds_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_UpdateBannerBounds`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 223: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Wrapper label forwards to `SCRIPT_PollHandshakeAndApplyTimeout` callee.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_script_update_ctrl_line_timeout_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_script_update_ctrl_line_timeout_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_script_update_ctrl_line_timeout.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_line_timeout_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_script_update_ctrl_line_timeout_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_script_update_ctrl_line_timeout_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_PollHandshakeAndApplyTimeout`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 224: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Companion script-control wrapper adjacent to timeout updater.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_script_clear_ctrl_line_if_enabled_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_script_clear_ctrl_line_if_enabled.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_script_clear_ctrl_line_if_enabled_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_ClearCtrlLineIfEnabled`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 225: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_ESQFUNC_FreeExtraTitleTextPointers`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- ESQFUNC cleanup wrapper used in title/banner teardown flow.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_free_extra_title_text_pointers_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_FreeExtraTitleTextPointers`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 226: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Display wrapper routing to ESQDISP status-banner draw helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_esqdisp_draw_status_banner_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_esqdisp_draw_status_banner_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqdisp_draw_status_banner.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_esqdisp_draw_status_banner_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_esqdisp_draw_status_banner_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_esqdisp_draw_status_banner_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_DrawStatusBanner`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 227: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_DST_UpdateBannerQueue`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Companion DST wrapper immediately preceding remaining non-promoted AC stubs.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_dst_update_banner_queue_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_dst_update_banner_queue_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_dst_update_banner_queue.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_dst_update_banner_queue_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_dst_update_banner_queue_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_dst_update_banner_queue_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_UpdateBannerQueue`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 228: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_DST_RefreshBannerBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Companion DST wrapper immediately after `DST_UpdateBannerQueue`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_dst_refresh_banner_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_dst_refresh_banner_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_dst_refresh_banner_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_dst_refresh_banner_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_dst_refresh_banner_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_dst_refresh_banner_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_RefreshBannerBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 229: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/c/xjump.s` with direct forward-dispatch semantics.
- Wrapper for ESC menu version renderer near the file tail.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_esqfunc_draw_esc_menu_version_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_esc_menu_version_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_esqfunc_draw_esc_menu_version.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_esc_menu_version_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_esqfunc_draw_esc_menu_version_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_esqfunc_draw_esc_menu_version_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_DrawEscMenuVersion`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 230: `modules/groups/a/c/xjump.s` (`GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat`)

Status: promoted (GCC gate)

Why this target:
- Final jump-table export in `groups/a/c/xjump.s` for this dispatch table.
- File-end wrapper with trailing alignment bytes handled by semantic filtering.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ac_jmptbl_parseini_adjust_hours_to24_hr_format_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_AdjustHoursTo24HrFormat`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate tolerates trailing alignment bytes while checking dispatch and terminal control-flow.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 231: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Low-risk wrapper forwarding to a TLIBA wildcard-match helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_tliba_find_first_wildcard_match_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_tliba_find_first_wildcard_match_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_tliba_find_first_wildcard_match_index.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_tliba_find_first_wildcard_match_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_tliba_find_first_wildcard_match_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA_FindFirstWildcardMatchIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 232: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Companion SCRIPT wrapper in the same utility dispatch cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_script_build_token_index_map_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_script_build_token_index_map_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_script_build_token_index_map.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_script_build_token_index_map_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_script_build_token_index_map_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_script_build_token_index_map_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_BuildTokenIndexMap`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 233: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Wrapper routes to ESQDISP auxiliary-entry accessor.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_aux_pointer_by_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_GetEntryAuxPointerByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 234: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Companion ESQDISP entry accessor wrapper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_esqdisp_get_entry_pointer_by_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_GetEntryPointerByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 235: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Wrapper targets LADFUNC hex-digit parse helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_ladfunc_parse_hex_digit_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_ladfunc_parse_hex_digit_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_ladfunc_parse_hex_digit.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_ladfunc_parse_hex_digit_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_ladfunc_parse_hex_digit_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_ladfunc_parse_hex_digit_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_ParseHexDigit`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 236: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Cleanup wrapper for SCRIPT buffer-array teardown.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_script_deallocate_buffer_array_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_script_deallocate_buffer_array_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_script_deallocate_buffer_array.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_script_deallocate_buffer_array_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_script_deallocate_buffer_array_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_script_deallocate_buffer_array_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_DeallocateBufferArray`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 237: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_WDISP_SPrintf`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Wrapper forwards to WDISP formatted-print helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_wdisp_s_printf_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_wdisp_s_printf_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_wdisp_s_printf.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_wdisp_s_printf_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_wdisp_s_printf_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_wdisp_s_printf_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP WDISP_SPrintf`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 238: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Companion SCRIPT wrapper for allocation side of buffer-array lifecycle.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_script_allocate_buffer_array_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_script_allocate_buffer_array_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_script_allocate_buffer_array.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_script_allocate_buffer_array_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_script_allocate_buffer_array_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_script_allocate_buffer_array_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_AllocateBufferArray`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 239: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/e/xjump.s` with direct forward-dispatch semantics.
- Wrapper dispatches to text-display time-offset helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_textdisp_compute_time_offset_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_textdisp_compute_time_offset_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_textdisp_compute_time_offset.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_textdisp_compute_time_offset_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_textdisp_compute_time_offset_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_textdisp_compute_time_offset_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_ComputeTimeOffset`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 240: `modules/groups/a/e/xjump.s` (`GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString`)

Status: promoted (GCC gate)

Why this target:
- Final jump-table export in `groups/a/e/xjump.s` for this dispatch table.
- File-end wrapper with no additional logic beyond direct dispatch.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ae_jmptbl_esqpars_replace_owned_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ae_jmptbl_esqpars_replace_owned_string_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ae_jmptbl_esqpars_replace_owned_string.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ae_jmptbl_esqpars_replace_owned_string_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ae_jmptbl_esqpars_replace_owned_string_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ae_jmptbl_esqpars_replace_owned_string_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPARS_ReplaceOwnedString`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 112: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_ESQ_NoOp`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Low-risk no-op stub in the same `ESQIFF` jump-table cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_esq_noop_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_noop.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_NoOp`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 113: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_MEMORY_DeallocateMemory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion wrapper forwarding to an already-promoted memory helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_memory_deallocate_memory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_memory_deallocate_memory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_memory_deallocate_memory.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_memory_deallocate_memory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_memory_deallocate_memory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_memory_deallocate_memory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEMORY_DeallocateMemory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 114: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_ESQ_NoOp_006A`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Additional no-op wrapper that extends `ESQIFF` coverage without introducing control-flow complexity.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_esq_noop_006a_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_006a_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_noop_006a.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_006a_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_006a_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_006a_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_NoOp_006A`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 115: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_ESQ_NoOp_0074`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion to Target 114 completing this no-op stub pair.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_esq_noop_0074_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_0074_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_esq_noop_0074.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_0074_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_esq_noop_0074_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_esq_noop_0074_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_NoOp_0074`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 101: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_MATH_Mulu32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Companion to Target 100 that extends `GROUP_AG` math-stub coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_math_mulu32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_math_mulu32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_math_mulu32.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_math_mulu32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_math_mulu32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_math_mulu32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_Mulu32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 102: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_DOS_OpenFileWithMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Low-risk DOS wrapper-stub promotion using an already-promoted open helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_dos_open_file_with_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_dos_open_file_with_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_dos_open_file_with_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_dos_open_file_with_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_dos_open_file_with_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_dos_open_file_with_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DOS_OpenFileWithMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 103: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_STRING_CopyPadNul`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Companion to the new `GROUP_AG` promotions using an already-promoted string helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_string_copy_pad_nul_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_string_copy_pad_nul_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_string_copy_pad_nul.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_string_copy_pad_nul_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_string_copy_pad_nul_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_string_copy_pad_nul_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CopyPadNul`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 104: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_SIGNAL_CreateMsgPortWithSignal`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Low-risk expansion into `GROUP_AM` using an already-promoted signal helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_signal_create_msgport_with_signal_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_signal_create_msgport_with_signal.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SIGNAL_CreateMsgPortWithSignal`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 105: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_STRUCT_AllocWithOwner`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Companion to Target 104 using an already-promoted struct helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_struct_alloc_with_owner_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_struct_alloc_with_owner_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_struct_alloc_with_owner.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_struct_alloc_with_owner_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_struct_alloc_with_owner_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_struct_alloc_with_owner_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRUCT_AllocWithOwner`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 106: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_LIST_InitHeader`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Low-risk companion in the same module using an already-promoted list helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_list_init_header_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_list_init_header_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_list_init_header.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_list_init_header_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_list_init_header_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_list_init_header_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LIST_InitHeader`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 107: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` parser-stub coverage using an already-promoted parse helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_parse_read_signed_long_skip_class3_alt_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSE_ReadSignedLongSkipClass3_Alt`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 108: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_STRING_CompareNoCase`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Low-risk first step into the `ESQIFF` jump table using an already-promoted string helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_string_compare_nocase_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_string_compare_nocase_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_string_compare_nocase.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_string_compare_nocase_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CompareNoCase`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 109: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_STRING_CompareN`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion to Target 108 that extends `ESQIFF` string-stub coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_string_compare_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_string_compare_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_string_compare_n.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_string_compare_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_string_compare_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_string_compare_n_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CompareN`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 110: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_STRING_CompareNoCaseN`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Companion to Targets 108/109 completing the three-string-compare stub set.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_string_compare_nocase_n_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_string_compare_nocase_n_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_string_compare_nocase_n.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_n_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_string_compare_nocase_n_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_string_compare_nocase_n_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CompareNoCaseN`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 111: `modules/groups/a/n/esqiff.s` (`ESQIFF_JMPTBL_MATH_DivS32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqiff.s` with direct forward-dispatch semantics.
- Adds arithmetic-stub coverage in the same `ESQIFF` jump-table cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqiff_jmptbl_math_divs32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqiff_jmptbl_math_divs32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqiff_jmptbl_math_divs32.awk`
- Promotion gate: `src/decomp/scripts/promote_esqiff_jmptbl_math_divs32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqiff_jmptbl_math_divs32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqiff_jmptbl_math_divs32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_DivS32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 241: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQIFF2_ApplyIncomingStatusPacket`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Starts `GROUP_AH` coverage with a low-risk single-jump bridge.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esqiff2_apply_incoming_status_packet_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqiff2_apply_incoming_status_packet.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_apply_incoming_status_packet_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF2_ApplyIncomingStatusPacket`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 242: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_NEWGRID_RebuildIndexCache`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Continues `GROUP_AH` bridge coverage with a frequently-called NEWGRID entry.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_newgrid_rebuild_index_cache_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_newgrid_rebuild_index_cache_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_newgrid_rebuild_index_cache.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_newgrid_rebuild_index_cache_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_newgrid_rebuild_index_cache_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_newgrid_rebuild_index_cache_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP NEWGRID_RebuildIndexCache`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 243: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Advances `GROUP_AH` conversion while preserving one-hop behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esqshared_apply_program_title_text_filters_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esqshared_apply_program_title_text_filters_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqshared_apply_program_title_text_filters.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esqshared_apply_program_title_text_filters_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esqshared_apply_program_title_text_filters_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esqshared_apply_program_title_text_filters_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQSHARED_ApplyProgramTitleTextFilters`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 244: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Keeps momentum on `GROUP_AH` while expanding display-path dispatch coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esqdisp_update_status_mask_and_refresh_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_UpdateStatusMaskAndRefresh`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 245: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Adds another high-traffic dispatcher while keeping conversion risk low.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esqshared_init_entry_defaults_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esqshared_init_entry_defaults_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqshared_init_entry_defaults.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esqshared_init_entry_defaults_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esqshared_init_entry_defaults_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esqshared_init_entry_defaults_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQSHARED_InitEntryDefaults`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 246: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_GCOMMAND_LoadPPVTemplate`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Extends bridge coverage into command-loader paths.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_gcommand_load_ppv_template_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_ppv_template_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_gcommand_load_ppv_template.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_ppv_template_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_ppv_template_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_ppv_template_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_LoadPPVTemplate`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 247: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Covers a persistence-facing bridge in the same cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_locavail_save_availability_data_file_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_locavail_save_availability_data_file_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_locavail_save_availability_data_file.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_locavail_save_availability_data_file_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_locavail_save_availability_data_file_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_locavail_save_availability_data_file_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_SaveAvailabilityDataFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 248: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_GCOMMAND_LoadCommandFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Keeps `GROUP_AH` batch cohesion around command/data load bridges.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_gcommand_load_command_file_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_command_file_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_gcommand_load_command_file.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_command_file_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_command_file_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_command_file_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_LoadCommandFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 249: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQ_WildcardMatch`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Adds wildcard utility bridge coverage used in parsing/search flows.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esq_wildcard_match_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esq_wildcard_match_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esq_wildcard_match.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esq_wildcard_match_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esq_wildcard_match_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esq_wildcard_match_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_WildcardMatch`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 250: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_P_TYPE_WritePromoIdDataFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Completes the first ten-function `GROUP_AH` conversion tranche.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_p_type_write_promo_id_data_file_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_p_type_write_promo_id_data_file_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_p_type_write_promo_id_data_file.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_p_type_write_promo_id_data_file_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_p_type_write_promo_id_data_file_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_p_type_write_promo_id_data_file_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP P_TYPE_WritePromoIdDataFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 251: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Continues completion pass of remaining `GROUP_AH` jump bridges.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esqfunc_wait_for_clock_change_and_service_ui_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_WaitForClockChangeAndServiceUi`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 252: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQ_TestBit1Based`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Keeps `GROUP_AH` completion batch contiguous.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esq_test_bit1_based_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esq_test_bit1_based_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esq_test_bit1_based.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esq_test_bit1_based_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esq_test_bit1_based_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esq_test_bit1_based_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_TestBit1Based`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 253: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Adds overlay/attention-path bridge coverage in the same module.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esqiff2_show_attention_overlay_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esqiff2_show_attention_overlay_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqiff2_show_attention_overlay.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_show_attention_overlay_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esqiff2_show_attention_overlay_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esqiff2_show_attention_overlay_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF2_ShowAttentionOverlay`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 254: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_STR_FindAnyCharPtr`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Covers string helper dispatch used by disk/parser paths.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_str_find_any_char_ptr_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_str_find_any_char_ptr_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_str_find_any_char_ptr.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_str_find_any_char_ptr_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_str_find_any_char_ptr_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_str_find_any_char_ptr_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STR_FindAnyCharPtr`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 255: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_GCOMMAND_LoadMplexFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Extends command-loader bridge coverage for `GROUP_AH`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_gcommand_load_mplex_file_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_mplex_file_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_gcommand_load_mplex_file.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_mplex_file_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_gcommand_load_mplex_file_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_gcommand_load_mplex_file_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_LoadMplexFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 256: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Captures the aliasing case where the stub label differs from callee symbol.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_script_read_serial_rbf_byte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_script_read_serial_rbf_byte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_script_read_serial_rbf_byte.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_script_read_serial_rbf_byte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_script_read_serial_rbf_byte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_script_read_serial_rbf_byte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_ReadNextRbfByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 257: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Continues remaining parser/shared bridge conversions.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_esqpars_clear_alias_string_pointers_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_esqpars_clear_alias_string_pointers_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_esqpars_clear_alias_string_pointers.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_esqpars_clear_alias_string_pointers_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_esqpars_clear_alias_string_pointers_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_esqpars_clear_alias_string_pointers_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPARS_ClearAliasStringPointers`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 258: `modules/groups/a/h/xjump.s` (`GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/h/xjump.s` with direct forward-dispatch semantics.
- Completes full `GROUP_AH` `xjump.s` jump-table stub conversion coverage.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ah_jmptbl_parse_read_signed_long_skip_class3_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ah_jmptbl_parse_read_signed_long_skip_class3_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ah_jmptbl_parse_read_signed_long_skip_class3.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ah_jmptbl_parse_read_signed_long_skip_class3_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ah_jmptbl_parse_read_signed_long_skip_class3_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ah_jmptbl_parse_read_signed_long_skip_class3_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSE_ReadSignedLongSkipClass3`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 259: `modules/groups/a/j/xjump.s` (`GROUP_AJ_JMPTBL_STRING_FindSubstring`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/j/xjump.s` with direct forward-dispatch semantics.
- Starts `GROUP_AJ` coverage with a low-risk bridge using an already-promoted helper.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aj_jmptbl_string_find_substring_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aj_jmptbl_string_find_substring_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aj_jmptbl_string_find_substring.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aj_jmptbl_string_find_substring_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aj_jmptbl_string_find_substring_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aj_jmptbl_string_find_substring_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_FindSubstring`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 260: `modules/groups/a/j/xjump.s` (`GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/j/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AJ` with another already-proven helper bridge.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aj_jmptbl_format_raw_dofmt_with_scratch_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP FORMAT_RawDoFmtWithScratchBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 261: `modules/groups/a/j/xjump.s` (`GROUP_AJ_JMPTBL_MATH_DivU32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/j/xjump.s` with direct forward-dispatch semantics.
- Adds arithmetic bridge coverage specific to `GROUP_AJ`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aj_jmptbl_math_div_u32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aj_jmptbl_math_div_u32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aj_jmptbl_math_div_u32.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aj_jmptbl_math_div_u32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aj_jmptbl_math_div_u32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aj_jmptbl_math_div_u32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_DivU32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 262: `modules/groups/a/j/xjump.s` (`GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/j/xjump.s` with direct forward-dispatch semantics.
- Covers parse/RTC bridge path in `GROUP_AJ`.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aj_jmptbl_parseini_write_rtc_from_globals_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aj_jmptbl_parseini_write_rtc_from_globals_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aj_jmptbl_parseini_write_rtc_from_globals.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aj_jmptbl_parseini_write_rtc_from_globals_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aj_jmptbl_parseini_write_rtc_from_globals_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aj_jmptbl_parseini_write_rtc_from_globals_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_WriteRtcFromGlobals`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 263: `modules/groups/a/j/xjump.s` (`GROUP_AJ_JMPTBL_MATH_Mulu32`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/j/xjump.s` with direct forward-dispatch semantics.
- Completes the full `GROUP_AJ` `xjump.s` jump-table cluster.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_aj_jmptbl_math_mulu32_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_aj_jmptbl_math_mulu32_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_aj_jmptbl_math_mulu32.awk`
- Promotion gate: `src/decomp/scripts/promote_group_aj_jmptbl_math_mulu32_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_aj_jmptbl_math_mulu32_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_aj_jmptbl_math_mulu32_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MATH_Mulu32`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 264: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_script_update_serial_shadow_from_ctrl_byte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_UpdateSerialShadowFromCtrlByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 265: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_tliba3_select_next_view_mode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_tliba3_select_next_view_mode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_tliba3_select_next_view_mode.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_tliba3_select_next_view_mode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_tliba3_select_next_view_mode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_tliba3_select_next_view_mode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_SelectNextViewMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 266: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_parseini_parse_ini_buffer_and_dispatch_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_ParseIniBufferAndDispatch`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 267: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_TEXTDISP_FormatEntryTimeForIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_textdisp_format_entry_time_for_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_textdisp_format_entry_time_for_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_textdisp_format_entry_time_for_index.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_textdisp_format_entry_time_for_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_textdisp_format_entry_time_for_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_textdisp_format_entry_time_for_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_FormatEntryTimeForIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 268: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_gcommand_get_banner_char_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_gcommand_get_banner_char_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_gcommand_get_banner_char.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_gcommand_get_banner_char_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_gcommand_get_banner_char_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_gcommand_get_banner_char_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_GetBannerChar`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 269: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_esqpars_apply_rtc_bytes_and_persist_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPARS_ApplyRtcBytesAndPersist`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 270: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_parseini_write_error_log_entry_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_parseini_write_error_log_entry_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_parseini_write_error_log_entry.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_parseini_write_error_log_entry_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_parseini_write_error_log_entry_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_parseini_write_error_log_entry_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_WriteErrorLogEntry`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 271: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_parseini_scan_logo_directory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_parseini_scan_logo_directory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_parseini_scan_logo_directory.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_parseini_scan_logo_directory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_parseini_scan_logo_directory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_parseini_scan_logo_directory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_ScanLogoDirectory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 272: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_script_deassert_ctrl_line_now_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_script_deassert_ctrl_line_now_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_script_deassert_ctrl_line_now.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_script_deassert_ctrl_line_now_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_script_deassert_ctrl_line_now_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_script_deassert_ctrl_line_now_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_DeassertCtrlLineNow`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 273: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_esq_set_copper_effect_default_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_default_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esq_set_copper_effect_default.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_default_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_default_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_default_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SetCopperEffect_Default`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 274: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_esq_set_copper_effect_custom_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_custom_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_esq_set_copper_effect_custom.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_custom_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_esq_set_copper_effect_custom_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_esq_set_copper_effect_custom_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SetCopperEffect_Custom`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 275: `modules/groups/a/k/xjump.s` (`GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AK` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ak_jmptbl_cleanup_render_aligned_status_screen_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ak_jmptbl_cleanup_render_aligned_status_screen_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ak_jmptbl_cleanup_render_aligned_status_screen.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ak_jmptbl_cleanup_render_aligned_status_screen_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ak_jmptbl_cleanup_render_aligned_status_screen_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ak_jmptbl_cleanup_render_aligned_status_screen_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_RenderAlignedStatusScreen`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 276: `modules/groups/a/v/xjump.s` (`GROUP_AV_JMPTBL_ALLOCATE_AllocAndInitializeIOStdReq`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/v/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AV` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq.awk`
- Promotion gate: `src/decomp/scripts/promote_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_av_jmptbl_allocate_alloc_and_initialize_iostdreq_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ALLOCATE_AllocAndInitializeIOStdReq`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 277: `modules/groups/a/v/xjump.s` (`GROUP_AV_JMPTBL_SIGNAL_CreateMsgPortWithSignal`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/v/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AV` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_av_jmptbl_signal_create_msgport_with_signal_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_av_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_av_jmptbl_signal_create_msgport_with_signal.awk`
- Promotion gate: `src/decomp/scripts/promote_group_av_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_av_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_av_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SIGNAL_CreateMsgPortWithSignal`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 278: `modules/groups/a/v/xjump.s` (`GROUP_AV_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/v/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AV` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_av_jmptbl_diskio_probe_drives_and_assign_paths_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_av_jmptbl_diskio_probe_drives_and_assign_paths_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_av_jmptbl_diskio_probe_drives_and_assign_paths.awk`
- Promotion gate: `src/decomp/scripts/promote_group_av_jmptbl_diskio_probe_drives_and_assign_paths_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_av_jmptbl_diskio_probe_drives_and_assign_paths_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_av_jmptbl_diskio_probe_drives_and_assign_paths_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_ProbeDrivesAndAssignPaths`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 279: `modules/groups/a/v/xjump.s` (`GROUP_AV_JMPTBL_ESQ_InvokeGcommandInit`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/v/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AV` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_av_jmptbl_esq_invoke_gcommand_init_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_av_jmptbl_esq_invoke_gcommand_init_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_av_jmptbl_esq_invoke_gcommand_init.awk`
- Promotion gate: `src/decomp/scripts/promote_group_av_jmptbl_esq_invoke_gcommand_init_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_av_jmptbl_esq_invoke_gcommand_init_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_av_jmptbl_esq_invoke_gcommand_init_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_InvokeGcommandInit`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 280: `modules/groups/a/v/xjump.s` (`GROUP_AV_JMPTBL_EXEC_CallVector_48`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/v/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AV` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_av_jmptbl_exec_call_vector_48_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_av_jmptbl_exec_call_vector_48_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_av_jmptbl_exec_call_vector_48.awk`
- Promotion gate: `src/decomp/scripts/promote_group_av_jmptbl_exec_call_vector_48_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_av_jmptbl_exec_call_vector_48_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_av_jmptbl_exec_call_vector_48_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP EXEC_CallVector_48`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 281: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_SIGNAL_CreateMsgPortWithSignal`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_signal_create_msgport_with_signal_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_signal_create_msgport_with_signal.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_signal_create_msgport_with_signal_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_signal_create_msgport_with_signal_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SIGNAL_CreateMsgPortWithSignal`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 282: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_textdisp_reset_selection_and_refresh_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_textdisp_reset_selection_and_refresh_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_textdisp_reset_selection_and_refresh.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_textdisp_reset_selection_and_refresh_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_textdisp_reset_selection_and_refresh_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_textdisp_reset_selection_and_refresh_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_ResetSelectionAndRefresh`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 283: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_iostdreq_cleanup_signal_and_msgport_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP IOSTDREQ_CleanupSignalAndMsgport`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 284: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_esqfunc_service_ui_tick_if_running_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_esqfunc_service_ui_tick_if_running.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_service_ui_tick_if_running_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_ServiceUiTickIfRunning`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 285: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_script_begin_banner_char_transition_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_script_begin_banner_char_transition_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_script_begin_banner_char_transition.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_script_begin_banner_char_transition_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_script_begin_banner_char_transition_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_script_begin_banner_char_transition_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_BeginBannerCharTransition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 286: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_ladfunc2_emit_escaped_string_to_scratch_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC2_EmitEscapedStringToScratch`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 287: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_SCRIPT_CheckPathExists`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_script_check_path_exists_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_script_check_path_exists_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_script_check_path_exists.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_script_check_path_exists_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_script_check_path_exists_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_script_check_path_exists_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_CheckPathExists`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 288: `modules/groups/a/g/xjump.s` (`GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/g/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AG` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_ag_jmptbl_esqfunc_update_refresh_mode_state_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_ag_jmptbl_esqfunc_update_refresh_mode_state_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_ag_jmptbl_esqfunc_update_refresh_mode_state.awk`
- Promotion gate: `src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_update_refresh_mode_state_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_ag_jmptbl_esqfunc_update_refresh_mode_state_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_ag_jmptbl_esqfunc_update_refresh_mode_state_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_UpdateRefreshModeState`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 289: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_LADFUNC_ClearBannerRectEntries`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_ladfunc_clear_banner_rect_entries_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_ladfunc_clear_banner_rect_entries_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_ladfunc_clear_banner_rect_entries.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_ladfunc_clear_banner_rect_entries_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_ladfunc_clear_banner_rect_entries_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_ladfunc_clear_banner_rect_entries_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_ClearBannerRectEntries`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 290: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_PARSEINI_UpdateClockFromRtc`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_parseini_update_clock_from_rtc_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_parseini_update_clock_from_rtc_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_parseini_update_clock_from_rtc.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_parseini_update_clock_from_rtc_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_parseini_update_clock_from_rtc_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_UpdateClockFromRtc`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 291: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_SCRIPT_InitCtrlContext`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_script_init_ctrl_context_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_script_init_ctrl_context_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_script_init_ctrl_context.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_script_init_ctrl_context_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_script_init_ctrl_context_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_script_init_ctrl_context_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_InitCtrlContext`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 292: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_DISKIO2_ParseIniFileFromDisk`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_diskio2_parse_ini_file_from_disk_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_diskio2_parse_ini_file_from_disk_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_diskio2_parse_ini_file_from_disk.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_diskio2_parse_ini_file_from_disk_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_diskio2_parse_ini_file_from_disk_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_diskio2_parse_ini_file_from_disk_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO2_ParseIniFileFromDisk`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 293: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_ESQ_CheckTopazFontGuard`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_esq_check_topaz_font_guard_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_esq_check_topaz_font_guard_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_check_topaz_font_guard.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_esq_check_topaz_font_guard_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_esq_check_topaz_font_guard_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_esq_check_topaz_font_guard_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_CheckTopazFontGuard`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 294: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_P_TYPE_ResetListsAndLoadPromoIds`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_p_type_reset_lists_and_load_promo_ids_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP P_TYPE_ResetListsAndLoadPromoIds`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 295: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_LADFUNC_LoadTextAdsFromFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_ladfunc_load_text_ads_from_file_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_ladfunc_load_text_ads_from_file_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_ladfunc_load_text_ads_from_file.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_ladfunc_load_text_ads_from_file_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_ladfunc_load_text_ads_from_file_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_ladfunc_load_text_ads_from_file_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_LoadTextAdsFromFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 296: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_DISKIO_LoadConfigFromDisk`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_diskio_load_config_from_disk_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_diskio_load_config_from_disk_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_diskio_load_config_from_disk.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_diskio_load_config_from_disk_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_diskio_load_config_from_disk_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_diskio_load_config_from_disk_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_LoadConfigFromDisk`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 297: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_TEXTDISP_LoadSourceConfig`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_textdisp_load_source_config_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_textdisp_load_source_config_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_textdisp_load_source_config.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_textdisp_load_source_config_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_textdisp_load_source_config_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_textdisp_load_source_config_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_LoadSourceConfig`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 298: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_KYBD_InitializeInputDevices`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_kybd_initialize_input_devices_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_kybd_initialize_input_devices_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_kybd_initialize_input_devices.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_kybd_initialize_input_devices_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_kybd_initialize_input_devices_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_kybd_initialize_input_devices_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP KYBD_InitializeInputDevices`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 299: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_ESQ_CheckCompatibleVideoChip`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_esq_check_compatible_video_chip_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_esq_check_compatible_video_chip_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_check_compatible_video_chip.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_esq_check_compatible_video_chip_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_esq_check_compatible_video_chip_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_esq_check_compatible_video_chip_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_CheckCompatibleVideoChip`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 300: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_ESQ_CheckAvailableFastMemory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_esq_check_available_fast_memory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_esq_check_available_fast_memory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_check_available_fast_memory.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_esq_check_available_fast_memory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_esq_check_available_fast_memory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_esq_check_available_fast_memory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_CheckAvailableFastMemory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 301: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_GCOMMAND_ResetBannerFadeState`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_gcommand_reset_banner_fade_state_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_gcommand_reset_banner_fade_state_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_gcommand_reset_banner_fade_state.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_gcommand_reset_banner_fade_state_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_gcommand_reset_banner_fade_state_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_gcommand_reset_banner_fade_state_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_ResetBannerFadeState`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 302: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_TLIBA3_InitPatternTable`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_tliba3_init_pattern_table_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_tliba3_init_pattern_table_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_tliba3_init_pattern_table.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_tliba3_init_pattern_table_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_tliba3_init_pattern_table_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_tliba3_init_pattern_table_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_InitPatternTable`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 303: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_ESQ_FormatDiskErrorMessage`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_esq_format_disk_error_message_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_esq_format_disk_error_message_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_format_disk_error_message.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_esq_format_disk_error_message_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_esq_format_disk_error_message_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_esq_format_disk_error_message_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_FormatDiskErrorMessage`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 304: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_script_prime_banner_transition_from_hex_code_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_script_prime_banner_transition_from_hex_code_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_script_prime_banner_transition_from_hex_code.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_script_prime_banner_transition_from_hex_code_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_script_prime_banner_transition_from_hex_code_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_script_prime_banner_transition_from_hex_code_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_PrimeBannerTransitionFromHexCode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 305: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_LOCAVAIL_ResetFilterStateStruct`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_locavail_reset_filter_state_struct_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_locavail_reset_filter_state_struct_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_locavail_reset_filter_state_struct.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_locavail_reset_filter_state_struct_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_locavail_reset_filter_state_struct_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_locavail_reset_filter_state_struct_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_ResetFilterStateStruct`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 306: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_ESQ_InitAudio1Dma`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_esq_init_audio1_dma_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_esq_init_audio1_dma_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_init_audio1_dma.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_esq_init_audio1_dma_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_esq_init_audio1_dma_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_esq_init_audio1_dma_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_InitAudio1Dma`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 307: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_on_enable_highlight_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SetCopperEffect_OnEnableHighlight`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 308: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_LOCAVAIL_LoadAvailabilityDataFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_locavail_load_availability_data_file_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_locavail_load_availability_data_file_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_locavail_load_availability_data_file.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_locavail_load_availability_data_file_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_locavail_load_availability_data_file_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_locavail_load_availability_data_file_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_LoadAvailabilityDataFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 309: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_GCOMMAND_InitPresetDefaults`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_gcommand_init_preset_defaults_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_gcommand_init_preset_defaults_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_gcommand_init_preset_defaults.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_gcommand_init_preset_defaults_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_gcommand_init_preset_defaults_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_gcommand_init_preset_defaults_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_InitPresetDefaults`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 310: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_OVERRIDE_INTUITION_FUNCS`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_override_intuition_funcs_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_override_intuition_funcs_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_override_intuition_funcs.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_override_intuition_funcs_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_override_intuition_funcs_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_override_intuition_funcs_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP OVERRIDE_INTUITION_FUNCS`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 311: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_BUFFER_FlushAllAndCloseWithCode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_buffer_flush_all_and_close_with_code_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_buffer_flush_all_and_close_with_code_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_buffer_flush_all_and_close_with_code.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_buffer_flush_all_and_close_with_code_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_buffer_flush_all_and_close_with_code_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BUFFER_FlushAllAndCloseWithCode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 312: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_FLIB2_ResetAndLoadListingTemplates`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_flib2_reset_and_load_listing_templates_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_flib2_reset_and_load_listing_templates_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_flib2_reset_and_load_listing_templates.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_flib2_reset_and_load_listing_templates_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_flib2_reset_and_load_listing_templates_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_flib2_reset_and_load_listing_templates_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP FLIB2_ResetAndLoadListingTemplates`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 313: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_WDISP_SPrintf`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_wdisp_s_printf_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_wdisp_s_printf_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_wdisp_s_printf.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_wdisp_s_printf_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_wdisp_s_printf_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_wdisp_s_printf_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP WDISP_SPrintf`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 314: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_esq_set_copper_effect_off_disable_highlight_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SetCopperEffect_OffDisableHighlight`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 315: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_CLEANUP_ShutdownSystem`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_cleanup_shutdown_system_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_cleanup_shutdown_system_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_cleanup_shutdown_system.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_cleanup_shutdown_system_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_cleanup_shutdown_system_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_cleanup_shutdown_system_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_ShutdownSystem`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 316: `modules/groups/a/m/xjump.s` (`GROUP_AM_JMPTBL_LADFUNC_AllocBannerRectEntries`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/m/xjump.s` with direct forward-dispatch semantics.
- Extends `GROUP_AM` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/group_am_jmptbl_ladfunc_alloc_banner_rect_entries_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_group_am_jmptbl_ladfunc_alloc_banner_rect_entries_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_group_am_jmptbl_ladfunc_alloc_banner_rect_entries.awk`
- Promotion gate: `src/decomp/scripts/promote_group_am_jmptbl_ladfunc_alloc_banner_rect_entries_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_group_am_jmptbl_ladfunc_alloc_banner_rect_entries_trial_gcc.sh`
- `bash src/decomp/scripts/promote_group_am_jmptbl_ladfunc_alloc_banner_rect_entries_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_AllocBannerRectEntries`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 317: `modules/submodules/unknown.s` (`UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `submodules/unknown.s` with direct forward-dispatch semantics.
- Extends non-group jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown_jmptbl_esqiff2_read_serial_record_into_buffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown_jmptbl_esqiff2_read_serial_record_into_buffer.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown_jmptbl_esqiff2_read_serial_record_into_buffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF2_ReadSerialRecordIntoBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 318: `modules/submodules/unknown.s` (`UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `submodules/unknown.s` with direct forward-dispatch semantics.
- Extends non-group jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown_jmptbl_displib_display_text_at_position_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown_jmptbl_displib_display_text_at_position_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown_jmptbl_displib_display_text_at_position.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown_jmptbl_displib_display_text_at_position_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown_jmptbl_displib_display_text_at_position_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown_jmptbl_displib_display_text_at_position_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPLIB_DisplayTextAtPosition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 319: `modules/submodules/unknown.s` (`UNKNOWN_JMPTBL_ESQ_WildcardMatch`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `submodules/unknown.s` with direct forward-dispatch semantics.
- Extends non-group jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown_jmptbl_esq_wildcard_match_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown_jmptbl_esq_wildcard_match_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown_jmptbl_esq_wildcard_match.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown_jmptbl_esq_wildcard_match_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown_jmptbl_esq_wildcard_match_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown_jmptbl_esq_wildcard_match_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_WildcardMatch`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 320: `modules/submodules/unknown.s` (`UNKNOWN_JMPTBL_DST_NormalizeDayOfYear`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `submodules/unknown.s` with direct forward-dispatch semantics.
- Extends non-group jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown_jmptbl_dst_normalize_day_of_year_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown_jmptbl_dst_normalize_day_of_year_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown_jmptbl_dst_normalize_day_of_year.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown_jmptbl_dst_normalize_day_of_year_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown_jmptbl_dst_normalize_day_of_year_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown_jmptbl_dst_normalize_day_of_year_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_NormalizeDayOfYear`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 321: `modules/submodules/unknown.s` (`UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `submodules/unknown.s` with direct forward-dispatch semantics.
- Extends non-group jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/unknown_jmptbl_esq_generate_xor_checksum_byte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_unknown_jmptbl_esq_generate_xor_checksum_byte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_unknown_jmptbl_esq_generate_xor_checksum_byte.awk`
- Promotion gate: `src/decomp/scripts/promote_unknown_jmptbl_esq_generate_xor_checksum_byte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_unknown_jmptbl_esq_generate_xor_checksum_byte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_unknown_jmptbl_esq_generate_xor_checksum_byte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_GenerateXorChecksumByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 322: `modules/submodules/unknown.s` (`ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `submodules/unknown.s` with direct forward-dispatch semantics.
- Extends non-group jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqproto_jmptbl_esqpars_replace_owned_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqproto_jmptbl_esqpars_replace_owned_string_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqproto_jmptbl_esqpars_replace_owned_string.awk`
- Promotion gate: `src/decomp/scripts/promote_esqproto_jmptbl_esqpars_replace_owned_string_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqproto_jmptbl_esqpars_replace_owned_string_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqproto_jmptbl_esqpars_replace_owned_string_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPARS_ReplaceOwnedString`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 323: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_DST_BuildBannerTimeWord`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_dst_build_banner_time_word_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_dst_build_banner_time_word_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_dst_build_banner_time_word.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_dst_build_banner_time_word_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_dst_build_banner_time_word_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_dst_build_banner_time_word_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_BuildBannerTimeWord`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 324: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_esq_reverse_bits_in6_bytes_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_esq_reverse_bits_in6_bytes_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_reverse_bits_in6_bytes.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_esq_reverse_bits_in6_bytes_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_esq_reverse_bits_in6_bytes_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_esq_reverse_bits_in6_bytes_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_ReverseBitsIn6Bytes`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 325: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_ESQ_SetBit1Based`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_esq_set_bit1_based_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_esq_set_bit1_based_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_set_bit1_based.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_esq_set_bit1_based_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_esq_set_bit1_based_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_esq_set_bit1_based_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SetBit1Based`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 326: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_esq_adjust_bracketed_hour_in_string_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_AdjustBracketedHourInString`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 327: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_coi_ensure_anim_object_allocated_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_coi_ensure_anim_object_allocated_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_coi_ensure_anim_object_allocated.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_coi_ensure_anim_object_allocated_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_coi_ensure_anim_object_allocated_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_coi_ensure_anim_object_allocated_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP COI_EnsureAnimObjectAllocated`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 328: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_ESQ_WildcardMatch`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_esq_wildcard_match_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_esq_wildcard_match_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_wildcard_match.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_esq_wildcard_match_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_esq_wildcard_match_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_esq_wildcard_match_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_WildcardMatch`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 329: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_STR_SkipClass3Chars`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_str_skip_class3_chars_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_str_skip_class3_chars_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_str_skip_class3_chars.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_str_skip_class3_chars_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_str_skip_class3_chars_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_str_skip_class3_chars_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STR_SkipClass3Chars`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 330: `modules/groups/a/p/esqshared.s` (`ESQSHARED_JMPTBL_ESQ_TestBit1Based`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/p/esqshared.s` with direct forward-dispatch semantics.
- Extends `ESQSHARED` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqshared_jmptbl_esq_test_bit1_based_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqshared_jmptbl_esq_test_bit1_based_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqshared_jmptbl_esq_test_bit1_based.awk`
- Promotion gate: `src/decomp/scripts/promote_esqshared_jmptbl_esq_test_bit1_based_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqshared_jmptbl_esq_test_bit1_based_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqshared_jmptbl_esq_test_bit1_based_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_TestBit1Based`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 331: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DISKIO2_FlushDataFilesIfNeeded`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_diskio2_flushdatafilesifneeded_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_diskio2_flushdatafilesifneeded_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio2_flushdatafilesifneeded.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_diskio2_flushdatafilesifneeded_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_diskio2_flushdatafilesifneeded_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_diskio2_flushdatafilesifneeded_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO2_FlushDataFilesIfNeeded`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 332: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_NEWGRID_RebuildIndexCache`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_newgrid_rebuildindexcache_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_newgrid_rebuildindexcache_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_newgrid_rebuildindexcache.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_newgrid_rebuildindexcache_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_newgrid_rebuildindexcache_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_newgrid_rebuildindexcache_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP NEWGRID_RebuildIndexCache`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 333: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DATETIME_SavePairToFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_datetime_savepairtofile_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_datetime_savepairtofile_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_datetime_savepairtofile.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_datetime_savepairtofile_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_datetime_savepairtofile_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_datetime_savepairtofile_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DATETIME_SavePairToFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 334: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseList`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_esqproto_verifychecksumandparselist_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_verifychecksumandparselist_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_verifychecksumandparselist.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparselist_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_esqproto_verifychecksumandparselist_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparselist_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPROTO_VerifyChecksumAndParseList`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 335: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_P_TYPE_ParseAndStoreTypeRecord`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_p_type_parseandstoretyperecord_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_p_type_parseandstoretyperecord_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_p_type_parseandstoretyperecord.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_p_type_parseandstoretyperecord_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_p_type_parseandstoretyperecord_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_p_type_parseandstoretyperecord_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP P_TYPE_ParseAndStoreTypeRecord`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 336: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_ESQPROTO_CopyLabelToGlobal`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_esqproto_copylabeltoglobal_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_copylabeltoglobal_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_copylabeltoglobal.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_copylabeltoglobal_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_esqproto_copylabeltoglobal_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_copylabeltoglobal_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPROTO_CopyLabelToGlobal`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 337: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DST_HandleBannerCommand32_33`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_dst_handlebannercommand32_33_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_dst_handlebannercommand32_33_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_dst_handlebannercommand32_33.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_dst_handlebannercommand32_33_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_dst_handlebannercommand32_33_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_dst_handlebannercommand32_33_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_HandleBannerCommand32_33`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 338: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_esq_seedminuteeventthresholds_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_esq_seedminuteeventthresholds_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esq_seedminuteeventthresholds.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_esq_seedminuteeventthresholds_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_esq_seedminuteeventthresholds_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_esq_seedminuteeventthresholds_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_SeedMinuteEventThresholds`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 339: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_PARSEINI_HandleFontCommand`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_parseini_handlefontcommand_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_parseini_handlefontcommand_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_parseini_handlefontcommand.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_parseini_handlefontcommand_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_parseini_handlefontcommand_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_parseini_handlefontcommand_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_HandleFontCommand`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 340: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_TEXTDISP_ApplySourceConfigAllEntries`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_textdisp_applysourceconfigallentries_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_textdisp_applysourceconfigallentries_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_textdisp_applysourceconfigallentries.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_textdisp_applysourceconfigallentries_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_textdisp_applysourceconfigallentries_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_textdisp_applysourceconfigallentries_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_ApplySourceConfigAllEntries`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 341: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_brush_planemaskforindex_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_brush_planemaskforindex_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_brush_planemaskforindex.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_brush_planemaskforindex_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_brush_planemaskforindex_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_brush_planemaskforindex_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BRUSH_PlaneMaskForIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 342: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_SCRIPT_ResetCtrlContextAndClearStatusLine`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_script_resetctrlcontextandclearstatusline_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_script_resetctrlcontextandclearstatusline.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_script_resetctrlcontextandclearstatusline_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_ResetCtrlContextAndClearStatusLine`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 343: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_parseini_writertcfromglobals_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_parseini_writertcfromglobals_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_parseini_writertcfromglobals.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_parseini_writertcfromglobals_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_parseini_writertcfromglobals_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_parseini_writertcfromglobals_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_WriteRtcFromGlobals`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 344: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_LOCAVAIL_SaveAvailabilityDataFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_locavail_saveavailabilitydatafile_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_locavail_saveavailabilitydatafile_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_locavail_saveavailabilitydatafile.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_locavail_saveavailabilitydatafile_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_locavail_saveavailabilitydatafile_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_locavail_saveavailabilitydatafile_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_SaveAvailabilityDataFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 345: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_displib_displaytextatposition_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_displib_displaytextatposition_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_displib_displaytextatposition.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_displib_displaytextatposition_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_displib_displaytextatposition_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_displib_displaytextatposition_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPLIB_DisplayTextAtPosition`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 346: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_LADFUNC_SaveTextAdsToFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_ladfunc_savetextadstofile_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_ladfunc_savetextadstofile_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_ladfunc_savetextadstofile.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_ladfunc_savetextadstofile_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_ladfunc_savetextadstofile_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_ladfunc_savetextadstofile_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_SaveTextAdsToFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 347: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_parse_readsignedlongskipclass3_alt_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_parse_readsignedlongskipclass3_alt.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_parse_readsignedlongskipclass3_alt_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSE_ReadSignedLongSkipClass3_Alt`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 348: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DISKIO2_HandleInteractiveFileTransfer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_diskio2_handleinteractivefiletransfer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio2_handleinteractivefiletransfer.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_diskio2_handleinteractivefiletransfer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO2_HandleInteractiveFileTransfer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 349: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_P_TYPE_WritePromoIdDataFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_p_type_writepromoiddatafile_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_p_type_writepromoiddatafile_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_p_type_writepromoiddatafile.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_p_type_writepromoiddatafile_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_p_type_writepromoiddatafile_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_p_type_writepromoiddatafile_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP P_TYPE_WritePromoIdDataFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 350: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_COI_FreeEntryResources`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_coi_freeentryresources_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_coi_freeentryresources_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_coi_freeentryresources.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_coi_freeentryresources_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_coi_freeentryresources_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_coi_freeentryresources_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP COI_FreeEntryResources`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 351: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DST_UpdateBannerQueue`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_dst_updatebannerqueue_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_dst_updatebannerqueue_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_dst_updatebannerqueue.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_dst_updatebannerqueue_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_dst_updatebannerqueue_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_dst_updatebannerqueue_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_UpdateBannerQueue`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 352: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_ESQPROTO_VerifyChecksumAndParseRecord`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_esqproto_verifychecksumandparserecord_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_verifychecksumandparserecord_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_verifychecksumandparserecord.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparserecord_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_esqproto_verifychecksumandparserecord_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_verifychecksumandparserecord_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPROTO_VerifyChecksumAndParseRecord`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 353: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_ESQPROTO_ParseDigitLabelAndDisplay`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_esqproto_parsedigitlabelanddisplay_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQPROTO_ParseDigitLabelAndDisplay`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 354: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DISKIO_ParseConfigBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_diskio_parseconfigbuffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_diskio_parseconfigbuffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio_parseconfigbuffer.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_diskio_parseconfigbuffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_diskio_parseconfigbuffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_diskio_parseconfigbuffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_ParseConfigBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 355: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_CLEANUP_ParseAlignedListingBlock`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_cleanup_parsealignedlistingblock_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_cleanup_parsealignedlistingblock_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_cleanup_parsealignedlistingblock.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_cleanup_parsealignedlistingblock_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_cleanup_parsealignedlistingblock_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_cleanup_parsealignedlistingblock_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_ParseAlignedListingBlock`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 356: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_script_readserialrbfbyte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_script_readserialrbfbyte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_script_readserialrbfbyte.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_script_readserialrbfbyte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_script_readserialrbfbyte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_script_readserialrbfbyte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_ReadSerialRbfByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 357: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_ESQ_GenerateXorChecksumByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_esq_generatexorchecksumbyte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_esq_generatexorchecksumbyte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_esq_generatexorchecksumbyte.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_esq_generatexorchecksumbyte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_esq_generatexorchecksumbyte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_esq_generatexorchecksumbyte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_GenerateXorChecksumByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 358: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DST_RefreshBannerBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_dst_refreshbannerbuffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_dst_refreshbannerbuffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_dst_refreshbannerbuffer.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_dst_refreshbannerbuffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_dst_refreshbannerbuffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_dst_refreshbannerbuffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_RefreshBannerBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 359: `modules/groups/a/o/esqpars.s` (`ESQPARS_JMPTBL_DISKIO_SaveConfigToFileHandle`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/o/esqpars.s` with direct forward-dispatch semantics.
- Extends `ESQPARS` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqpars_jmptbl_diskio_saveconfigtofilehandle_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqpars_jmptbl_diskio_saveconfigtofilehandle_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqpars_jmptbl_diskio_saveconfigtofilehandle.awk`
- Promotion gate: `src/decomp/scripts/promote_esqpars_jmptbl_diskio_saveconfigtofilehandle_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqpars_jmptbl_diskio_saveconfigtofilehandle_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqpars_jmptbl_diskio_saveconfigtofilehandle_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_SaveConfigToFileHandle`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 360: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_NEWGRID_DrawTopBorderLine`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_newgrid_drawtopborderline_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_newgrid_drawtopborderline_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_newgrid_drawtopborderline.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_newgrid_drawtopborderline_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_newgrid_drawtopborderline_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_newgrid_drawtopborderline_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP NEWGRID_DrawTopBorderLine`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 361: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_locavail_resetfiltercursorstate_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_locavail_resetfiltercursorstate_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_locavail_resetfiltercursorstate.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_locavail_resetfiltercursorstate_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_locavail_resetfiltercursorstate_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_locavail_resetfiltercursorstate_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_ResetFilterCursorState`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 362: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_GCOMMAND_ResetHighlightMessages`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_gcommand_resethighlightmessages_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_gcommand_resethighlightmessages_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_gcommand_resethighlightmessages.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_gcommand_resethighlightmessages_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_gcommand_resethighlightmessages_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_gcommand_resethighlightmessages_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_ResetHighlightMessages`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 363: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_LADFUNC_MergeHighLowNibbles`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_ladfunc_mergehighlownibbles_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_ladfunc_mergehighlownibbles_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_ladfunc_mergehighlownibbles.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_ladfunc_mergehighlownibbles_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_ladfunc_mergehighlownibbles_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_ladfunc_mergehighlownibbles_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_MergeHighLowNibbles`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 364: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_LADFUNC_SaveTextAdsToFile`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_ladfunc_savetextadstofile_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_ladfunc_savetextadstofile_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_ladfunc_savetextadstofile.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_ladfunc_savetextadstofile_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_ladfunc_savetextadstofile_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_ladfunc_savetextadstofile_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_SaveTextAdsToFile`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 365: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_ESQ_ColdReboot`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_esq_coldreboot_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_esq_coldreboot_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_esq_coldreboot.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_esq_coldreboot_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_esq_coldreboot_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_esq_coldreboot_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_ColdReboot`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 366: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_ESQSHARED4_LoadDefaultPaletteToCopper_NoOp`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_esqshared4_loaddefaultpalettetocopper_noop_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQSHARED4_LoadDefaultPaletteToCopper_NoOp`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 367: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_GCOMMAND_SeedBannerDefaults`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_gcommand_seedbannerdefaults_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_gcommand_seedbannerdefaults_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_gcommand_seedbannerdefaults.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerdefaults_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_gcommand_seedbannerdefaults_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerdefaults_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_SeedBannerDefaults`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 368: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_MEM_Move`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_mem_move_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_mem_move_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_mem_move.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_mem_move_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_mem_move_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_mem_move_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEM_Move`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 369: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_gcommand_seedbannerfromprefs_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_gcommand_seedbannerfromprefs_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_gcommand_seedbannerfromprefs.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerfromprefs_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_gcommand_seedbannerfromprefs_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_gcommand_seedbannerfromprefs_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_SeedBannerFromPrefs`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 370: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_cleanup_drawdatetimebannerrow_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_cleanup_drawdatetimebannerrow_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_cleanup_drawdatetimebannerrow.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_cleanup_drawdatetimebannerrow_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_cleanup_drawdatetimebannerrow_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_cleanup_drawdatetimebannerrow_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_DrawDateTimeBannerRow`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 371: `modules/groups/a/k/ed1.s` (`ED1_JMPTBL_LADFUNC_PackNibblesToByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/k/ed1.s` with direct forward-dispatch semantics.
- Extends `ED1` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/ed1_jmptbl_ladfunc_packnibblestobyte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_ed1_jmptbl_ladfunc_packnibblestobyte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_ed1_jmptbl_ladfunc_packnibblestobyte.awk`
- Promotion gate: `src/decomp/scripts/promote_ed1_jmptbl_ladfunc_packnibblestobyte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_ed1_jmptbl_ladfunc_packnibblestobyte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_ed1_jmptbl_ladfunc_packnibblestobyte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_PackNibblesToByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 372: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_textdisp_setrastformode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_setrastformode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_textdisp_setrastformode.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_setrastformode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_setrastformode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_setrastformode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_SetRastForMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 373: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_p_type_promotesecondarylist_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_p_type_promotesecondarylist_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_p_type_promotesecondarylist.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_p_type_promotesecondarylist_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_p_type_promotesecondarylist_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_p_type_promotesecondarylist_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP P_TYPE_PromoteSecondaryList`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 374: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_diskio_probedrivesandassignpaths_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_diskio_probedrivesandassignpaths_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_diskio_probedrivesandassignpaths.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_diskio_probedrivesandassignpaths_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_diskio_probedrivesandassignpaths_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_diskio_probedrivesandassignpaths_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_ProbeDrivesAndAssignPaths`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 375: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_parseini_updatectrlhdeltamax_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_updatectrlhdeltamax_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_updatectrlhdeltamax.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_updatectrlhdeltamax_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_parseini_updatectrlhdeltamax_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_updatectrlhdeltamax_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_UpdateCtrlHDeltaMax`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 376: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_esq_clampbannercharrange_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_esq_clampbannercharrange_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_clampbannercharrange.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_esq_clampbannercharrange_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_esq_clampbannercharrange_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_clampbannercharrange_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_ClampBannerCharRange`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 377: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_script_readciabbit3flag_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_script_readciabbit3flag_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_readciabbit3flag.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit3flag_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_script_readciabbit3flag_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit3flag_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_ReadCiaBBit3Flag`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 378: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_tliba3_drawcenteredwrappedtextlines_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TLIBA3_DrawCenteredWrappedTextLines`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 379: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_script_getctrllineflag_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_script_getctrllineflag_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_getctrllineflag.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_script_getctrllineflag_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_script_getctrllineflag_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_script_getctrllineflag_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_GetCtrlLineFlag`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 380: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_locavail_syncsecondaryfilterforcurrentgroup_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_SyncSecondaryFilterForCurrentGroup`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 381: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_textdisp_resetselectionandrefresh_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_resetselectionandrefresh_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_textdisp_resetselectionandrefresh.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_resetselectionandrefresh_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_resetselectionandrefresh_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_resetselectionandrefresh_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_ResetSelectionAndRefresh`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 382: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_parseini_monitorclockchange_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_monitorclockchange_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_monitorclockchange.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_monitorclockchange_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_parseini_monitorclockchange_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_monitorclockchange_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_MonitorClockChange`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 383: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_ladfunc_parsehexdigit_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_ladfunc_parsehexdigit_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_ladfunc_parsehexdigit.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_parsehexdigit_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_ladfunc_parsehexdigit_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_parsehexdigit_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_ParseHexDigit`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 384: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_cleanup_processalerts_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_cleanup_processalerts_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_cleanup_processalerts.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_processalerts_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_cleanup_processalerts_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_processalerts_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_ProcessAlerts`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 385: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_esq_gethalfhourslotindex_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_esq_gethalfhourslotindex_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_gethalfhourslotindex.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_esq_gethalfhourslotindex_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_esq_gethalfhourslotindex_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_gethalfhourslotindex_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_GetHalfHourSlotIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 386: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_cleanup_drawclockbanner_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_cleanup_drawclockbanner_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_cleanup_drawclockbanner.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_drawclockbanner_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_cleanup_drawclockbanner_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_cleanup_drawclockbanner_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_DrawClockBanner`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 387: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_parseini_computehtcmaxvalues_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_computehtcmaxvalues_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_computehtcmaxvalues.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_computehtcmaxvalues_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_parseini_computehtcmaxvalues_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_computehtcmaxvalues_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_ComputeHTCMaxValues`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 388: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_ladfunc_updatehighlightstate_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_ladfunc_updatehighlightstate_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_ladfunc_updatehighlightstate.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_updatehighlightstate_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_ladfunc_updatehighlightstate_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_ladfunc_updatehighlightstate_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_UpdateHighlightState`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 389: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_p_type_ensuresecondarylist_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_p_type_ensuresecondarylist_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_p_type_ensuresecondarylist.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_p_type_ensuresecondarylist_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_p_type_ensuresecondarylist_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_p_type_ensuresecondarylist_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP P_TYPE_EnsureSecondaryList`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 390: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_script_readciabbit5mask_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_script_readciabbit5mask_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_readciabbit5mask.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit5mask_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_script_readciabbit5mask_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_script_readciabbit5mask_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_ReadCiaBBit5Mask`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 391: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_parseini_normalizeclockdata_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_parseini_normalizeclockdata_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_parseini_normalizeclockdata.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_parseini_normalizeclockdata_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_parseini_normalizeclockdata_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_parseini_normalizeclockdata_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP PARSEINI_NormalizeClockData`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 392: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_ESQ_TickGlobalCounters`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_esq_tickglobalcounters_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_esq_tickglobalcounters_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_tickglobalcounters.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_esq_tickglobalcounters_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_esq_tickglobalcounters_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_tickglobalcounters_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_TickGlobalCounters`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 393: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_script_handleserialctrlcmd_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_script_handleserialctrlcmd_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_script_handleserialctrlcmd.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_script_handleserialctrlcmd_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_script_handleserialctrlcmd_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_script_handleserialctrlcmd_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP SCRIPT_HandleSerialCtrlCmd`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 394: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_esq_handleserialrbfinterrupt_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_esq_handleserialrbfinterrupt_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_handleserialrbfinterrupt.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_esq_handleserialrbfinterrupt_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_esq_handleserialrbfinterrupt_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_handleserialrbfinterrupt_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_HandleSerialRbfInterrupt`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 395: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_textdisp_tickdisplaystate_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_tickdisplaystate_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_textdisp_tickdisplaystate.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_tickdisplaystate_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_textdisp_tickdisplaystate_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_textdisp_tickdisplaystate_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP TEXTDISP_TickDisplayState`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 396: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_ESQ_PollCtrlInput`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_esq_pollctrlinput_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_esq_pollctrlinput_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_esq_pollctrlinput.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_esq_pollctrlinput_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_esq_pollctrlinput_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_esq_pollctrlinput_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_PollCtrlInput`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 397: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_locavail_rebuildfilterstatefromcurrentgroup_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_RebuildFilterStateFromCurrentGroup`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 398: `modules/groups/a/n/esqfunc.s` (`ESQFUNC_JMPTBL_STRING_CopyPadNul`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/a/n/esqfunc.s` with direct forward-dispatch semantics.
- Extends `ESQFUNC` bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/esqfunc_jmptbl_string_copypadnul_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_esqfunc_jmptbl_string_copypadnul_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_esqfunc_jmptbl_string_copypadnul.awk`
- Promotion gate: `src/decomp/scripts/promote_esqfunc_jmptbl_string_copypadnul_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_esqfunc_jmptbl_string_copypadnul_trial_gcc.sh`
- `bash src/decomp/scripts/promote_esqfunc_jmptbl_string_copypadnul_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_CopyPadNul`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 435: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends NEWGRID2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_displib_find_previous_valid_entry_index_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_displib_find_previous_valid_entry_index_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_displib_find_previous_valid_entry_index.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_displib_find_previous_valid_entry_index_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_displib_find_previous_valid_entry_index_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_displib_find_previous_valid_entry_index_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPLIB_FindPreviousValidEntryIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 436: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends NEWGRID2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_compute_marker_widths_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_compute_marker_widths_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_compute_marker_widths.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_marker_widths_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_compute_marker_widths_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_compute_marker_widths_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_ComputeMarkerWidths`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 437: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_ESQ_TestBit1Based`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends NEWGRID2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_esq_test_bit1_based_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_esq_test_bit1_based_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_esq_test_bit1_based.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_esq_test_bit1_based_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_esq_test_bit1_based_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_esq_test_bit1_based_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_TestBit1Based`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 438: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_MeasureCurrentLineLength`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends NEWGRID2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_measure_current_line_length_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_measure_current_line_length_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_measure_current_line_length.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_measure_current_line_length_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_measure_current_line_length_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_measure_current_line_length_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_MeasureCurrentLineLength`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 439: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends NEWGRID2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_set_layout_params_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_set_layout_params_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_set_layout_params.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_layout_params_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_set_layout_params_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_set_layout_params_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_SetLayoutParams`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 440: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_DISPTEXT_HasMultipleLines`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends NEWGRID2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_disptext_has_multiple_lines_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_disptext_has_multiple_lines_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_disptext_has_multiple_lines.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_disptext_has_multiple_lines_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_disptext_has_multiple_lines_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_disptext_has_multiple_lines_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPTEXT_HasMultipleLines`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 441: `modules/groups/b/a/newgrid2.s` (`NEWGRID2_JMPTBL_BEVEL_DrawHorizontalBevel`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/newgrid2.s` with direct forward-dispatch semantics.
- Extends NEWGRID2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/newgrid2_jmptbl_bevel_draw_horizontal_bevel_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_horizontal_bevel_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_newgrid2_jmptbl_bevel_draw_horizontal_bevel.awk`
- Promotion gate: `src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_newgrid2_jmptbl_bevel_draw_horizontal_bevel_trial_gcc.sh`
- `bash src/decomp/scripts/promote_newgrid2_jmptbl_bevel_draw_horizontal_bevel_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BEVEL_DrawHorizontalBevel`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 442: `modules/groups/b/a/tliba3.s` (`TLIBA3_JMPTBL_GCOMMAND_ApplyHighlightFlag`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba3.s` with direct forward-dispatch semantics.
- Extends TLIBA3 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba3_jmptbl_gcommand_applyhighlightflag_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba3_jmptbl_gcommand_applyhighlightflag_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba3_jmptbl_gcommand_applyhighlightflag.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba3_jmptbl_gcommand_applyhighlightflag_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba3_jmptbl_gcommand_applyhighlightflag_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba3_jmptbl_gcommand_applyhighlightflag_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP GCOMMAND_ApplyHighlightFlag`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 443: `modules/groups/b/a/tliba2.s` (`TLIBA2_JMPTBL_DST_AddTimeOffset`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba2.s` with direct forward-dispatch semantics.
- Extends TLIBA2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba2_jmptbl_dst_addtimeoffset_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba2_jmptbl_dst_addtimeoffset_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba2_jmptbl_dst_addtimeoffset.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba2_jmptbl_dst_addtimeoffset_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba2_jmptbl_dst_addtimeoffset_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba2_jmptbl_dst_addtimeoffset_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DST_AddTimeOffset`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 444: `modules/groups/b/a/tliba2.s` (`TLIBA2_JMPTBL_ESQ_TestBit1Based`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba2.s` with direct forward-dispatch semantics.
- Extends TLIBA2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba2_jmptbl_esq_testbit1based_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba2_jmptbl_esq_testbit1based_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba2_jmptbl_esq_testbit1based.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba2_jmptbl_esq_testbit1based_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba2_jmptbl_esq_testbit1based_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba2_jmptbl_esq_testbit1based_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_TestBit1Based`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 445: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Starts TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_coi_getanimfieldpointerbymode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_coi_getanimfieldpointerbymode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_coi_getanimfieldpointerbymode.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_coi_getanimfieldpointerbymode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_coi_getanimfieldpointerbymode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_coi_getanimfieldpointerbymode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP COI_GetAnimFieldPointerByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 446: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_esqdisp_getentryauxpointerbymode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esqdisp_getentryauxpointerbymode.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentryauxpointerbymode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_GetEntryAuxPointerByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 447: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_ladfunc_extractlownibble_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_ladfunc_extractlownibble_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_ladfunc_extractlownibble.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extractlownibble_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_ladfunc_extractlownibble_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extractlownibble_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_GetPackedPenLowNibble`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 448: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_esqdisp_getentrypointerbymode_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_getentrypointerbymode_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esqdisp_getentrypointerbymode.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentrypointerbymode_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_getentrypointerbymode_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_getentrypointerbymode_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_GetEntryPointerByMode`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 449: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_coi_testentrywithintimewindow_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_coi_testentrywithintimewindow_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_coi_testentrywithintimewindow.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_coi_testentrywithintimewindow_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_coi_testentrywithintimewindow_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_coi_testentrywithintimewindow_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP COI_TestEntryWithinTimeWindow`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 450: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_cleanup_formatclockformatentry_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_cleanup_formatclockformatentry_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_cleanup_formatclockformatentry.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_cleanup_formatclockformatentry_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_cleanup_formatclockformatentry_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_cleanup_formatclockformatentry_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLEANUP_FormatClockFormatEntry`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 451: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_esqdisp_computescheduleoffsetforrow_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQDISP_ComputeScheduleOffsetForRow`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 452: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_esq_findsubstringcasefold_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_esq_findsubstringcasefold_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_esq_findsubstringcasefold.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_esq_findsubstringcasefold_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_esq_findsubstringcasefold_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_esq_findsubstringcasefold_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_FindSubstringCaseFold`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 453: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_displib_findpreviousvalidentryindex_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_displib_findpreviousvalidentryindex_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_displib_findpreviousvalidentryindex.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_displib_findpreviousvalidentryindex_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_displib_findpreviousvalidentryindex_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_displib_findpreviousvalidentryindex_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISPLIB_FindPreviousValidEntryIndex`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 454: `modules/groups/b/a/tliba1.s` (`TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/tliba1.s` with direct forward-dispatch semantics.
- Extends TLIBA1 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/tliba1_jmptbl_ladfunc_extracthighnibble_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_tliba1_jmptbl_ladfunc_extracthighnibble_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_tliba1_jmptbl_ladfunc_extracthighnibble.awk`
- Promotion gate: `src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extracthighnibble_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_tliba1_jmptbl_ladfunc_extracthighnibble_trial_gcc.sh`
- `bash src/decomp/scripts/promote_tliba1_jmptbl_ladfunc_extracthighnibble_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_GetPackedPenHighNibble`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 455: `modules/groups/b/a/parseini2.s` (`PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/parseini2.s` with direct forward-dispatch semantics.
- Starts PARSEINI2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock.awk`
- Promotion gate: `src/decomp/scripts/promote_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parseini2_jmptbl_battclock_getsecondsfrombatterybackedclock_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BATTCLOCK_GetSecondsFromBatteryBackedClock`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 456: `modules/groups/b/a/parseini2.s` (`PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/parseini2.s` with direct forward-dispatch semantics.
- Continues PARSEINI2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parseini2_jmptbl_battclock_writesecondstobatterybackedclock_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parseini2_jmptbl_battclock_writesecondstobatterybackedclock.awk`
- Promotion gate: `src/decomp/scripts/promote_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parseini2_jmptbl_battclock_writesecondstobatterybackedclock_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP BATTCLOCK_WriteSecondsToBatteryBackedClock`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 457: `modules/groups/b/a/parseini2.s` (`PARSEINI2_JMPTBL_DATETIME_IsLeapYear`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/parseini2.s` with direct forward-dispatch semantics.
- Continues PARSEINI2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parseini2_jmptbl_datetime_isleapyear_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parseini2_jmptbl_datetime_isleapyear_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parseini2_jmptbl_datetime_isleapyear.awk`
- Promotion gate: `src/decomp/scripts/promote_parseini2_jmptbl_datetime_isleapyear_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parseini2_jmptbl_datetime_isleapyear_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parseini2_jmptbl_datetime_isleapyear_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DATETIME_IsLeapYear`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 458: `modules/groups/b/a/parseini2.s` (`PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/parseini2.s` with direct forward-dispatch semantics.
- Continues PARSEINI2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parseini2_jmptbl_clock_secondsfromepoch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parseini2_jmptbl_clock_secondsfromepoch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parseini2_jmptbl_clock_secondsfromepoch.awk`
- Promotion gate: `src/decomp/scripts/promote_parseini2_jmptbl_clock_secondsfromepoch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parseini2_jmptbl_clock_secondsfromepoch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parseini2_jmptbl_clock_secondsfromepoch_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLOCK_SecondsFromEpoch`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Compare slice stops at `;!======` end marker to avoid pulling post-function alignment bytes.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 459: `modules/groups/b/a/parseini2.s` (`PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/parseini2.s` with direct forward-dispatch semantics.
- Continues PARSEINI2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parseini2_jmptbl_clock_checkdateorsecondsfromepoch_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parseini2_jmptbl_clock_checkdateorsecondsfromepoch.awk`
- Promotion gate: `src/decomp/scripts/promote_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parseini2_jmptbl_clock_checkdateorsecondsfromepoch_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLOCK_CheckDateOrSecondsFromEpoch`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 460: `modules/groups/b/a/parseini2.s` (`PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/parseini2.s` with direct forward-dispatch semantics.
- Continues PARSEINI2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parseini2_jmptbl_clock_convertamigasecondstoclockdata_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parseini2_jmptbl_clock_convertamigasecondstoclockdata_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parseini2_jmptbl_clock_convertamigasecondstoclockdata.awk`
- Promotion gate: `src/decomp/scripts/promote_parseini2_jmptbl_clock_convertamigasecondstoclockdata_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parseini2_jmptbl_clock_convertamigasecondstoclockdata_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parseini2_jmptbl_clock_convertamigasecondstoclockdata_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP CLOCK_ConvertAmigaSecondsToClockData`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 461: `modules/groups/b/a/parseini2.s` (`PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/parseini2.s` with direct forward-dispatch semantics.
- Completes this PARSEINI2 jump-stub bridge cluster while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/parseini2_jmptbl_esq_calcdayofyearfrommonthday_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_parseini2_jmptbl_esq_calcdayofyearfrommonthday_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_parseini2_jmptbl_esq_calcdayofyearfrommonthday.awk`
- Promotion gate: `src/decomp/scripts/promote_parseini2_jmptbl_esq_calcdayofyearfrommonthday_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_parseini2_jmptbl_esq_calcdayofyearfrommonthday_trial_gcc.sh`
- `bash src/decomp/scripts/promote_parseini2_jmptbl_esq_calcdayofyearfrommonthday_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_CalcDayOfYearFromMonthDay`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 462: `modules/groups/b/a/script2.s` (`SCRIPT2_JMPTBL_ESQ_CaptureCtrlBit4StreamBufferByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/script2.s` with direct forward-dispatch semantics.
- Starts SCRIPT2 jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/script2_jmptbl_esq_capturectrlbit4streambufferbyte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_script2_jmptbl_esq_capturectrlbit4streambufferbyte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_script2_jmptbl_esq_capturectrlbit4streambufferbyte.awk`
- Promotion gate: `src/decomp/scripts/promote_script2_jmptbl_esq_capturectrlbit4streambufferbyte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_script2_jmptbl_esq_capturectrlbit4streambufferbyte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_script2_jmptbl_esq_capturectrlbit4streambufferbyte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_CaptureCtrlBit4StreamBufferByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 463: `modules/groups/b/a/script2.s` (`SCRIPT2_JMPTBL_ESQ_ReadSerialRbfByte`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/script2.s` with direct forward-dispatch semantics.
- Continues SCRIPT2 jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/script2_jmptbl_esq_readserialrbfbyte_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_script2_jmptbl_esq_readserialrbfbyte_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_script2_jmptbl_esq_readserialrbfbyte.awk`
- Promotion gate: `src/decomp/scripts/promote_script2_jmptbl_esq_readserialrbfbyte_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_script2_jmptbl_esq_readserialrbfbyte_trial_gcc.sh`
- `bash src/decomp/scripts/promote_script2_jmptbl_esq_readserialrbfbyte_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQ_ReadSerialRbfByte`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 464: `modules/groups/b/a/p_type.s` (`P_TYPE_JMPTBL_STRING_FindSubstring`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/p_type.s` with direct forward-dispatch semantics.
- Adds P_TYPE bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/p_type_jmptbl_string_findsubstring_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_p_type_jmptbl_string_findsubstring_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_p_type_jmptbl_string_findsubstring.awk`
- Promotion gate: `src/decomp/scripts/promote_p_type_jmptbl_string_findsubstring_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_p_type_jmptbl_string_findsubstring_trial_gcc.sh`
- `bash src/decomp/scripts/promote_p_type_jmptbl_string_findsubstring_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP STRING_FindSubstring`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Compare slice stops at `;!======` end marker to avoid pulling post-function alignment bytes.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 465: `modules/groups/b/a/textdisp2.s` (`TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/textdisp2.s` with direct forward-dispatch semantics.
- Starts TEXTDISP2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/textdisp2_jmptbl_locavail_getfilterwindowhalfspan_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_locavail_getfilterwindowhalfspan.awk`
- Promotion gate: `src/decomp/scripts/promote_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_trial_gcc.sh`
- `bash src/decomp/scripts/promote_textdisp2_jmptbl_locavail_getfilterwindowhalfspan_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LOCAVAIL_GetFilterWindowHalfSpan`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 466: `modules/groups/b/a/textdisp2.s` (`TEXTDISP2_JMPTBL_LADFUNC_DrawEntryPreview`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/textdisp2.s` with direct forward-dispatch semantics.
- Continues TEXTDISP2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/textdisp2_jmptbl_ladfunc_drawentrypreview_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_textdisp2_jmptbl_ladfunc_drawentrypreview_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_ladfunc_drawentrypreview.awk`
- Promotion gate: `src/decomp/scripts/promote_textdisp2_jmptbl_ladfunc_drawentrypreview_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_textdisp2_jmptbl_ladfunc_drawentrypreview_trial_gcc.sh`
- `bash src/decomp/scripts/promote_textdisp2_jmptbl_ladfunc_drawentrypreview_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP LADFUNC_DrawEntryPreview`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 467: `modules/groups/b/a/textdisp2.s` (`TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/textdisp2.s` with direct forward-dispatch semantics.
- Continues TEXTDISP2 bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/textdisp2_jmptbl_esqiff_runpendingcopperanimations_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_textdisp2_jmptbl_esqiff_runpendingcopperanimations_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_esqiff_runpendingcopperanimations.awk`
- Promotion gate: `src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_runpendingcopperanimations_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_textdisp2_jmptbl_esqiff_runpendingcopperanimations_trial_gcc.sh`
- `bash src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_runpendingcopperanimations_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_RunPendingCopperAnimations`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 468: `modules/groups/b/a/textdisp2.s` (`TEXTDISP2_JMPTBL_ESQIFF_PlayNextExternalAssetFrame`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/textdisp2.s` with direct forward-dispatch semantics.
- Completes the TEXTDISP2 jump-stub bridge set while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/textdisp2_jmptbl_esqiff_playnextexternalassetframe_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_textdisp2_jmptbl_esqiff_playnextexternalassetframe_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_textdisp2_jmptbl_esqiff_playnextexternalassetframe.awk`
- Promotion gate: `src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_playnextexternalassetframe_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_textdisp2_jmptbl_esqiff_playnextexternalassetframe_trial_gcc.sh`
- `bash src/decomp/scripts/promote_textdisp2_jmptbl_esqiff_playnextexternalassetframe_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_PlayNextExternalAssetFrame`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 469: `modules/groups/b/a/script.s` (`SCRIPT_JMPTBL_MEMORY_DeallocateMemory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/script.s` with direct forward-dispatch semantics.
- Starts SCRIPT jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/script_jmptbl_memory_deallocatememory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_script_jmptbl_memory_deallocatememory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_script_jmptbl_memory_deallocatememory.awk`
- Promotion gate: `src/decomp/scripts/promote_script_jmptbl_memory_deallocatememory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_script_jmptbl_memory_deallocatememory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_script_jmptbl_memory_deallocatememory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEMORY_DeallocateMemory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 470: `modules/groups/b/a/script.s` (`SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/script.s` with direct forward-dispatch semantics.
- Continues SCRIPT jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/script_jmptbl_diskio_writebufferedbytes_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_script_jmptbl_diskio_writebufferedbytes_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_script_jmptbl_diskio_writebufferedbytes.awk`
- Promotion gate: `src/decomp/scripts/promote_script_jmptbl_diskio_writebufferedbytes_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_script_jmptbl_diskio_writebufferedbytes_trial_gcc.sh`
- `bash src/decomp/scripts/promote_script_jmptbl_diskio_writebufferedbytes_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_WriteBufferedBytes`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 471: `modules/groups/b/a/script.s` (`SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/script.s` with direct forward-dispatch semantics.
- Continues SCRIPT jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/script_jmptbl_diskio_closebufferedfileandflush_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_script_jmptbl_diskio_closebufferedfileandflush_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_script_jmptbl_diskio_closebufferedfileandflush.awk`
- Promotion gate: `src/decomp/scripts/promote_script_jmptbl_diskio_closebufferedfileandflush_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_script_jmptbl_diskio_closebufferedfileandflush_trial_gcc.sh`
- `bash src/decomp/scripts/promote_script_jmptbl_diskio_closebufferedfileandflush_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_CloseBufferedFileAndFlush`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 472: `modules/groups/b/a/script.s` (`SCRIPT_JMPTBL_MEMORY_AllocateMemory`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/script.s` with direct forward-dispatch semantics.
- Continues SCRIPT jump-stub bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/script_jmptbl_memory_allocatememory_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_script_jmptbl_memory_allocatememory_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_script_jmptbl_memory_allocatememory.awk`
- Promotion gate: `src/decomp/scripts/promote_script_jmptbl_memory_allocatememory_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_script_jmptbl_memory_allocatememory_trial_gcc.sh`
- `bash src/decomp/scripts/promote_script_jmptbl_memory_allocatememory_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP MEMORY_AllocateMemory`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 473: `modules/groups/b/a/script.s` (`SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/script.s` with direct forward-dispatch semantics.
- Completes the SCRIPT jump-stub bridge set while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/script_jmptbl_diskio_openfilewithbuffer_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_script_jmptbl_diskio_openfilewithbuffer_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_script_jmptbl_diskio_openfilewithbuffer.awk`
- Promotion gate: `src/decomp/scripts/promote_script_jmptbl_diskio_openfilewithbuffer_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_script_jmptbl_diskio_openfilewithbuffer_trial_gcc.sh`
- `bash src/decomp/scripts/promote_script_jmptbl_diskio_openfilewithbuffer_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP DISKIO_OpenFileWithBuffer`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Compare slice ends before the `;======` alignment marker.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 474: `modules/groups/b/a/wdisp.s` (`WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/wdisp.s` with direct forward-dispatch semantics.
- Starts WDISP bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/wdisp_jmptbl_esqiff_restorebasepalettetriples_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_wdisp_jmptbl_esqiff_restorebasepalettetriples_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esqiff_restorebasepalettetriples.awk`
- Promotion gate: `src/decomp/scripts/promote_wdisp_jmptbl_esqiff_restorebasepalettetriples_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_wdisp_jmptbl_esqiff_restorebasepalettetriples_trial_gcc.sh`
- `bash src/decomp/scripts/promote_wdisp_jmptbl_esqiff_restorebasepalettetriples_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQIFF_RestoreBasePaletteTriples`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).

## Target 475: `modules/groups/b/a/wdisp.s` (`WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary`)

Status: promoted (GCC gate)

Why this target:
- Small jump-table export in `groups/b/a/wdisp.s` with direct forward-dispatch semantics.
- Continues WDISP bridge coverage while preserving one-hop dispatch behavior.

Artifacts:
- GCC C candidate: `src/decomp/c/replacements/wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_gcc.c`
- GCC compile/compare script: `src/decomp/scripts/compare_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_trial_gcc.sh`
- Semantic filter: `src/decomp/scripts/semantic_filter_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary.awk`
- Promotion gate: `src/decomp/scripts/promote_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_target_gcc.sh`

Run:
- `CROSS_CC=/opt/amiga/bin/m68k-amigaos-gcc bash src/decomp/scripts/compare_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_trial_gcc.sh`
- `bash src/decomp/scripts/promote_wdisp_jmptbl_esqfunc_trimtexttopixelwidthwordboundary_target_gcc.sh`

Current notes:
- Original assembly is a direct `JMP ESQFUNC_TrimTextToPixelWidthWordBoundary`; GCC may emit jump/call-return form, both accepted as equivalent jump-stub dispatch.
- Semantic gate validates target dispatch reference and terminal jump/return form.
- Current promotion decision: pass (on GCC profile `-O1 -fomit-frame-pointer` + m68k freestanding flags).
