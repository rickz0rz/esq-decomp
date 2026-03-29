#include <exec/types.h>

typedef UBYTE HighlightMsg;

enum {
    HIGHLIGHTMSG_StateWord52 = 52,
    HIGHLIGHTMSG_ParamD32 = 32,
    HIGHLIGHTMSG_RastPort60 = 60
};

extern void *AbsExecBase;
extern void *ESQ_HighlightReplyPort;
extern void *ESQ_HighlightMsgPort;

extern WORD Global_UIBusyFlag;
extern UWORD ESQPARS2_ReadModeFlags;
extern LONG NEWGRID_RefreshStateFlag;
extern LONG NEWGRID_MainModeState;
extern UWORD NEWGRID_SelectedDaySlot;
extern UWORD NEWGRID_RenderDaySlot;
extern WORD NEWGRID_HeaderRedrawPending;

extern UWORD CLOCK_CurrentDayOfWeekIndex;
extern UWORD CLOCK_DaySlotIndex;

extern void NEWGRID_InitGridResources(void);
extern void NEWGRID_ClearHighlightArea(void);
extern void CLEANUP_DrawClockBanner(void);
extern LONG NEWGRID_AdjustClockStringBySlot(void *clockPtr);
extern void CLEANUP_DrawClockFormatList(LONG startSlot);
extern void CLEANUP_DrawClockFormatFrame(void);
extern void NEWGRID2_DispatchOperationDefault(void);
extern LONG NEWGRID_MapSelectionToMode(LONG selection, WORD gateSelector);
extern LONG _LVOGetMsg(void *execBase, void *port);
extern void NEWGRID_ValidateSelectionCode(char *gridCtx, LONG code);
extern LONG WDISP_UpdateSelectionPreviewPanel(void *entryBrushRastPort, void *previewPanel);
extern LONG NEWGRID_ComputeDaySlotFromClock(void *clockPtr);
extern void NEWGRID_DrawClockFormatHeader(char *gridCtx, LONG startSlot);
extern void NEWGRID_DrawDateBanner(char *gridCtx);
extern LONG NEWGRID_DrawAwaitingListingsMessage(char *gridCtx);
extern LONG NEWGRID2_DispatchGridOperation(LONG operationId, char *gridCtx, WORD rowIndex, WORD selector);
extern void GCOMMAND_UpdatePresetEntryCache(void *msg);
extern void _LVOPutMsg(void *port, void *msg);
extern void NEWGRID_DrawGridTopBars(void);
extern void NEWGRID_DrawTopBorderLine(void);
extern LONG NEWGRID_ComputeDaySlotFromClockWithOffset(void *clockPtr);
extern LONG NEWGRID_AdjustClockStringBySlotWithOffset(void *clockPtr);

void NEWGRID_ProcessGridMessages(void)
{
    HighlightMsg *msg;
    LONG mode;
    LONG dispatchResult;

    if (Global_UIBusyFlag != 0) {
        return;
    }

    if (ESQPARS2_ReadModeFlags == 0x0101) {
        ESQPARS2_ReadModeFlags = 0;
        return;
    }

    if (NEWGRID_RefreshStateFlag == 0 || NEWGRID_RefreshStateFlag == 1) {
        NEWGRID_MainModeState = 0;
    }

    if (NEWGRID_MainModeState == 0) {
        NEWGRID_InitGridResources();
        NEWGRID_ClearHighlightArea();
        CLEANUP_DrawClockBanner();
        CLEANUP_DrawClockFormatList(
            NEWGRID_AdjustClockStringBySlot(&CLOCK_CurrentDayOfWeekIndex));
        CLEANUP_DrawClockFormatFrame();
        ESQPARS2_ReadModeFlags = 0;
        NEWGRID_RefreshStateFlag = 2;
        NEWGRID2_DispatchOperationDefault();
        NEWGRID_MainModeState = NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, 0);
    }

    msg = (HighlightMsg *)_LVOGetMsg(AbsExecBase, ESQ_HighlightReplyPort);
    if (msg == (HighlightMsg *)0) {
        return;
    }

    *(UWORD *)(msg + HIGHLIGHTMSG_StateWord52) = 0;
    NEWGRID_ValidateSelectionCode((char *)msg, 0);
    *(LONG *)(msg + HIGHLIGHTMSG_ParamD32) = 0;

dispatch_main_mode:
    mode = NEWGRID_MainModeState - 1;
    if (mode < 0 || mode >= 12) {
        goto finalize_and_reply_message;
    }

    switch (mode) {
    case 0:
        if (WDISP_UpdateSelectionPreviewPanel(
                msg + HIGHLIGHTMSG_RastPort60,
                msg) != 0) {
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 1:
        NEWGRID_SelectedDaySlot =
            (UWORD)NEWGRID_ComputeDaySlotFromClock(&CLOCK_DaySlotIndex);
        NEWGRID_RenderDaySlot =
            (UWORD)NEWGRID_AdjustClockStringBySlot(&CLOCK_CurrentDayOfWeekIndex);
        NEWGRID_DrawClockFormatHeader((char *)msg, (LONG)NEWGRID_RenderDaySlot);
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 2:
        NEWGRID_DrawDateBanner((char *)msg);
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 3:
        dispatchResult = NEWGRID2_DispatchGridOperation(
            1,
            (char *)msg,
            (WORD)NEWGRID_SelectedDaySlot,
            (WORD)NEWGRID_RenderDaySlot);
        if (dispatchResult != 0) {
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 4:
        dispatchResult = NEWGRID2_DispatchGridOperation(
            5,
            (char *)msg,
            (WORD)NEWGRID_SelectedDaySlot,
            (WORD)NEWGRID_RenderDaySlot);
        if (dispatchResult != 0) {
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 5:
        dispatchResult = NEWGRID2_DispatchGridOperation(
            2,
            (char *)msg,
            (WORD)NEWGRID_SelectedDaySlot,
            (WORD)NEWGRID_RenderDaySlot);
        if (dispatchResult != 0) {
            NEWGRID_HeaderRedrawPending = 1;
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 6:
        dispatchResult = NEWGRID2_DispatchGridOperation(
            3,
            (char *)msg,
            (WORD)NEWGRID_SelectedDaySlot,
            (WORD)NEWGRID_RenderDaySlot);
        if (dispatchResult != 0) {
            NEWGRID_HeaderRedrawPending = 1;
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 7:
        dispatchResult = NEWGRID2_DispatchGridOperation(
            4,
            (char *)msg,
            (WORD)NEWGRID_SelectedDaySlot,
            (WORD)NEWGRID_RenderDaySlot);
        if (dispatchResult != 0) {
            NEWGRID_HeaderRedrawPending = 1;
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 8:
        NEWGRID_SelectedDaySlot =
            (UWORD)NEWGRID_ComputeDaySlotFromClockWithOffset(&CLOCK_DaySlotIndex);
        NEWGRID_RenderDaySlot =
            (UWORD)NEWGRID_AdjustClockStringBySlotWithOffset(&CLOCK_CurrentDayOfWeekIndex);
        dispatchResult = NEWGRID2_DispatchGridOperation(
            6,
            (char *)msg,
            (WORD)NEWGRID_SelectedDaySlot,
            (WORD)NEWGRID_RenderDaySlot);
        if (dispatchResult != 0) {
            NEWGRID_HeaderRedrawPending = 1;
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 9:
        NEWGRID_SelectedDaySlot =
            (UWORD)NEWGRID_ComputeDaySlotFromClock(&CLOCK_DaySlotIndex);
        NEWGRID_RenderDaySlot =
            (UWORD)NEWGRID_AdjustClockStringBySlot(&CLOCK_CurrentDayOfWeekIndex);
        dispatchResult = NEWGRID2_DispatchGridOperation(
            7,
            (char *)msg,
            (WORD)NEWGRID_SelectedDaySlot,
            (WORD)NEWGRID_RenderDaySlot);
        if (dispatchResult != 0) {
            NEWGRID_HeaderRedrawPending = 1;
            goto finalize_and_reply_message;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 10:
        NEWGRID_DrawAwaitingListingsMessage((char *)msg);
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        goto finalize_and_reply_message;

    case 11:
        if (NEWGRID_HeaderRedrawPending != 0) {
            NEWGRID_DrawClockFormatHeader((char *)msg, (LONG)NEWGRID_RenderDaySlot);
            NEWGRID_HeaderRedrawPending = 0;
        }
        NEWGRID_MainModeState =
            NEWGRID_MapSelectionToMode(NEWGRID_MainModeState, (WORD)NEWGRID_SelectedDaySlot);
        break;
    }

finalize_and_reply_message:
    if (*(UWORD *)(msg + HIGHLIGHTMSG_StateWord52) <= 0) {
        goto dispatch_main_mode;
    }

    GCOMMAND_UpdatePresetEntryCache(msg);
    _LVOPutMsg(ESQ_HighlightMsgPort, msg);

    if (NEWGRID_HeaderRedrawPending != 0) {
        NEWGRID_DrawGridTopBars();
    } else {
        NEWGRID_DrawTopBorderLine();
    }
}
