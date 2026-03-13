typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct SelCtx {
    void *entry;
    void *aux;
    LONG index;
    LONG start;
    LONG end;
    UWORD selectedRow;
    UWORD row;
    UWORD rowLimit;
} SelCtx;

typedef struct NEWGRID_Entry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
} NEWGRID_Entry;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
    const char *payloadTable[49];
} NEWGRID_AuxData;

extern LONG NEWGRID_AltSelectionRowCursor;
extern UWORD NEWGRID_AltSelectionEntryCursor;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern LONG CONFIG_TimeWindowMinutes;

extern void NEWGRID_ClearMarkersIfSelectable(LONG mode, LONG row);
extern short NEWGRID_UpdatePresetEntry(char **entryPtr, char **auxPtr, LONG row, LONG col);
extern LONG NEWGRID_TestEntrySelectable(const void *entry, const void *aux, LONG mode);
extern LONG DISPLIB_FindPreviousValidEntryIndex(const char *entry, const char *aux, LONG idx);
extern LONG ESQ_TestBit1Based(const UBYTE *bitset, LONG idx);
extern LONG COI_ProcessEntrySelectionState(const void *entry, const void *aux, LONG idx, LONG day, LONG window);
extern LONG TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(const void *aux, LONG idx);

LONG NEWGRID_UpdateSelectionFromInputAlt(LONG state, SelCtx *ctx, LONG mode)
{
    LONG found = 0;
    LONG matched;
    LONG idx = 0;
    char *entry = 0;
    char *aux = 0;

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

scan_loop:
    if (found != 0) {
        goto finalize_selection;
    }

    if (NEWGRID_AltSelectionRowCursor >= TEXTDISP_PrimaryGroupEntryCount) {
        goto finalize_selection;
    }

    if (TEXTDISP_PrimaryGroupPresentFlag == 0) {
        goto finalize_selection;
    }

    if (state == 5) {
        goto finalize_selection;
    }

    NEWGRID_UpdatePresetEntry(&entry, &aux, (LONG)NEWGRID_AltSelectionEntryCursor,
        NEWGRID_AltSelectionRowCursor);
    if (NEWGRID_TestEntrySelectable(entry, aux, mode) != 0) {
entry_loop:
        if (found != 0) {
            goto scan_reset;
        }

        matched = 0;
        idx = (LONG)NEWGRID_AltSelectionEntryCursor;
        if (idx > 0 && idx < (LONG)ctx->rowLimit) {
            if (idx == 49) {
                idx = NEWGRID_UpdatePresetEntry(&entry, &aux, idx, NEWGRID_AltSelectionRowCursor);
            } else if (idx > 48) {
                idx -= 48;
            }

            if (entry != 0 && aux != 0) {
                if (NEWGRID_AltSelectionEntryCursor == ctx->row) {
                    idx = DISPLIB_FindPreviousValidEntryIndex(entry, aux, idx);
                }

                if (idx > 0) {
                    if (ESQ_TestBit1Based(
                            ((NEWGRID_Entry *)entry)->selectionBits,
                            idx) == -1) {
                        if ((((NEWGRID_AuxData *)aux)->rowFlags[idx] & 0x20) == 0) {
                            if ((((NEWGRID_AuxData *)aux)->rowFlags[NEWGRID_AltSelectionEntryCursor] & 0x80) == 0) {
                                if (((NEWGRID_AuxData *)aux)->payloadTable[idx] != 0) {
                                    if (COI_ProcessEntrySelectionState(
                                            entry,
                                            aux,
                                            idx,
                                            1440,
                                            CONFIG_TimeWindowMinutes) != 0) {
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
        if (found != 0) {
            goto entry_loop;
        }

        NEWGRID_AltSelectionEntryCursor += 1;
        goto entry_loop;
    }

scan_reset:
    if (found != 0) {
        goto scan_loop;
    }

    if (state == 4) {
        state = 5;
    } else {
        NEWGRID_AltSelectionEntryCursor = ctx->row;
        NEWGRID_AltSelectionRowCursor += 1;
    }

    goto scan_loop;

finalize_selection:
    if (found != 0 && state != 5) {
        ctx->entry = entry;
        ctx->aux = aux;
        ctx->index = NEWGRID_AltSelectionRowCursor;

        if (NEWGRID_AltSelectionEntryCursor > '0' && idx < 49) {
            ctx->selectedRow = (UWORD)(idx + 48);
        } else {
            ctx->selectedRow = (UWORD)idx;
        }

        ((NEWGRID_AuxData *)aux)->rowFlags[idx] |= 0x20;
    }

    if (found == 0) {
        ctx->entry = 0;
        ctx->aux = 0;
    }

    return found;
}
