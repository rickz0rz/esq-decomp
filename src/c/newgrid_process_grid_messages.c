/* RESTORES: NEWGRID_ProcessGridMessages
 * MODULE:   modules/groups/b/a/newgrid_p4_p1.s
 * STATUS:   behavioural
 *
 * The grid state machine. It takes ONE message off the highlight reply port and
 * then runs the mode dispatch REPEATEDLY on that single message until the
 * message asks it to stop.
 *
 * THE SWITCH IS INSIDE A LOOP, and this is the thing to understand about the
 * function. The tail after every case tests the message word at +52 and jumps
 * back to the dispatch when it is zero. Each case advances the mode by calling
 * NEWGRID_MapSelectionToMode, so one message drives the machine through as many
 * states as it takes to reach a state that sets that word. Reading the dispatch
 * as a plain switch -- one message, one action -- gets the control flow
 * completely wrong.
 *
 * A CONSEQUENCE WORTH STATING: an out-of-range mode HANGS. The range check in
 * front of the jump table sends modes outside 1..12 to the loop test, which
 * finds the word still zero and dispatches again with the mode unchanged. There
 * is no path that clears the mode or breaks out. The program depends on
 * MapSelectionToMode never returning a mode outside the table.
 *
 * The word at +52 is compared with `BLS` against 0, which for an unsigned word
 * means equality -- so any nonzero value ends the loop, including one with the
 * high bit set.
 *
 * THE MODE NUMBERS IN THE SOURCE ARE ONE HIGHER THAN THE TABLE INDICES. The
 * original subtracts 1 before bounds-checking, so table entry 0 is mode 1. The
 * case labels below are the MODE numbers, which is why they run 1..12 and why
 * the disassembly labels them 0..11.
 *
 * THE GRID OPERATION CODES ARE NOT IN MODE ORDER. Modes 4..10 all call
 * NEWGRID2_DispatchGridOperation but with operation codes 1, 5, 2, 3, 4, 6, 7
 * respectively. The 5 sits between 1 and 2. Renumbering them to match the modes
 * would be a behaviour change.
 *
 * Modes 6 through 10 set the header-redraw flag when the operation returns
 * nonzero and do NOT advance the mode; modes 4 and 5 simply do not advance.
 * That difference is per-case in the original and is reproduced per-case here.
 *
 * The final redraw choice reads the same header-redraw flag AFTER the loop, so
 * a flag set by any iteration selects the heavier top-bars redraw for the whole
 * message.
 *
 * THE INITIALISATION BLOCK RUNS BEFORE THE MESSAGE IS FETCHED and can leave the
 * function without one -- GetMsg returning null returns immediately, so the
 * whole grid rebuild can happen with no message to answer. That ordering is the
 * original's.
 *
 * 1202 ref vs 1156 got, 26 differing regions. THE JUMP TABLE IS REPRODUCED: the
 * reference emits `303b` (MOVE.W (d8,PC,Xn),D0) and `4efb` (JMP (d8,PC,Xn)) and
 * so does this candidate, which is the check that matters for a dispatcher --
 * an `if/else` chain would emit neither. Per AGENTS.md, no explicit range guard
 * is written; the switch default carries the bound the original folded into the
 * table.
 *
 * The busy flag, the 0x101 read-mode test, both refresh-state comparisons, the
 * whole initialisation block, GetMsg and PutMsg, the ValidateSelectionCode
 * call, all twelve case bodies with their distinct operation codes, all
 * fourteen MapSelectionToMode calls and the two closing redraw calls match in
 * kind and size.
 *
 * GetMsg AND PutMsg COME FROM esq-exec.h, not from hand-written externs. An
 * earlier draft declared them locally, which compiled and linked to nothing --
 * tools/check_c_symbols.py reported them as ABSENT with "no label either way",
 * because there is no ESQ assembly symbol of that name to rename. Including the
 * header costs 12 bytes in volatile-base reloads and is the only correct form.
 *
 * The candidate is 46 bytes UNDER the reference and that is accounted for in
 * one region: the 12 case bodies are 978 bytes in the original and 938 here.
 * The original writes the identical "map the selection and store the mode" tail
 * out TWELVE times; 6.51 shares it between the cases that reach it the same
 * way. Same calls, same order, fewer copies.
 *
 * SASC-MISMATCH: unshared-case-tails
 *   ref:     the MapSelectionToMode call and its store repeated per case
 *   got:     one copy, branched to from the cases that agree
 *   summary: tail sharing across switch arms. 6.51 does it and the original
 *            does not, which is the whole 40-byte difference in the dispatch
 *            block and 58 of the function overall.
 *   tried:   nothing source-level reaches it. The C already writes the tail
 *            once per case, exactly as the original has it; whether the code
 *            generator then merges them is not expressible in the source.
 *   scope:   any switch whose arms end identically.
 *            docs/compiler-version.md, "Case body layout".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"

struct HighlightMsg {
    char  pad0[32];
    long  f32;                      /* +32 */
    char  pad36[16];
    short f52;                      /* +52, nonzero ends the dispatch loop */
    char  pad54[6];
    char  panel[4];                 /* +60 = 0x3c */
};

extern void  NEWGRID_InitGridResources(void);
extern void  NEWGRID_ClearHighlightArea(void);
extern void  CLEANUP_DrawClockBanner(void);
extern void  CLEANUP_DrawClockFormatList(long slot);
extern void  CLEANUP_DrawClockFormatFrame(void);
extern long  NEWGRID_AdjustClockStringBySlot(void *clock);
extern long  NEWGRID_AdjustClockStringBySlotWithOffset(void *clock);
extern short NEWGRID_ComputeDaySlotFromClock(void *clock);
extern short NEWGRID_ComputeDaySlotFromClockWithOffset(void *clock);
extern void  NEWGRID2_DispatchOperationDefault(void);
extern long  NEWGRID_MapSelectionToMode(long state, long daySlot);
extern void  NEWGRID_ValidateSelectionCode(struct HighlightMsg *m, long zero);
extern short WDISP_UpdateSelectionPreviewPanel(
                 char *panel, struct HighlightMsg *m);
extern void  NEWGRID_DrawClockFormatHeader(struct HighlightMsg *m, long slot);
extern void  NEWGRID_DrawDateBanner(struct HighlightMsg *m);
extern void  NEWGRID_DrawAwaitingListingsMessage(struct HighlightMsg *m);
extern long  NEWGRID2_DispatchGridOperation(long op, struct HighlightMsg *m,
                                            long daySlot, long renderSlot);
extern void  GCOMMAND_UpdatePresetEntryCache(struct HighlightMsg *m);
extern void  NEWGRID_DrawGridTopBars(void);
extern void  NEWGRID_DrawTopBorderLine(void);

extern struct MsgPort *ESQ_HighlightReplyPort;
extern struct MsgPort *ESQ_HighlightMsgPort;

extern short Global_UIBusyFlag;
extern short ESQPARS2_ReadModeFlags;
extern long  NEWGRID_RefreshStateFlag;
extern long  NEWGRID_MainModeState;
extern short NEWGRID_SelectedDaySlot;
extern short NEWGRID_RenderDaySlot;
extern short NEWGRID_HeaderRedrawPending;
extern char  CLOCK_DaySlotIndex[];
extern short CLOCK_CurrentDayOfWeekIndex;

void NEWGRID_ProcessGridMessages(void)
{
    struct HighlightMsg *msg;

    if (Global_UIBusyFlag != 0)
        return;

    if (ESQPARS2_ReadModeFlags == 0x101) {
        ESQPARS2_ReadModeFlags = 0;
        return;
    }

    if (NEWGRID_RefreshStateFlag == 0 || NEWGRID_RefreshStateFlag == 1)
        NEWGRID_MainModeState = 0;

    if (NEWGRID_MainModeState == 0) {

        NEWGRID_InitGridResources();
        NEWGRID_ClearHighlightArea();
        CLEANUP_DrawClockBanner();

        CLEANUP_DrawClockFormatList(
            NEWGRID_AdjustClockStringBySlot(&CLOCK_CurrentDayOfWeekIndex));

        CLEANUP_DrawClockFormatFrame();

        ESQPARS2_ReadModeFlags   = 0;
        NEWGRID_RefreshStateFlag = 2;

        NEWGRID2_DispatchOperationDefault();

        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, 0L);
    }

    msg = (struct HighlightMsg *)GetMsg(ESQ_HighlightReplyPort);
    if (msg == 0)
        return;

    msg->f52 = 0;
    NEWGRID_ValidateSelectionCode(msg, 0L);
    msg->f32 = 0;

    do {
        switch (NEWGRID_MainModeState) {

        case 1:
            if (WDISP_UpdateSelectionPreviewPanel(msg->panel,
                                                                 msg) != 0)
                break;
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 2:
            NEWGRID_SelectedDaySlot =
                NEWGRID_ComputeDaySlotFromClock(CLOCK_DaySlotIndex);
            NEWGRID_RenderDaySlot = (short)NEWGRID_AdjustClockStringBySlot(
                                        &CLOCK_CurrentDayOfWeekIndex);
            NEWGRID_DrawClockFormatHeader(msg, (long)NEWGRID_RenderDaySlot);
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 3:
            NEWGRID_DrawDateBanner(msg);
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 4:
            if (NEWGRID2_DispatchGridOperation(
                    1L, msg, (long)NEWGRID_SelectedDaySlot,
                    (long)NEWGRID_RenderDaySlot) != 0)
                break;
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 5:
            if (NEWGRID2_DispatchGridOperation(
                    5L, msg, (long)NEWGRID_SelectedDaySlot,
                    (long)NEWGRID_RenderDaySlot) != 0)
                break;
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 6:
            if (NEWGRID2_DispatchGridOperation(
                    2L, msg, (long)NEWGRID_SelectedDaySlot,
                    (long)NEWGRID_RenderDaySlot) != 0) {
                NEWGRID_HeaderRedrawPending = 1;
                break;
            }
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 7:
            if (NEWGRID2_DispatchGridOperation(
                    3L, msg, (long)NEWGRID_SelectedDaySlot,
                    (long)NEWGRID_RenderDaySlot) != 0) {
                NEWGRID_HeaderRedrawPending = 1;
                break;
            }
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 8:
            if (NEWGRID2_DispatchGridOperation(
                    4L, msg, (long)NEWGRID_SelectedDaySlot,
                    (long)NEWGRID_RenderDaySlot) != 0) {
                NEWGRID_HeaderRedrawPending = 1;
                break;
            }
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 9:
            NEWGRID_SelectedDaySlot =
                NEWGRID_ComputeDaySlotFromClockWithOffset(CLOCK_DaySlotIndex);
            NEWGRID_RenderDaySlot =
                (short)NEWGRID_AdjustClockStringBySlotWithOffset(
                    &CLOCK_CurrentDayOfWeekIndex);
            if (NEWGRID2_DispatchGridOperation(
                    6L, msg, (long)NEWGRID_SelectedDaySlot,
                    (long)NEWGRID_RenderDaySlot) != 0) {
                NEWGRID_HeaderRedrawPending = 1;
                break;
            }
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 10:
            NEWGRID_SelectedDaySlot =
                NEWGRID_ComputeDaySlotFromClock(CLOCK_DaySlotIndex);
            NEWGRID_RenderDaySlot = (short)NEWGRID_AdjustClockStringBySlot(
                                        &CLOCK_CurrentDayOfWeekIndex);
            if (NEWGRID2_DispatchGridOperation(
                    7L, msg, (long)NEWGRID_SelectedDaySlot,
                    (long)NEWGRID_RenderDaySlot) != 0) {
                NEWGRID_HeaderRedrawPending = 1;
                break;
            }
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 11:
            NEWGRID_DrawAwaitingListingsMessage(msg);
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;

        case 12:
            if (NEWGRID_HeaderRedrawPending != 0) {
                NEWGRID_DrawClockFormatHeader(msg,
                                              (long)NEWGRID_RenderDaySlot);
                NEWGRID_HeaderRedrawPending = 0;
            }
            NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(
                NEWGRID_MainModeState, (long)NEWGRID_SelectedDaySlot);
            break;
        }
    } while (msg->f52 == 0);

    GCOMMAND_UpdatePresetEntryCache(msg);
    PutMsg(ESQ_HighlightMsgPort, (struct Message *)msg);

    if (NEWGRID_HeaderRedrawPending != 0)
        NEWGRID_DrawGridTopBars();
    else
        NEWGRID_DrawTopBorderLine();
}
