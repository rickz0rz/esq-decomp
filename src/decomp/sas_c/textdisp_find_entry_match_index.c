#include <exec/types.h>
typedef struct TEXTDISP_AuxData {
    UBYTE pad0[7];
    UBYTE slotMask[49];
    UBYTE pad1[0x38 - 0x38];
    const char *titlePtrBySlot[49];
} TEXTDISP_AuxData;

typedef struct TEXTDISP_CandidateEntry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
} TEXTDISP_CandidateEntry;

extern UWORD TEXTDISP_ActiveGroupId;
extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD CLOCK_HalfHourSlotIndex;

extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG DISPLIB_FindPreviousValidEntryIndex(const char *entryPtr, const char *auxPtr, LONG startIndex);
extern const char *TEXTDISP_FindControlToken(const char *textPtr);
extern LONG TEXTDISP_FindQuotedSpan(const char *src, char **outStart, const char *endHint, LONG *hasQuotes);
extern LONG ESQ_TestBit1Based(const UBYTE *bitsetPtr, LONG index);
extern LONG STRING_CompareNoCase(const char *a, const char *b);
extern LONG ESQ_FindSubstringCaseFold(const char *haystack, const char *needle);

LONG TEXTDISP_FindEntryMatchIndex(char *input, LONG mode, LONG flags)
{
    const LONG GROUP_PRIMARY = 1;
    const LONG GROUP_SECONDARY = 2;
    const LONG MODE_PREV = 1;
    const LONG MODE_NEXT = 2;
    const LONG MODE_PREV_BEFORE = 3;
    const LONG SLOT_FIRST = 1;
    const LONG SLOT_MAX = 49;
    const LONG SLOT_NONE = 0;
    const UBYTE MASK_SLOT_BLOCKED = 0x80u;
    const LONG BIT_TEST_TRUE = -1;
    const UBYTE CH_NUL = 0;
    const LONG MATCH_TRUE = -1;
    const TEXTDISP_AuxData *aux;
    const TEXTDISP_CandidateEntry *entry;
    const char *inputCtrl;
    char *inputStart;
    const char *entryTitle;
    const char *entryCtrl;
    char *entryStart;
    LONG inputHasQuotes;
    LONG entryHasQuotes;
    LONG inputLen;
    LONG entryLen;
    LONG slot;
    LONG tokenOk;
    LONG isMatch;
    char inputSaved;
    char entrySaved;
    UBYTE mask;

    mask = (UBYTE)flags;

    inputStart = 0;
    entryStart = 0;
    inputHasQuotes = 0;
    entryHasQuotes = 0;

    if (input[0] == CH_NUL) {
        return SLOT_MAX;
    }

    if (TEXTDISP_ActiveGroupId == GROUP_PRIMARY) {
        slot = (LONG)CLOCK_HalfHourSlotIndex;
        aux = (const TEXTDISP_AuxData *)ESQDISP_GetEntryAuxPointerByMode(
            (LONG)TEXTDISP_CurrentMatchIndex, GROUP_PRIMARY);
        entry = (const TEXTDISP_CandidateEntry *)ESQDISP_GetEntryPointerByMode(
            (LONG)TEXTDISP_CurrentMatchIndex, GROUP_PRIMARY);
    } else {
        slot = SLOT_FIRST;
        aux = (const TEXTDISP_AuxData *)ESQDISP_GetEntryAuxPointerByMode(
            (LONG)TEXTDISP_CurrentMatchIndex, GROUP_SECONDARY);
        entry = (const TEXTDISP_CandidateEntry *)ESQDISP_GetEntryPointerByMode(
            (LONG)TEXTDISP_CurrentMatchIndex, GROUP_SECONDARY);
    }

    if ((UWORD)mode == MODE_NEXT) {
        if (TEXTDISP_ActiveGroupId == GROUP_PRIMARY) {
            slot = (LONG)CLOCK_HalfHourSlotIndex + 1;
        } else {
            slot = SLOT_FIRST;
        }
    } else if ((UWORD)mode == MODE_PREV) {
        {
            const char *entryText = (const char *)entry;
            const char *auxText = (const char *)aux;
            slot = DISPLIB_FindPreviousValidEntryIndex(entryText, auxText, slot);
        }
        if (slot == SLOT_NONE || (aux->slotMask[(UWORD)slot] & MASK_SLOT_BLOCKED) != 0) {
            if (TEXTDISP_ActiveGroupId == GROUP_PRIMARY) {
                slot = (LONG)CLOCK_HalfHourSlotIndex;
            } else {
                slot = SLOT_FIRST;
            }
        }
    } else if ((UWORD)mode == MODE_PREV_BEFORE) {
        {
            const char *entryText = (const char *)entry;
            const char *auxText = (const char *)aux;
            slot = DISPLIB_FindPreviousValidEntryIndex(entryText, auxText, slot - 1);
        }
        if (slot == SLOT_NONE || (aux->slotMask[(UWORD)slot] & MASK_SLOT_BLOCKED) != 0) {
            if (TEXTDISP_ActiveGroupId == GROUP_PRIMARY) {
                slot = (LONG)CLOCK_HalfHourSlotIndex;
            } else {
                slot = SLOT_FIRST;
            }
        }
    } else {
        slot = SLOT_FIRST;
    }

    inputCtrl = TEXTDISP_FindControlToken(input);
    inputLen = TEXTDISP_FindQuotedSpan(input, &inputStart, inputCtrl, &inputHasQuotes);
    inputSaved = inputStart[inputLen];
    inputStart[inputLen] = CH_NUL;

    while (slot < SLOT_MAX) {
        if (aux->titlePtrBySlot[(UWORD)slot] == 0) {
            slot++;
            continue;
        }

        if ((aux->slotMask[(UWORD)slot] & mask) != mask) {
            slot++;
            continue;
        }

        if (ESQ_TestBit1Based((void *)entry->selectionBits, slot) != BIT_TEST_TRUE) {
            slot++;
            continue;
        }

        entryTitle = aux->titlePtrBySlot[(UWORD)slot];
        entryCtrl = TEXTDISP_FindControlToken(entryTitle);

        tokenOk = 0;
        if (inputCtrl == 0) {
            tokenOk = GROUP_PRIMARY;
        } else if (entryCtrl != 0 && entryCtrl[0] == inputCtrl[0]) {
            tokenOk = GROUP_PRIMARY;
        }

        isMatch = 0;
        if (tokenOk != 0) {
            entryLen = TEXTDISP_FindQuotedSpan(entryTitle, &entryStart, entryCtrl, &entryHasQuotes);
            entrySaved = entryStart[entryLen];
            entryStart[entryLen] = CH_NUL;

            if (inputHasQuotes != 0) {
                if (entryHasQuotes != 0 && inputLen == entryLen &&
                    STRING_CompareNoCase(inputStart, entryStart) == 0) {
                    isMatch = MATCH_TRUE;
                }
            } else {
                if (inputLen <= entryLen &&
                    ESQ_FindSubstringCaseFold(entryStart, inputStart) != 0) {
                    isMatch = MATCH_TRUE;
                }
            }

            entryStart[entryLen] = entrySaved;
        }

        if (isMatch != 0 && tokenOk != 0) {
            inputStart[inputLen] = inputSaved;
            return slot;
        }

        slot++;
    }

    inputStart[inputLen] = inputSaved;
    return slot;
}
