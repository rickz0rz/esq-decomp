/* RESTORES: DISPTEXT_SetLayoutParams
 * MODULE:   modules/groups/a/i/disptext.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: parameter-load-order
 *   ref:     48e707002e2f00102c2f00142a2f00186100fbc44a876b0e0c87000002706e0623c7000081484a866f0e7014bc806e08200633c0000080cc2f056100fbb2584f203900008148b087661070003039000080ccb08666047001600270004cdf00e04e75
 *   got:     48e707002a2f00182c2f00142e2f0010610000004a876b0e0c87000002706e0623c7000000004a866f0e7014bc806e08200633c0000000002f0561000000584f203900000000b08766107000303900000000b08666047001600270004cdf00e04e75
 *   summary: 98 bytes against 98, and the ONLY difference is a transposition of
 *            the three parameter loads in the prologue. The original emits them
 *            in descending register order (D7<-16, D6<-20, D5<-24); SAS/C emits
 *            ascending (D5<-24, D6<-20, D7<-16). Same registers, same offsets,
 *            same everything after byte 16.
 *   tried:   OPTIMIZE, OPTSIZE, OPTTIME, NOOPTPEEP, OPTGLOBAL. OPTIMIZE changes
 *            the frame layout entirely rather than the order; none produce
 *            descending order.
 *   scope:   every function taking more than one register-allocated parameter.
 *   retest:  SAS/C 6.00 emits the same ascending order, so this class does not
 *            distinguish 6.00 from 6.51 -- both differ from the original.
 */
extern long DISPTEXT_LineWidthPx;
extern unsigned short DISPTEXT_TargetLineIndex;
extern void DISPLIB_ResetTextBufferAndLineTables(void);
extern void DISPLIB_CommitCurrentLinePenAndAdvance(long pen);
long DISPTEXT_SetLayoutParams(long width, long lines, long pen)
{
    DISPLIB_ResetTextBufferAndLineTables();
    if (width >= 0 && width <= 624)
        DISPTEXT_LineWidthPx = width;
    if (lines > 0 && lines <= 20)
        DISPTEXT_TargetLineIndex = (unsigned short)lines;
    DISPLIB_CommitCurrentLinePenAndAdvance(pen);
    if (DISPTEXT_LineWidthPx == width && (long)DISPTEXT_TargetLineIndex == lines)
        return 1;
    return 0;
}
