/* RESTORES: ED_HandleEditAttributesInput
 * MODULE:   modules/groups/a/l/ed3.s
 * STATUS:   behavioural
 * OPTIONS:  SHORTINT
 *
 * 166 bytes in the original and 166 emitted, 6 differing regions -- and unlike
 * the six coincidences elsewhere in this directory, the residual here is only
 * branch displacements and case ordering.
 *
 * Two source decisions were needed to get here, and both are worth recording
 * because the first attempt landed at 172 bytes with the dispatch entirely
 * different:
 *
 *   1. The key tests must be a SWITCH, not an if/else chain. Written as
 *      `if (key == 13 || key == 27)` SAS/C emits independent byte compares;
 *      written as a switch it emits the original's chained subtract
 *      (SUBI #13 / SUBI #14 / SUBI #$80), where each test consumes the running
 *      difference from the last.
 *
 *   2. It then needs SHORTINT. Without it the chain comes out as
 *      MOVEQ #13,D1 / SUB.L D1,D0 -- the right shape at the wrong width. With it
 *      the SUBI.W encoding matches the original exactly.
 *
 * Neither alone is enough; the switch fixes the structure and SHORTINT fixes the
 * width. That combination is now the standard recipe for these keyboard
 * dispatchers -- see also ed_handle_special_functions_menu.c and
 * ed_handle_edit_attributes_menu.c, both of which needed SHORTINT for the same
 * reason.
 *
 * Reproduces: the 13/27 help path, the 155 path with its space check and the
 * 64/65 increment-or-decrement split (with the ring index recomputed for the
 * second test rather than cached, as the original does), and the default path
 * that toggles the active flag through the booleanize helper.
 *
 * SASC-MISMATCH: case-body-layout-order
 *   summary: The compare chain matches; the bodies are placed in a different
 *            order, so the six regions are all branch displacements.
 */
extern void ED_DrawESCMenuBottomHelp(void);
extern void ED_ApplyActiveFlagToAdData(void);
extern void ED_IncrementAdNumber(void);
extern void ED_DecrementAdNumber(void);
extern void ED_UpdateActiveInactiveIndicator(void);
extern short ESQDISP_TestWordIsZeroBooleanize(long v);
extern unsigned char ED_LastKeyCode;
extern long ED_StateRingIndex;
extern unsigned char ED_StateRingTable[];
extern long ED_SaveTextAdsOnExitFlag;
extern long ED_AdActiveFlag;
extern long ED_AdDisplayResetFlag;

void ED_HandleEditAttributesInput(void)
{
    switch (ED_LastKeyCode) {
    case 13:
    case 27:
        ED_DrawESCMenuBottomHelp();
        ED_SaveTextAdsOnExitFlag = 1;
        ED_ApplyActiveFlagToAdData();
        return;

    case 155:
        if (ED_StateRingTable[ED_StateRingIndex * 5 + 1] != ' ')
            return;
        if (ED_StateRingTable[ED_StateRingIndex * 5 + 2] == 64) {
            ED_IncrementAdNumber();
            return;
        }
        if (ED_StateRingTable[ED_StateRingIndex * 5 + 2] != 65)
            return;
        ED_DecrementAdNumber();
        return;
    }

    ED_AdActiveFlag = ESQDISP_TestWordIsZeroBooleanize(ED_AdActiveFlag);
    ED_AdDisplayResetFlag = 1;
    ED_UpdateActiveInactiveIndicator();
}
