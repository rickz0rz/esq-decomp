typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern WORD NEWGRID_UpdatePresetEntry(UBYTE **outEntry, UBYTE **outAux, LONG selector, LONG index);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(UBYTE *bitset, LONG bitIndex);
extern LONG NEWGRID_ShouldOpenEditor(UBYTE *entry);

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
        UBYTE *entry;
        UBYTE *aux;

        if (idx >= (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount) {
            break;
        }

        entry = 0;
        aux = 0;
        (void)NEWGRID_UpdatePresetEntry(&entry, &aux, (LONG)selector, idx);

        if (entry == 0 || aux == 0) {
            ++idx;
            continue;
        }
        if ((*(UWORD *)(entry + 46) & (UWORD)0x0002) == 0) {
            ++idx;
            continue;
        }
        if ((entry[40] & 0x80) == 0) {
            ++idx;
            continue;
        }
        if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry + 28, (LONG)selector) + 1 != 0) {
            ++idx;
            continue;
        }
        if (NEWGRID_ShouldOpenEditor(entry) != 0) {
            ++idx;
            continue;
        }

        if ((aux[(LONG)selector + 7] & 0x02) == 0) {
            if ((entry[27] & 0x10) == 0) {
                ++idx;
                continue;
            }
        }

        if ((aux[(LONG)selector + 7] & 0x80) != 0) {
            ++idx;
            continue;
        }
        if (*(LONG *)(aux + 56 + (((LONG)selector) << 2)) == 0) {
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
