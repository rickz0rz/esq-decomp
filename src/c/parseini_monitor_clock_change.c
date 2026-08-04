/* RESTORES: PARSEINI_MonitorClockChange
 * MODULE:   modules/groups/b/a/parseini3_p0.s
 * STATUS:   behavioural
 *
 * Watches for the clock ticking and raises or clears a status flag.
 *
 * The opening test is a BOOLEANIZE, and the disassembly's own comments read it
 * backwards. CMP.W / SNE / NEG.B sets 1 when the two words DIFFER (SNE sets
 * 0xFF on "not equal", NEG.B turns that into +1), so the returned value is
 * "the H and T words disagree". Reading it as "agree" inverts the whole
 * function.
 *
 * The disagreeing branch RAISES the flag once and refreshes; the agreeing
 * branch waits for the clock word to change three times before clearing it.
 * The sample counter is never reset, so the clear happens on the third change
 * after any start.
 *
 * The refresh helper takes (1, 1) on the raise and (1, 0) on the clear -- the
 * push order is the reverse of the argument order.
 *
 * 146 ref vs 160 got. The CMPI.W #3 threshold, the ADDQ.W #1 counter, both
 * snapshot stores, both refresh calls with their ADDQ.W #8 cleanups and the
 * CLR.L / PEA 1 argument pair all match exactly.
 *
 * SASC-MISMATCH: booleanize-shape
 *   ref:     56c2 4402 4882 48c2 2e02
 *            SNE D2 / NEG.B D2 / EXT.W / EXT.L / MOVE.L D2,D7
 *   got:     56c0 7e00 9e00
 *            SNE D0 / MOVEQ #0,D7 / SUB.B D0,D7
 *   summary: both produce 1 when the words differ and 0 when they agree. The
 *            original negates in place and widens; 6.51 subtracts the 0xFF from
 *            a zeroed register, which leaves 1 in the low byte without widening
 *            -- and then has to widen again at each use, which is where most of
 *            the 14 bytes go.
 *   tried:   nothing from the source side; the C is already a plain comparison
 *            expression, which is the shape the original compiled from.
 *   scope:   any function returning a comparison as 1/0. The old-lane memory
 *            "Booleanize NEG.B sign bug class" records a case where getting
 *            this wrong produced -1 instead of +1; both forms here are +1.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void ESQDISP_UpdateStatusMaskAndRefresh(long a, long b);

extern short Global_WORD_H_VALUE;
extern short Global_WORD_T_VALUE;
extern short Global_REF_CLOCKDATA_STRUCT;
extern short PARSEINI_ClockSecondsSnapshot;
extern short PARSEINI_ClockChangeActiveFlag;
extern short PARSEINI_ClockChangeSampleCounter;

long PARSEINI_MonitorClockChange(void)
{
    long differ;

    differ = (Global_WORD_H_VALUE != Global_WORD_T_VALUE) ? 1 : 0;

    if (differ) {
        PARSEINI_ClockSecondsSnapshot = Global_REF_CLOCKDATA_STRUCT;

        if (PARSEINI_ClockChangeActiveFlag != 1) {
            PARSEINI_ClockChangeActiveFlag = 1;
            ESQDISP_UpdateStatusMaskAndRefresh(1L, 1L);
        }
    } else if (PARSEINI_ClockChangeActiveFlag != 0
               && Global_REF_CLOCKDATA_STRUCT != PARSEINI_ClockSecondsSnapshot) {

        PARSEINI_ClockChangeSampleCounter++;
        PARSEINI_ClockSecondsSnapshot = Global_REF_CLOCKDATA_STRUCT;

        if (PARSEINI_ClockChangeSampleCounter >= 3) {
            PARSEINI_ClockChangeActiveFlag = 0;
            ESQDISP_UpdateStatusMaskAndRefresh(1L, 0L);
        }
    }

    return differ;
}
