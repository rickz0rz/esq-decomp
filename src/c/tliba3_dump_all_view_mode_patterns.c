/* RESTORES: TLIBA3_DumpAllViewModePatterns
 * MODULE:   modules/groups/b/a/tliba3_p4_p0.s   (1 of its 2 blocks)
 * STATUS:   behavioural
 *
 * A diagnostic dump of every view-mode pattern entry. Its sibling
 * TLIBA3_DumpCurrentViewModePattern does the one currently selected and is in
 * tliba3_dump_current_view_mode_pattern.c.
 *
 * THE LOOP RUNS NINE TIMES, NOT TEN. The bound is `CMP.L #9,D7 / BGE`, so
 * index 9 is excluded -- entries 0 through 8.
 *
 * NEITHER CARRIED A LABEL UNTIL 2026-08-04, and the module before them in
 * src/Prevue.asm ends in RTS, so nothing reaches either -- by name or by
 * fall-through. The second is annotated `; Dead code.` by the disassembly; the
 * first is not, and is dead for the same reason. Adding both labels is
 * byte-neutral; test-hash.sh and build-split.sh pass across the change. Both
 * names are OURS.
 *
 * THE STRIDE IS 76 AND IS HELD IN A LOCAL, because the original calls
 * MATH_Mulu32 rather than shifting. Against the literal SAS/C strength-reduces
 * and emits no call. Same lever as unknown_parse_list_and_update_entries.c, and
 * struct VmPattern is 76 bytes, so `&table[i]` would be correct C and the wrong
 * instructions.
 *
 * THE TWO FORMAT CALLS ARE NOT THE SAME FUNCTION. WDISP_SPrintf writes the
 * pattern's NAME into a stack buffer; FORMAT_RawDoFmtWithScratchBuffer sends a
 * line to the diagnostic stream. The second dump uses both, one per iteration.
 *
 * THE ARGUMENT BLOCKS OVERLAP. The original pushes the SPrintf block, leaves
 * it, overwrites its top slot with the pattern pointer, and pops 20 bytes once
 * with `LEA 20(A7),A7`. SAS/C builds and pops each call's block, which is the
 * argument-slot-reuse divergence recorded elsewhere.
 *
 * SASC-MISMATCH: argument-slot-reuse
 *   ref:     one `LEA 20(A7),A7` for two calls whose blocks overlap
 *   got:     each call builds and pops its own block
 *   summary: same arguments reach both callees. Several sites in the program;
 *            esqproto_parse.c records the same item.
 *   scope:   program-wide.
 *   retest:  a compiler that defers argument-stack cleanup across calls.
 */
#ifndef VMPATTERN_DEFINED
struct VmPattern;
#endif

extern long TLIBA1_CurrentViewModeIndex;
extern struct VmPattern TLIBA3_VmArrayPatternTable[];
extern char Global_STR_VM_ARRAY_1[];
extern char Global_STR_VM_ARRAY_2[];
extern char TLIBA1_STR_PatternDumpLoopNewline[];

extern long WDISP_SPrintf(char *buf, char *fmt, ...);
extern void TLIBA3_FormatPatternRegisterDump(char *name, unsigned short *r);
extern void FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);

void TLIBA3_DumpAllViewModePatterns(void)
{
    char name[84];
    long stride = 76;
    long i;

    for (i = 0; i < 9; i++) {
        WDISP_SPrintf(name, Global_STR_VM_ARRAY_2, i);
        TLIBA3_FormatPatternRegisterDump(
            name,
            (unsigned short *)((char *)TLIBA3_VmArrayPatternTable + i * stride));
        FORMAT_RawDoFmtWithScratchBuffer(TLIBA1_STR_PatternDumpLoopNewline);
    }
}
