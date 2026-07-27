/* RESTORES: ESQIFF2_ClearLineHeadTailByMode
 * MODULE:   modules/groups/a/o/esqiff2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: compare-constant-idiom
 *   ref:     7002be40                    MOVEQ #2,D0 / CMP.W D0,D7
 *   got:     20075540                    MOVE.L D7,D0 / SUBQ.W #2,D0
 *   summary: 98 bytes against 98, and this single four-byte idiom is the ONLY
 *            difference in the whole function -- the two calls, the stack-slot
 *            reuse (MOVE.L tail,(A7) rather than a fresh push) and the deferred
 *            LEA 12(A7),A7 cleanup all reproduce exactly. SAS/C tests equality
 *            against a small constant with SUBQ, the original with MOVEQ+CMP.
 *   tried:   if/else, switch/case/default, SHORTINT, reversed comparison operands.
 *   scope:   every equality test against a constant in 1..8.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C.
 */
extern char *ESQIFF_PrimaryLineHeadPtr, *ESQIFF_PrimaryLineTailPtr;
extern char *ESQIFF_SecondaryLineHeadPtr, *ESQIFF_SecondaryLineTailPtr;
extern char *ESQPARS_ReplaceOwnedString(char *newstr, char *old);
void ESQIFF2_ClearLineHeadTailByMode(short mode)
{
    if (mode == 2) {
        ESQIFF_SecondaryLineHeadPtr = ESQPARS_ReplaceOwnedString(0, ESQIFF_SecondaryLineHeadPtr);
        ESQIFF_SecondaryLineTailPtr = ESQPARS_ReplaceOwnedString(0, ESQIFF_SecondaryLineTailPtr);
    } else {
        ESQIFF_PrimaryLineHeadPtr = ESQPARS_ReplaceOwnedString(0, ESQIFF_PrimaryLineHeadPtr);
        ESQIFF_PrimaryLineTailPtr = ESQPARS_ReplaceOwnedString(0, ESQIFF_PrimaryLineTailPtr);
    }
}
