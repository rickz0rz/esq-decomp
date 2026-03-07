typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct SelCtx {
    void *entry;
    void *aux;
    LONG index;
    LONG start;
    LONG end;
    UWORD row;
    UWORD rowLimit;
} SelCtx;

extern LONG NEWGRID_SelectionScanEntryIndex;
extern UWORD NEWGRID_SelectionScanRow;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern LONG GCOMMAND_PpvSelectionToleranceMinutes;
extern LONG GCOMMAND_PpvSelectionWindowMinutes;

extern LONG NEWGRID_ClearEntryMarkerBits(LONG row);
extern LONG NEWGRID_UpdatePresetEntry(void **entryPtr, void **auxPtr, LONG row, LONG col);
extern LONG NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(void *entry, void *aux, LONG idx);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(void *bitset, LONG idx);
extern LONG NEWGRID_ShouldOpenEditor(void *entry);
extern LONG NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(void *entry, void *aux, LONG idx, LONG win, LONG tol);
extern LONG NEWGRID_InitSelectionWindow(SelCtx *ctx, LONG rowBase);

LONG NEWGRID_UpdateSelectionFromInput(LONG state, SelCtx *ctx)
{
    LONG found = 0;
    LONG col = 0;
    LONG idx = 0;
    void *entry = 0;
    void *aux = 0;

    if (state == 0) {
        NEWGRID_SelectionScanEntryIndex = ctx->start;
        NEWGRID_SelectionScanRow = ctx->row;
        NEWGRID_ClearEntryMarkerBits(NEWGRID_SelectionScanRow);
    } else if (state == 4) {
        NEWGRID_SelectionScanEntryIndex += 1;
    } else {
        found = 1;
    }

    if (!found) {
        if (ctx->start < 0 || ctx->start > TEXTDISP_PrimaryGroupEntryCount) {
            ctx->start = (LONG)TEXTDISP_PrimaryGroupEntryCount;
        }
        if (ctx->end < 0 || ctx->end > TEXTDISP_PrimaryGroupEntryCount) {
            ctx->end = (LONG)TEXTDISP_PrimaryGroupEntryCount;
        }

        while (!found) {
            if (NEWGRID_SelectionScanRow <= 0 || NEWGRID_SelectionScanRow >= ctx->rowLimit) break;
            if (NEWGRID_SelectionScanEntryIndex >= ctx->end) {
                NEWGRID_SelectionScanRow += 1;
                NEWGRID_SelectionScanEntryIndex = ctx->start;
                continue;
            }
            if (!TEXTDISP_PrimaryGroupPresentFlag) {
                NEWGRID_SelectionScanRow += 1;
                NEWGRID_SelectionScanEntryIndex = ctx->start;
                continue;
            }

            col = NEWGRID_SelectionScanEntryIndex;
            idx = NEWGRID_UpdatePresetEntry(&entry, &aux, NEWGRID_SelectionScanRow, col);
            if (!entry || !aux) {
                NEWGRID_SelectionScanEntryIndex += 1;
                continue;
            }

            if ((((UBYTE *)entry)[46] & 0x10) == 0 || ((((UBYTE *)entry)[40] & 0x80) == 0)) {
                NEWGRID_SelectionScanEntryIndex += 1;
                continue;
            }

            if (NEWGRID_SelectionScanRow == ctx->row) {
                idx = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, aux, idx);
            }
            if (idx <= 0) {
                NEWGRID_SelectionScanEntryIndex += 1;
                continue;
            }

            if (NEWGRID2_JMPTBL_ESQ_TestBit1Based((UBYTE *)entry + 0x1c, idx) != -1) {
                NEWGRID_SelectionScanEntryIndex += 1;
                continue;
            }
            if (((UBYTE *)aux)[7 + idx] & 0x20) {
                NEWGRID_SelectionScanEntryIndex += 1;
                continue;
            }

            if (NEWGRID_ShouldOpenEditor(entry) != 0) {
                found = ((NEWGRID_SelectionScanRow == ctx->row) && (((LONG *)aux)[14 + idx] != 0)) ? 1 : 0;
            } else {
                if ((((LONG *)aux)[14 + idx] != 0) && ((((UBYTE *)aux)[7 + NEWGRID_SelectionScanRow] & 0x80) == 0)) {
                    found = NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(
                        entry, aux, idx, GCOMMAND_PpvSelectionWindowMinutes, GCOMMAND_PpvSelectionToleranceMinutes) != 0;
                } else {
                    found = 0;
                }
            }

            if (!found) NEWGRID_SelectionScanEntryIndex += 1;
        }
    }

    if (found) {
        ctx->entry = entry;
        ctx->aux = aux;
        ctx->index = NEWGRID_SelectionScanEntryIndex;

        if (NEWGRID_SelectionScanRow > '0' && idx < 49) {
            ctx->row = (UWORD)(idx + 48);
        } else {
            ctx->row = (UWORD)idx;
        }
        ((UBYTE *)aux)[7 + idx] |= 0x20;
    } else {
        NEWGRID_InitSelectionWindow(ctx, 0);
    }

    return found;
}
