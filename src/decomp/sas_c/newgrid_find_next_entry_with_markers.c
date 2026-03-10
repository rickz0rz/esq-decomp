typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[27];
    UBYTE flags27;
    UBYTE selectionBits[12];
    UBYTE flags40;
    UBYTE pad1[5];
    UWORD markerFlags46;
} NEWGRID_Entry;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
    UBYTE pad1[0x38 - 0x38];
    const char *titleTable[49];
} NEWGRID_AuxData;

extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern void NEWGRID_UpdatePresetEntry(char **outEntry, char **outAux, LONG selector, LONG index);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(const UBYTE *bitset, LONG bitIndex);
extern LONG NEWGRID_ShouldOpenEditor(const NEWGRID_Entry *entry);

LONG NEWGRID_FindNextEntryWithMarkers(LONG scanMode, LONG startIndex, WORD selector)
{
    LONG idx;
    LONG found;

    idx = startIndex;
    found = 0;

    if (scanMode == 0) {
        idx = 0;
    } else if (scanMode == 4) {
        idx = idx + 1;
    } else {
        found = 1;
    }

    if (found != 0) {
        return idx;
    }
    if (TEXTDISP_PrimaryGroupPresentFlag == 0) {
        return idx;
    }

    while (found == 0) {
        const NEWGRID_Entry *entry;
        const NEWGRID_AuxData *aux;

        if (idx >= (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount) {
            break;
        }

        entry = 0;
        aux = 0;
        (void)NEWGRID_UpdatePresetEntry((char **)&entry, (char **)&aux, (LONG)selector, idx);

        if (entry == 0 || aux == 0) {
            ++idx;
            continue;
        }
        if ((entry->markerFlags46 & (UWORD)0x0002) == 0) {
            ++idx;
            continue;
        }
        if ((entry->flags40 & 0x80) == 0) {
            ++idx;
            continue;
        }
        if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry->selectionBits, (LONG)selector) + 1 != 0) {
            ++idx;
            continue;
        }
        if (NEWGRID_ShouldOpenEditor(entry) != 0) {
            ++idx;
            continue;
        }

        if ((aux->rowFlags[(LONG)selector] & 0x02) == 0) {
            if ((entry->flags27 & 0x10) == 0) {
                ++idx;
                continue;
            }
        }

        if ((aux->rowFlags[(LONG)selector] & 0x80) != 0) {
            ++idx;
            continue;
        }
        if (aux->titleTable[(LONG)selector] == 0) {
            ++idx;
            continue;
        }

        found = 1;
    }

    if (found == 0) {
        idx = -1;
    }

    return idx;
}
