typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;

extern WORD NEWGRID_UpdatePresetEntry(UBYTE **outEntry, UBYTE **outAux, LONG selector, LONG index);
extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(UBYTE *bitset, LONG bitIndex);

LONG NEWGRID_FindNextEntryWithAltMarkers(LONG scanMode, LONG startIndex, WORD selector)
{
    LONG idx;
    LONG found;

    idx = startIndex;
    found = 0;

    if (scanMode == 0 || scanMode == 6) {
        idx = 0;
    } else if (scanMode == 4) {
        idx = idx + 1;
    } else {
        found = 1;
    }

    if (found != 0) {
        return idx;
    }

    while (found == 0) {
        UBYTE *entry;
        UBYTE *aux;
        WORD presetIndex;

        if (idx >= (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount) {
            break;
        }
        if (TEXTDISP_PrimaryGroupPresentFlag == 0) {
            break;
        }

        entry = 0;
        aux = 0;
        presetIndex = NEWGRID_UpdatePresetEntry(&entry, &aux, (LONG)selector, idx);

        if (entry == 0 || aux == 0) {
            ++idx;
            continue;
        }

        if ((*(UWORD *)(entry + 46) & (UWORD)0x0008) == 0) {
            ++idx;
            continue;
        }
        if ((entry[40] & 0x80) == 0) {
            ++idx;
            continue;
        }
        if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry + 28, (LONG)presetIndex) + 1 != 0) {
            ++idx;
            continue;
        }
        if ((aux[(LONG)selector + 7] & 0x80) != 0) {
            ++idx;
            continue;
        }
        if (*(LONG *)(aux + 56 + (((LONG)presetIndex) << 2)) == 0) {
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
