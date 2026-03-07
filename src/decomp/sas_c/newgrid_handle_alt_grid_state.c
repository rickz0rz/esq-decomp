typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_AltGridStateLatch;
extern LONG CLOCK_DaySlotIndex;
extern WORD NEWGRID_ColumnWidthPx;
extern WORD NEWGRID_ShowtimeEntryVariantFlag;

extern UBYTE *NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern UBYTE *NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern WORD NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(LONG *slot);
extern LONG NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(UBYTE *pattern);
extern void NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams();
extern void NEWGRID_DrawGridEntry();
extern LONG NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount();
extern LONG NEWGRID_DrawGridFrameAlt(UBYTE *ctx);
extern void NEWGRID_DrawGridCell();

LONG NEWGRID_HandleAltGridState(UBYTE *ctx, LONG keyIndex, WORD rowIndex)
{
    UBYTE *entry;
    UBYTE *aux;
    UBYTE *payload;
    LONG state;
    LONG drawFlag;

    if (ctx == 0) {
        NEWGRID_AltGridStateLatch = 4;
        return NEWGRID_AltGridStateLatch;
    }

    if (NEWGRID_AltGridStateLatch == 4) {
        entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(keyIndex, 1);
        aux = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(keyIndex, 1);

        if (aux != 0) {
            if (rowIndex == 1 || (WORD)(NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) == 0) {
                keyIndex = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(aux);
                entry = NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(keyIndex, 2);
                aux = NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(keyIndex, 2);
            }
        }

        if (entry == 0 || aux == 0) {
            return NEWGRID_AltGridStateLatch;
        }

        payload = *(UBYTE **)(aux + 56 + (((LONG)rowIndex) << 2));
        if (payload == 0 || payload[0] == 0) {
            return NEWGRID_AltGridStateLatch;
        }

        NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams((LONG)NEWGRID_ColumnWidthPx * 3 - 12, 20, 1);

        if (NEWGRID_ShowtimeEntryVariantFlag != 0) {
            NEWGRID_DrawGridEntry(ctx + 60, entry, aux, (LONG)rowIndex, 2, 1, 4);
        } else {
            NEWGRID_DrawGridEntry(ctx + 60, entry, aux, (LONG)rowIndex, 3, 1, 4);
        }

        *(LONG *)(ctx + 32) = NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(2);
        if (NEWGRID_DrawGridFrameAlt(ctx) != 0) {
            state = 4;
        } else {
            state = 5;
        }

        NEWGRID_AltGridStateLatch = state;
        drawFlag = (state == 4) ? 1 : 0;
        NEWGRID_DrawGridCell(ctx + 60, entry, drawFlag);
        return NEWGRID_AltGridStateLatch;
    }

    if (NEWGRID_AltGridStateLatch == 5) {
        *(LONG *)(ctx + 32) = -1;
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
