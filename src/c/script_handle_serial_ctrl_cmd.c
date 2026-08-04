/* RESTORES: SCRIPT_HandleSerialCtrlCmd
 * MODULE:   modules/groups/b/a/script3b2.s
 * STATUS:   behavioural
 *
 * The CTRL-line packet parser: one byte per call, four states, XOR checksum.
 * It is polled from the main loop and does nothing at all unless the CTRL line
 * reports a change.
 *
 * TWO GATES BEFORE ANY PARSING, and they are not equivalent. The first pair --
 * the RAVESC select code, or the MSN flag being 'M' -- forces the refresh tick
 * to -1 and SKIPS the hold and display-active checks entirely. Only when
 * neither holds are those two consulted, and either can return early. So a
 * RAVESC unit parses packets while the display is active and a normal one does
 * not.
 *
 * THE TICK COUNTER IS TESTED BY INCREMENT. `Global_RefreshTickCounter + 1 != 0`
 * is the original's `ADDQ.W #1 / BEQ` -- it asks whether the counter is -1
 * without writing it. Only a counter that is NOT -1 gets cleared, so the -1 set
 * by the first gate survives.
 *
 * THE COMMAND-BYTE TABLE HAS 22 ENTRIES AND FOUR OUTCOMES. Codes 1, 12 and 15
 * start a packet unconditionally; ten more start one only when the select code
 * is NOT RAVESC; code 13 enters state 3; the remaining eight are accepted and
 * ignored. The ten gated codes FALL THROUGH into the start-packet block, which
 * is why they are written as a fall-through here rather than duplicated.
 *
 * THE CHECKSUM IS SEEDED BY THE FIRST BYTE AND XORED WITH EVERY BODY BYTE,
 * including the carriage return that ends the body. State 2 then compares the
 * NEXT byte against it.
 *
 * THE BODY INDEX IS PRE-INCREMENTED, so the first body byte lands at index 1
 * and the start byte at index 0 is never overwritten. Post-incrementing loses
 * the command code.
 *
 * A CHECKSUM MATCH TAKES ONE OF THREE PATHS, not two: RAVESC dispatches and
 * repaints; otherwise a deferred-action countdown of 0 OR 1 dispatches, and
 * anything else just counts a deferral. The `0 or 1` is the original's
 * `BEQ / SUBQ #1 / BNE` pair and is easy to read as `== 0` alone.
 *
 * THE OVERFLOW CHECK RUNS AFTER EVERY STATE, including the ones that just reset
 * the parser, and resets everything again at 199 bytes. It only repaints when
 * the runtime mode is 0, and it reads the mode BEFORE clearing the state -- the
 * order is in the original and is preserved.
 *
 * 712 ref vs 728 got, 26 differing regions.
 *
 * SASC-MISMATCH: jump-table-collapsed
 *   ref:     303b 4efb + a 22-entry DC.W table
 *   got:     a compare chain, no table
 *   summary: the original tables the command byte; 6.51 chains it, because the
 *            22 values collapse to four distinct outcomes and a chain is
 *            cheaper. Same dispatch, different shape. This is the second
 *            instance in this tranche -- see
 *            locavail_update_filter_state_machine.c, where one of two tables
 *            survived and the other did not.
 *   tried:   SHORTINT, MEASURED: 688 bytes against the plain form's 728, same
 *            26 regions, and STILL no jump table. It moves the candidate 24
 *            bytes UNDER a 712-byte reference where the plain form is 16 over,
 *            so it is further away by the only size measure available and buys
 *            nothing structurally. Rejected. Fourth SHORTINT counter-example.
 *   scope:   any switch whose cases collapse to few outcomes.
 *            docs/compiler-version.md, "Case body layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void  ESQDISP_UpdateStatusMaskAndRefresh(long mask,
                                                               long flag);
extern long  PARSEINI_CheckCtrlHChange(void);
extern long  SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte(void);
extern void  SCRIPT_HandleBrushCommand(void *ctx, char *buf, long len);
extern void  SCRIPT_ApplyPendingBannerTarget(void);
extern void  ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void  TEXTDISP_SetRastForMode(long mode);
extern void  SCRIPT_ProcessCtrlContextPlaybackTick(void *ctx);
extern void  TEXTDISP_ResetSelectionAndRefresh(void);

extern char  SCRIPT_CTRL_CMD_BUFFER[];
extern char  SCRIPT_CTRL_CONTEXT[];

extern short Global_WORD_SELECT_CODE_IS_RAVESC;
extern char  CONFIG_MSN_FlagChar;
extern short Global_RefreshTickCounter;
extern short SCRIPT_StatusRefreshHoldFlag;
extern long  ESQDISP_DisplayActiveFlag;
extern short SCRIPT_StatusMaskRefreshPending;
extern short Global_REF_CLOCKDATA_STRUCT;
extern short Global_WORD_CLOCK_SECONDS;
extern short Global_UIBusyFlag;
extern short SCRIPT_CTRL_STATE;
extern short SCRIPT_CTRL_READ_INDEX;
extern short SCRIPT_CTRL_CHECKSUM;
extern short SCRIPT_CtrlCmdCount;
extern short SCRIPT_CtrlCmdDeferCounter;
extern short SCRIPT_CtrlCmdChecksumErrorCount;
extern short SCRIPT_CtrlCmdLengthErrorCount;
extern short TEXTDISP_DeferredActionCountdown;
extern short SCRIPT_RuntimeMode;

void SCRIPT_HandleSerialCtrlCmd(void)
{
    long  changed;
    long  b;
    short idx;
    short mode;

    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0 || CONFIG_MSN_FlagChar == 'M') {
        Global_RefreshTickCounter = -1;
    } else {
        if (SCRIPT_StatusRefreshHoldFlag != 0) {
            Global_RefreshTickCounter = 0;
            return;
        }
        if (ESQDISP_DisplayActiveFlag == 1)
            return;
    }

    if (SCRIPT_StatusMaskRefreshPending != 0
        && Global_REF_CLOCKDATA_STRUCT != Global_WORD_CLOCK_SECONDS) {

        Global_WORD_CLOCK_SECONDS++;

        if (Global_WORD_CLOCK_SECONDS >= 3) {
            SCRIPT_StatusMaskRefreshPending = 0;
            ESQDISP_UpdateStatusMaskAndRefresh(32L, 0L);
        }
    }

    changed = PARSEINI_CheckCtrlHChange();

    if (Global_UIBusyFlag != 0)
        return;

    if ((short)changed == 0)
        return;

    if (Global_RefreshTickCounter + 1 != 0)
        Global_RefreshTickCounter = 0;

    b = SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte();

    switch (SCRIPT_CTRL_STATE) {

    case 0:
        switch ((short)(unsigned char)b) {

        case 2:
        case 3:
        case 4:
        case 5:
        case 7:
        case 11:
        case 16:
        case 17:
        case 20:
        case 22:
            if (Global_WORD_SELECT_CODE_IS_RAVESC != 0)
                return;
            /* fall through */

        case 1:
        case 12:
        case 15:
            SCRIPT_CTRL_CMD_BUFFER[SCRIPT_CTRL_READ_INDEX] = (char)b;
            SCRIPT_CTRL_CHECKSUM = (short)(unsigned char)b;
            SCRIPT_CtrlCmdCount++;
            SCRIPT_CTRL_STATE = 1;
            break;

        case 13:
            SCRIPT_CTRL_STATE = 3;
            break;

        default:
            break;
        }
        break;

    case 1:
        idx = SCRIPT_CTRL_READ_INDEX + 1;
        SCRIPT_CTRL_READ_INDEX = idx;
        SCRIPT_CTRL_CMD_BUFFER[idx] = (char)b;

        if ((char)b == 13)
            SCRIPT_CTRL_STATE = 2;

        SCRIPT_CTRL_CHECKSUM =
            (short)((long)SCRIPT_CTRL_CHECKSUM ^ (long)(unsigned char)b);
        break;

    case 2:
        if ((long)(unsigned char)b != (long)SCRIPT_CTRL_CHECKSUM) {

            ESQDISP_UpdateStatusMaskAndRefresh(32L, 1L);
            Global_WORD_CLOCK_SECONDS = Global_REF_CLOCKDATA_STRUCT;
            SCRIPT_CtrlCmdChecksumErrorCount++;
            SCRIPT_StatusMaskRefreshPending = 1;

        } else if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {

            SCRIPT_HandleBrushCommand(SCRIPT_CTRL_CONTEXT,
                                      SCRIPT_CTRL_CMD_BUFFER,
                                      (long)SCRIPT_CTRL_READ_INDEX);
            SCRIPT_ApplyPendingBannerTarget();
            ESQ_SetCopperEffect_OnEnableHighlight();
            TEXTDISP_SetRastForMode(0L);

        } else if (TEXTDISP_DeferredActionCountdown == 0
                   || TEXTDISP_DeferredActionCountdown == 1) {

            SCRIPT_HandleBrushCommand(SCRIPT_CTRL_CONTEXT,
                                      SCRIPT_CTRL_CMD_BUFFER,
                                      (long)SCRIPT_CTRL_READ_INDEX);
            SCRIPT_ProcessCtrlContextPlaybackTick(SCRIPT_CTRL_CONTEXT);

        } else {
            SCRIPT_CtrlCmdDeferCounter++;
        }

        SCRIPT_CTRL_STATE = SCRIPT_CTRL_READ_INDEX = SCRIPT_CTRL_CHECKSUM = 0;
        break;

    case 3:
        SCRIPT_CTRL_STATE = 0;
        break;

    default:
        SCRIPT_CTRL_STATE = SCRIPT_CTRL_READ_INDEX = SCRIPT_CTRL_CHECKSUM = 0;
        break;
    }

    if (SCRIPT_CTRL_READ_INDEX <= 198)
        return;

    SCRIPT_CtrlCmdLengthErrorCount++;
    SCRIPT_CTRL_CHECKSUM   = 0;
    SCRIPT_CTRL_READ_INDEX = 0;
    mode = SCRIPT_RuntimeMode;
    SCRIPT_CTRL_STATE = 0;

    if (mode != 0)
        return;

    TEXTDISP_ResetSelectionAndRefresh();
}
