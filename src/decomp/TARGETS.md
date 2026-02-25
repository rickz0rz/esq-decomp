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
