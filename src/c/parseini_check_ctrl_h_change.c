/* RESTORES: PARSEINI_CheckCtrlHChange
 * MODULE:   modules/groups/b/a/parseini.s
 * STATUS:   behavioural
 *
 * 170 bytes in the original, 196 emitted, 5 differing regions.
 *
 * Reproduces: the booleanised change test (SNE / NEG.B / EXT.W / EXT.L), the
 * two-path structure where a fresh change with the gate open arms the pending
 * flag and refreshes the status mask, and the other path where an already-armed
 * flag is disarmed once the clock has moved on -- immediately if the gate is
 * closed, or after three clock ticks if it is open. The change result is returned
 * on every path, including the ones that do nothing.
 *
 * SASC-MISMATCH: register-constant-reuse
 *   ref:     7001 b079xxxxxxxx 675e ... 33c0xxxxxxxx
 *            MOVEQ #1,D0 / CMP.W flag,D0 / BEQ ... / MOVE.W D0,flag
 *   got:     3039xxxxxxxx 5340 6716 ... 33fc0001xxxxxxxx
 *            load flag / SUBQ #1 / BEQ ... / MOVE.W #1,flag
 *   summary: The original loads the constant 1 into a register once and uses it
 *            both as the comparison operand and as the value stored afterwards.
 *            SAS/C compares by subtracting from the loaded flag and then stores a
 *            fresh immediate. Same family as the register-zero-reuse recorded in
 *            ctasks_ifftaskcleanup.c, and like that one it is not reachable from
 *            the source -- `if (flag != 1) flag = 1;` is already the natural
 *            phrasing, and there is no way to tell the compiler to keep the 1.
 *   scope:   any compare-then-store against the same small constant.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the two cross-unit calls.
 */
extern void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(long mask, long on);
extern short CTRL_H;
extern short CTRL_HPreviousSample;
extern short PARSEINI_CtrlHChangeGateFlag;
extern short PARSEINI_CtrlHClockSnapshot;
extern short PARSEINI_CtrlHChangeGateCounter;
extern short PARSEINI_CtrlHChangePendingFlag;
extern short Global_REF_CLOCKDATA_STRUCT;

long PARSEINI_CheckCtrlHChange(void)
{
    register long changed;

    changed = (CTRL_H != CTRL_HPreviousSample);

    if (changed && PARSEINI_CtrlHChangeGateFlag) {
        PARSEINI_CtrlHClockSnapshot = Global_REF_CLOCKDATA_STRUCT;
        PARSEINI_CtrlHChangeGateCounter = 0;
        if (PARSEINI_CtrlHChangePendingFlag != 1) {
            PARSEINI_CtrlHChangePendingFlag = 1;
            SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(16, 1);
        }
        return changed;
    }

    if (PARSEINI_CtrlHChangePendingFlag == 0)
        return changed;
    if (Global_REF_CLOCKDATA_STRUCT == PARSEINI_CtrlHClockSnapshot)
        return changed;

    PARSEINI_CtrlHClockSnapshot = Global_REF_CLOCKDATA_STRUCT;

    if (PARSEINI_CtrlHChangeGateFlag) {
        PARSEINI_CtrlHChangeGateCounter++;
        if (PARSEINI_CtrlHChangeGateCounter < 3)
            return changed;
    }

    PARSEINI_CtrlHChangePendingFlag = 0;
    SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(16, 0);
    return changed;
}
