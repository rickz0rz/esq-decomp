#include <exec/types.h>
typedef struct NEWGRID_Entry {
    UBYTE pad0[12];
    char titleText[1];
} NEWGRID_Entry;

extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern WORD TEXTDISP_SecondaryGroupEntryCount;
extern const NEWGRID_Entry *TEXTDISP_SecondaryEntryPtrTable[];
extern LONG *NEWGRID_SecondaryIndexCachePtr;
extern LONG CLOCK_DaySlotIndex;

extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern WORD ESQ_GetHalfHourSlotIndex(LONG *clockSlotPtr);
extern LONG NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(const char *pattern);

WORD NEWGRID_UpdatePresetEntry(char **entryOut, char **auxOut, WORD rowIndex, LONG keyIndex)
{
    LONG cacheIndex;
    LONG normalizeFlag;
    const NEWGRID_Entry *entry;
    const NEWGRID_Entry *cachedEntry;
    const char *aux;
    const char *a;
    const char *b;

    normalizeFlag = 0;
    entry = (const NEWGRID_Entry *)*entryOut;
    aux = *auxOut;

    if (rowIndex > 48) {
        rowIndex = (WORD)(rowIndex - 48);
        normalizeFlag = 1;
    }

    entry = (const NEWGRID_Entry *)ESQDISP_GetEntryPointerByMode(keyIndex, 1);
    aux = ESQDISP_GetEntryAuxPointerByMode(keyIndex, 1);
    if (entry == 0 || aux == 0) {
        *entryOut = (char *)entry;
        *auxOut = (char *)aux;
        return rowIndex;
    }

    if (rowIndex != 1) {
        if ((WORD)(ESQ_GetHalfHourSlotIndex(&CLOCK_DaySlotIndex) - 1) != 0) {
            if (normalizeFlag == 0) {
                *entryOut = (char *)entry;
                *auxOut = (char *)aux;
                return rowIndex;
            }
        }
    }

    if (TEXTDISP_SecondaryGroupPresentFlag != 0) {
        if (NEWGRID_SecondaryIndexCachePtr != 0) {
            cacheIndex = NEWGRID_SecondaryIndexCachePtr[keyIndex];
            if (cacheIndex < 0 || cacheIndex >= (LONG)(WORD)TEXTDISP_SecondaryGroupEntryCount) {
                cacheIndex = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(aux);
                NEWGRID_SecondaryIndexCachePtr[keyIndex] = cacheIndex;
            } else {
                a = entry->titleText;
                cachedEntry = TEXTDISP_SecondaryEntryPtrTable[cacheIndex];
                b = cachedEntry->titleText;
                while (*a == *b) {
                    if (*a == 0) {
                        break;
                    }
                    a++;
                    b++;
                }
                if (*a != *b) {
                    cacheIndex = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(aux);
                    NEWGRID_SecondaryIndexCachePtr[keyIndex] = cacheIndex;
                }
            }
        } else {
            cacheIndex = NEWGRID2_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(aux);
        }

        entry = (const NEWGRID_Entry *)ESQDISP_GetEntryPointerByMode(cacheIndex, 2);
        aux = ESQDISP_GetEntryAuxPointerByMode(cacheIndex, 2);
    }

    *entryOut = (char *)entry;
    *auxOut = (char *)aux;
    return rowIndex;
}
