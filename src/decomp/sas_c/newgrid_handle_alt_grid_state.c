typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[56];
    const char *titleTable[49];
} NEWGRID_AuxData;

typedef struct NEWGRID_Context {
    UBYTE pad0[32];
    LONG selectedState;
    UBYTE pad1[24];
    UBYTE rastPort[1];
} NEWGRID_Context;

extern LONG NEWGRID_AltGridStateLatch;
extern LONG CLOCK_DaySlotIndex;
extern WORD NEWGRID_ColumnWidthPx;
extern WORD NEWGRID_ShowtimeEntryVariantFlag;

extern const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern WORD NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(LONG *slot);
extern LONG NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(const char *pattern);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(LONG width, LONG rowHeight, LONG pen);
extern void NEWGRID_DrawGridEntry(char *rastPort, char *entry, char *aux, UWORD row, UWORD mode, LONG enabled, LONG bevel);
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(LONG mode);
extern LONG NEWGRID_DrawGridFrameAlt(char *ctx);
extern void NEWGRID_DrawGridCell(char *rastPort, char *cell, LONG rowFlag);

LONG NEWGRID_HandleAltGridState(char *ctx, LONG keyIndex, WORD rowIndex)
{
    const char *entry;
    const NEWGRID_AuxData *aux;
    const char *payload;
    NEWGRID_Context *ctxView;
    LONG state;
    LONG drawFlag;

    if (ctx == 0) {
        NEWGRID_AltGridStateLatch = 4;
        return NEWGRID_AltGridStateLatch;
    }

    ctxView = (NEWGRID_Context *)ctx;
    if (NEWGRID_AltGridStateLatch == 4) {
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(keyIndex, 1);
        aux = (const NEWGRID_AuxData *)NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(keyIndex, 1);

        if (aux != 0) {
            if (rowIndex == 1 || (WORD)(NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0) {
                keyIndex = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex((char *)aux);
                entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(keyIndex, 2);
                aux = (const NEWGRID_AuxData *)NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(keyIndex, 2);
            }
        }

        if (entry == 0 || aux == 0) {
            return NEWGRID_AltGridStateLatch;
        }

        payload = aux->titleTable[(LONG)rowIndex];
        if (payload == 0 || payload[0] == 0) {
            return NEWGRID_AltGridStateLatch;
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams((LONG)NEWGRID_ColumnWidthPx * 3 - 12, 20, 1);

        if (NEWGRID_ShowtimeEntryVariantFlag != 0) {
            NEWGRID_DrawGridEntry(ctxView->rastPort, (char *)entry, (char *)aux, (UWORD)rowIndex, 2, 1, 4);
        } else {
            NEWGRID_DrawGridEntry(ctxView->rastPort, (char *)entry, (char *)aux, (UWORD)rowIndex, 3, 1, 4);
        }

        ctxView->selectedState = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
        if (NEWGRID_DrawGridFrameAlt(ctx) != 0) {
            state = 4;
        } else {
            state = 5;
        }

        NEWGRID_AltGridStateLatch = state;
        drawFlag = (state == 4) ? 1 : 0;
        NEWGRID_DrawGridCell(ctxView->rastPort, (char *)entry, drawFlag);
        return NEWGRID_AltGridStateLatch;
    }

    if (NEWGRID_AltGridStateLatch == 5) {
        ctxView->selectedState = -1;
        if (NEWGRID_DrawGridFrameAlt(ctx) != 0) {
            NEWGRID_AltGridStateLatch = 4;
        } else {
            NEWGRID_AltGridStateLatch = 5;
        }
        return NEWGRID_AltGridStateLatch;
    }

    NEWGRID_AltGridStateLatch = 4;
    return NEWGRID_AltGridStateLatch;
}
