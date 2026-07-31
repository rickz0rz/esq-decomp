/* RESTORES: DISPTEXT_ComputeVisibleLineCount
 * MODULE:   modules/groups/a/i/disptextb.s
 * STATUS:   behavioural
 *
 * Works out how many display lines the current text occupies.
 *
 * THE FIRST TEST IS A MAXIMUM, NOT A MINIMUM, and it is easy to read the other
 * way round. CMP.L D7,D0 / BGE lands on the branch that keeps
 * DISPTEXT_TargetLineIndex, so the larger of the two wins.
 *
 * The line height is (count * NEWGRID_RowHeightPx) / 4, and the divide is the
 * signed sequence TST.L / BPL / ADDQ #3 / ASR #2 -- so it happens in long even
 * though the row height is an unsigned short.
 *
 * A count of exactly 1 adds 2 more lines; any other count adds nothing.
 *
 * The control-marker bonus needs FOUR things to be true: the flag set, the
 * buffer pointer non-null, and BOTH marker characters (19 and 20) present. Any
 * one failing skips the +2, and each is a separate early exit in the original.
 *
 * 158 ref vs 152 got. The maximum select, the signed divide-by-four
 * (4a80 6a02 5680 e480), the count-of-one bonus, the marker flag test, the
 * ASL.L #2 table index, both FindCharPtr calls with their ADDQ.W #8 cleanups
 * and the closing ADDQ.L #2 all match in kind and size.
 *
 * SASC-MISMATCH: mul32-helper-vs-inline
 *   ref:     4ebad7b4          JSR MATH_Mulu32(PC)
 *   got:     5380 57c0 7200 9200 9200
 *            a SUBQ/Scc/SUB chain
 *   summary: the count * row-height product goes to the 32-bit multiply helper
 *            in the original; 6.51 does not call anything. Note this is NOT the
 *            usual constant strength-reduction -- neither operand is a
 *            compile-time constant here -- so 6.51 is inlining a general
 *            multiply, which is a stronger form of the same class.
 *   scope:   program-wide. docs/compiler-version.md, "Arithmetic: three more
 *            classes".
 *   retest:  a compiler that emits a helper call for a 32-bit multiply.
 *
 * SASC-MISMATCH: word-widening-idiom
 *   ref:     7000 3039....     MOVEQ #0,D0 / MOVE.W index,D0
 *   got:     3039.... 484042404840
 *                              MOVE.W / SWAP / CLR.W / SWAP
 *   summary: the unsigned-short widening idiom, the same item recorded in
 *            disptext_measure_current_line_length.c, and rejected there for the
 *            same reason -- the signed spelling is shorter and wrong.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void  DISPTEXT_FinalizeLineTable(void);
extern long __asm GROUP_AG_JMPTBL_MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern char *GROUP_AI_JMPTBL_STR_FindCharPtr(char *s, long ch);

extern unsigned short DISPTEXT_TargetLineIndex;
extern unsigned short NEWGRID_RowHeightPx;
extern short DISPTEXT_ControlMarkersEnabledFlag;
extern char *DISPTEXT_TextBufferPtr[];

long DISPTEXT_ComputeVisibleLineCount(long minLines)
{
    long  count;
    long  lines;
    char *text;

    DISPTEXT_FinalizeLineTable();

    if (DISPTEXT_TargetLineIndex >= minLines)
        count = DISPTEXT_TargetLineIndex;
    else
        count = minLines;

    lines = count * (long)NEWGRID_RowHeightPx / 4;
    lines += (count == 1) ? 2 : 0;

    if (DISPTEXT_ControlMarkersEnabledFlag != 0) {
        text = DISPTEXT_TextBufferPtr[DISPTEXT_TargetLineIndex];

        if (text != 0
            && GROUP_AI_JMPTBL_STR_FindCharPtr(text, 19L) != 0
            && GROUP_AI_JMPTBL_STR_FindCharPtr(text, 20L) != 0)
            lines += 2;
    }

    return lines;
}
