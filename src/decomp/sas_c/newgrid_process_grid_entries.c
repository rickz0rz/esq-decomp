#include <exec/types.h>
typedef struct LayoutCtx {
    UWORD currentHalfHeight;
    LONG currentVisibleLines;
    char scratch[60];
} LayoutCtx;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
} NEWGRID_AuxData;

typedef struct NEWGRID_Entry {
    UBYTE pad0[1];
} NEWGRID_Entry;

extern LONG NEWGRID_GridEntriesWorkflowState;
extern LONG NEWGRID_GridOperationId;
extern LONG NEWGRID_SelectionMarkerPenState;
extern LONG NEWGRID_HeaderFramePenId;
extern LONG NEWGRID_SelectedGridEntryPtr;
extern LONG NEWGRID_OverridePenIndex;
extern LONG NEWGRID_RowLayoutCommitPenId;
extern UWORD NEWGRID_RowHeightPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern LONG GCOMMAND_NicheFramePen;
extern UBYTE CONFIG_NewgridPlaceholderBevelFlag;
extern UWORD CLOCK_DaySlotIndex;

extern const char *TEXTDISP_PrimaryTitlePtrTable[];
extern NEWGRID_Entry *TEXTDISP_PrimaryEntryPtrTable[];

extern LONG NEWGRID_DrawGridHeaderRows(char *ctx, LONG framePen, LONG markerPen);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast(void);
extern LONG ESQ_GetHalfHourSlotIndex(UWORD *slot);
extern LONG NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(const char *title);
extern LONG NEWGRID_SelectEntryPen(const void *entryPtr);
extern void NEWGRID_DrawGridFrame(char *ctx, LONG style, LONG pen, LONG entryPen, LONG rowHeight);
extern const char *ESQDISP_GetEntryPointerByMode(LONG idx, LONG mode);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG idx, LONG mode);
extern LONG NEWGRID_GetEntryStateCode(const void *entry, const void *aux, UWORD row);
extern LONG NEWGRID_TestEntryState(LONG baseState, LONG titleIdx, LONG wildcardIdx, UWORD rowIdx);
extern LONG NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *aux, LONG row);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG x, LONG h, LONG pen);
/* Keep K&R-style declaration: SAS/C long-name significance causes a prototype clash
 * with NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount in this translation unit. */
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths();
extern void NEWGRID_DrawEntryRowOrPlaceholder(char *scratch, char *entry, LONG aux, LONG row, LONG span, LONG state);
extern LONG NEWGRID_DrawSelectionMarkers(char *ctx, LONG row, LONG span, LONG pen, LONG leftState, LONG rightState);
extern void NEWGRID_DrawGridCell(char *scratch, const void *entry, LONG style);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG layoutMode);

LONG NEWGRID_ProcessGridEntries(char *ctx, LONG titleIdx, UWORD startRow)
{
    LayoutCtx *ctxView;
    LONG wildcardIdx = -1;
    LONG keepMarkers = 1;
    UWORD row = 0;
    UWORD rowSpan = 0;

    if (!ctx) {
        NEWGRID_GridEntriesWorkflowState = 4;
        return NEWGRID_GridEntriesWorkflowState;
    }

    ctxView = (LayoutCtx *)ctx;

    if (NEWGRID_GridEntriesWorkflowState == 5) {
        NEWGRID_DrawGridHeaderRows(ctx, NEWGRID_HeaderFramePenId, NEWGRID_SelectionMarkerPenState);
        ctxView->currentVisibleLines = -1;
        if (NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() != 0) {
            NEWGRID_GridEntriesWorkflowState = 4;
        }
        return NEWGRID_GridEntriesWorkflowState;
    }

    if (NEWGRID_GridEntriesWorkflowState != 4) {
        NEWGRID_GridEntriesWorkflowState = 4;
        return NEWGRID_GridEntriesWorkflowState;
    }

    if ((startRow > 44 || startRow == 1 || (ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0)) {
        wildcardIdx = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(
            TEXTDISP_PrimaryTitlePtrTable[titleIdx]);
    }

    NEWGRID_SelectedGridEntryPtr = NEWGRID_SelectEntryPen(TEXTDISP_PrimaryEntryPtrTable[titleIdx]);
    NEWGRID_HeaderFramePenId = (NEWGRID_GridOperationId == 5) ? GCOMMAND_NicheFramePen : 7;
    NEWGRID_DrawGridFrame(ctx, 7, NEWGRID_HeaderFramePenId, NEWGRID_SelectedGridEntryPtr, (LONG)NEWGRID_RowHeightPx + 3);

    while (row < 3) {
        const NEWGRID_Entry *entry = 0;
        const NEWGRID_AuxData *aux = 0;
        LONG state = 0;
        LONG leftState = 0;
        LONG rightState = 0;
        UWORD nextSpan = 1;
        LONG rowIdx = (LONG)startRow + (LONG)row;
        LONG mode = (rowIdx > 48 || startRow == 1 || (ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0) ? 2 : 1;
        LONG modeIdx = (mode == 2 && rowIdx > 48) ? (rowIdx - 48) : rowIdx;

        entry = (const NEWGRID_Entry *)ESQDISP_GetEntryPointerByMode((mode == 2) ? wildcardIdx : titleIdx, mode);
        aux = (const NEWGRID_AuxData *)ESQDISP_GetEntryAuxPointerByMode((mode == 2) ? wildcardIdx : titleIdx, mode);

        if (entry && aux) {
            const char *entryText = (const char *)entry;
            const char *auxText = (const char *)aux;
            state = NEWGRID_GetEntryStateCode(entry, aux, modeIdx);
            nextSpan = 1;
            while ((LONG)row + (LONG)nextSpan < 3) {
                if (!NEWGRID_TestEntryState(state, titleIdx, wildcardIdx, modeIdx + nextSpan)) break;
                nextSpan++;
            }

            if (state == 3) {
                LONG prev = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entryText, auxText, modeIdx);
                state = (prev == 0) ? 1 : 2;
            }

            leftState = (state == 2) ? 2 : 0;
            rightState = ((LONG)row + (LONG)nextSpan == 3) ? 1 : 0;

            NEWGRID_RowLayoutCommitPenId = NEWGRID_OverridePenIndex;
            NEWGRID_SelectionMarkerPenState = (aux->rowFlags[modeIdx] & 0x04) ? 5 : -1;

            if (nextSpan == 3 && CONFIG_NewgridPlaceholderBevelFlag == 'Y') {
                NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams((NEWGRID_ColumnWidthPx * nextSpan) - 12, 20, NEWGRID_RowLayoutCommitPenId);
            } else {
                NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams((NEWGRID_ColumnWidthPx * nextSpan) - 12, 2, NEWGRID_RowLayoutCommitPenId);
            }

            ((LONG (*)(char *, LONG, LONG))NEWGRID2_JMPTBL_DISPTEXT_ComputeMarkerWidths)(
                ctxView->scratch, leftState, rightState);
            NEWGRID_DrawEntryRowOrPlaceholder(ctxView->scratch, (char *)entry, (LONG)aux, modeIdx, nextSpan, state);
        } else {
            nextSpan = (UWORD)(3 - row);
            if (nextSpan < 3) {
                NEWGRID_SelectionMarkerPenState = -1;
                NEWGRID_RowLayoutCommitPenId = 1;
                NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams((NEWGRID_ColumnWidthPx * nextSpan) - 12, 2, 1);
                NEWGRID_DrawEntryRowOrPlaceholder(ctxView->scratch, (char *)entry, (LONG)aux, modeIdx, nextSpan, 1);
            } else {
                keepMarkers = 0;
            }
        }

        if (keepMarkers) {
            NEWGRID_DrawSelectionMarkers(ctx, row, nextSpan, NEWGRID_SelectionMarkerPenState, leftState, rightState);
        }
        row = (UWORD)(row + nextSpan);
        rowSpan = nextSpan;
    }

    if (keepMarkers) {
        if (rowSpan == 3 && CONFIG_NewgridPlaceholderBevelFlag == 'Y' && NEWGRID2_JMPTBL_DISPTEXT_IsCurrentLineLast() == 0) {
            NEWGRID_DrawGridCell(ctxView->scratch, (char *)NEWGRID_SelectedGridEntryPtr, 0);
            NEWGRID_GridEntriesWorkflowState = 5;
            if (NEWGRID_SelectionMarkerPenState == -1) {
                NEWGRID_SelectionMarkerPenState = NEWGRID_SelectedGridEntryPtr;
            }
        } else {
            NEWGRID_DrawGridCell(ctxView->scratch, (char *)NEWGRID_SelectedGridEntryPtr, 1);
            NEWGRID_GridEntriesWorkflowState = 4;
        }

        ctxView->currentHalfHeight = (UWORD)(NEWGRID_RowHeightPx >> 1);
        ctxView->currentVisibleLines = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
    } else {
        ctxView->currentHalfHeight = 0;
        NEWGRID_GridEntriesWorkflowState = 4;
    }

    return NEWGRID_GridEntriesWorkflowState;
}
