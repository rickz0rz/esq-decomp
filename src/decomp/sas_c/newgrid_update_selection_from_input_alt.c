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

extern LONG NEWGRID_AltSelectionRowCursor;
extern UWORD NEWGRID_AltSelectionEntryCursor;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern LONG CONFIG_TimeWindowMinutes;

extern LONG NEWGRID_ClearMarkersIfSelectable(LONG mode, LONG row);
extern LONG NEWGRID_UpdatePresetEntry(void **entryPtr, void **auxPtr, LONG row, LONG col);
extern LONG NEWGRID_TestEntrySelectable(void *entry, void *aux, LONG mode);
extern LONG NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(void *entry, void *aux, LONG idx);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(void *bitset, LONG idx);
extern LONG NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(void *entry, void *aux, LONG idx, LONG day, LONG window);
extern LONG TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(void *aux, LONG idx);

LONG NEWGRID_UpdateSelectionFromInputAlt(LONG state, SelCtx *ctx, LONG mode)
{
    LONG found = 0;
    LONG matched = 0;
    LONG idx = 0;
    LONG row = 0;
    void *entry = 0;
    void *aux = 0;

    switch (state) {
    case 0:
        NEWGRID_AltSelectionRowCursor = 0;
        NEWGRID_AltSelectionEntryCursor = ctx->row;
        NEWGRID_ClearMarkersIfSelectable(mode, (LONG)NEWGRID_AltSelectionEntryCursor);
        break;
    case 1:
        NEWGRID_AltSelectionRowCursor += 1;
        NEWGRID_AltSelectionEntryCursor = ctx->row;
        break;
    case 4:
        NEWGRID_AltSelectionEntryCursor = (UWORD)(NEWGRID_AltSelectionEntryCursor + 1);
        break;
    case 3:
    case 5:
        found = 1;
        break;
    default:
        state = 5;
        break;
    }

    while (!found) {
        if (NEWGRID_AltSelectionRowCursor >= TEXTDISP_PrimaryGroupEntryCount) break;
        if (!TEXTDISP_PrimaryGroupPresentFlag || state == 5) break;

        row = NEWGRID_AltSelectionEntryCursor;
        NEWGRID_UpdatePresetEntry(&entry, &aux, row, NEWGRID_AltSelectionRowCursor);
        if (NEWGRID_TestEntrySelectable(entry, aux, mode)) {
            matched = 0;
            idx = NEWGRID_AltSelectionEntryCursor;
            if (idx > 0 && idx < ctx->rowLimit) {
                if (idx == 49) {
                    idx = NEWGRID_UpdatePresetEntry(&entry, &aux, idx, NEWGRID_AltSelectionRowCursor);
                } else if (idx > 48) {
                    idx -= 48;
                }

                if (entry && aux) {
                    if (NEWGRID_AltSelectionEntryCursor == ctx->row) {
                        idx = NEWGRID2_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, aux, idx);
                    }
                    if (idx > 0) {
                        if (NEWGRID2_JMPTBL_ESQ_TestBit1Based((UBYTE *)entry + 0x1c, idx) == -1) {
                            if ((((UBYTE *)aux)[7 + idx] & 0x20) == 0) {
                                if ((((UBYTE *)aux)[7 + NEWGRID_AltSelectionEntryCursor] & 0x80) == 0) {
                                    if (((LONG *)aux)[14 + idx] != 0) {
                                        if (NEWGRID2_JMPTBL_COI_ProcessEntrySelectionState(
                                                entry, aux, idx, 1440, CONFIG_TimeWindowMinutes) != 0) {
                                            if (mode != 1 ||
                                                TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(aux, idx) != 0) {
                                                matched = 1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            found = matched;
        }

        if (!found) {
            NEWGRID_AltSelectionEntryCursor = (UWORD)(NEWGRID_AltSelectionEntryCursor + 1);
            if (state == 4) {
                state = 5;
            } else {
                NEWGRID_AltSelectionEntryCursor = ctx->row;
                NEWGRID_AltSelectionRowCursor += 1;
            }
        } else {
            break;
        }
    }

    if (found && state != 5) {
        ctx->entry = entry;
        ctx->aux = aux;
        ctx->index = NEWGRID_AltSelectionRowCursor;
        if (NEWGRID_AltSelectionEntryCursor > '0' && idx < 49) {
            ctx->row = (UWORD)(idx + 48);
        } else {
            ctx->row = (UWORD)idx;
        }
        ((UBYTE *)aux)[7 + idx] |= 0x20;
    } else if (!found) {
        ctx->entry = 0;
        ctx->aux = 0;
    }

    return found;
}
