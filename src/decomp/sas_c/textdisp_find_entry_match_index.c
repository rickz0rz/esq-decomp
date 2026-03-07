typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TextdispAux {
    UBYTE pad0[7];
    UBYTE slotMask[49];
    UBYTE pad1[0x38 - 0x38];
    UBYTE *titlePtrBySlot[49];
} TextdispAux;

extern UWORD TEXTDISP_ActiveGroupId;
extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD CLOCK_HalfHourSlotIndex;

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern UBYTE *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(void *entryPtr, void *auxPtr, LONG startIndex);
extern UBYTE *TEXTDISP_FindControlToken(UBYTE *textPtr);
extern LONG TEXTDISP_FindQuotedSpan(UBYTE *src, UBYTE **outStart, UBYTE *endHint, LONG *hasQuotes);
extern LONG TLIBA2_JMPTBL_ESQ_TestBit1Based(void *bitsetPtr, LONG index);
extern LONG STRING_CompareNoCase(const char *a, const char *b);
extern LONG TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold(const char *haystack, const char *needle);

LONG TEXTDISP_FindEntryMatchIndex(UBYTE *input, LONG unusedArg, UWORD mode, UBYTE mask)
{
    TextdispAux *aux;
    UBYTE *entry;
    UBYTE *inputCtrl;
    UBYTE *inputStart;
    UBYTE *entryTitle;
    UBYTE *entryCtrl;
    UBYTE *entryStart;
    LONG inputHasQuotes;
    LONG entryHasQuotes;
    LONG inputLen;
    LONG entryLen;
    LONG slot;
    LONG tokenOk;
    LONG isMatch;
    UBYTE inputSaved;
    UBYTE entrySaved;

    (void)unusedArg;

    inputStart = (UBYTE *)0;
    entryStart = (UBYTE *)0;
    inputHasQuotes = 0;
    entryHasQuotes = 0;

    if (input[0] == 0) {
        return 49;
    }

    if (TEXTDISP_ActiveGroupId == 1) {
        slot = (LONG)CLOCK_HalfHourSlotIndex;
        aux = (TextdispAux *)TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode((LONG)TEXTDISP_CurrentMatchIndex, 1);
        entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode((LONG)TEXTDISP_CurrentMatchIndex, 1);
    } else {
        slot = 1;
        aux = (TextdispAux *)TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode((LONG)TEXTDISP_CurrentMatchIndex, 2);
        entry = TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode((LONG)TEXTDISP_CurrentMatchIndex, 2);
    }

    if (mode == 2) {
        if (TEXTDISP_ActiveGroupId == 1) {
            slot = (LONG)CLOCK_HalfHourSlotIndex + 1;
        } else {
            slot = 1;
        }
    } else if (mode == 1) {
        slot = TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, aux, slot);
        if (slot == 0 || (aux->slotMask[(UWORD)slot] & 0x80u) != 0) {
            if (TEXTDISP_ActiveGroupId == 1) {
                slot = (LONG)CLOCK_HalfHourSlotIndex;
            } else {
                slot = 1;
            }
        }
    } else if (mode == 3) {
        slot = TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex(entry, aux, slot - 1);
        if (slot == 0 || (aux->slotMask[(UWORD)slot] & 0x80u) != 0) {
            if (TEXTDISP_ActiveGroupId == 1) {
                slot = (LONG)CLOCK_HalfHourSlotIndex;
            } else {
                slot = 1;
            }
        }
    } else {
        slot = 1;
    }

    inputCtrl = TEXTDISP_FindControlToken(input);
    inputLen = TEXTDISP_FindQuotedSpan(input, &inputStart, inputCtrl, &inputHasQuotes);
    inputSaved = inputStart[inputLen];
    inputStart[inputLen] = 0;

    while (slot < 49) {
        if (aux->titlePtrBySlot[(UWORD)slot] == (UBYTE *)0) {
            slot++;
            continue;
        }

        if ((aux->slotMask[(UWORD)slot] & mask) != mask) {
            slot++;
            continue;
        }

        if (TLIBA2_JMPTBL_ESQ_TestBit1Based((void *)(entry + 28), slot) != -1) {
            slot++;
            continue;
        }

        entryTitle = aux->titlePtrBySlot[(UWORD)slot];
        entryCtrl = TEXTDISP_FindControlToken(entryTitle);

        tokenOk = 0;
        if (inputCtrl == (UBYTE *)0) {
            tokenOk = 1;
        } else if (entryCtrl != (UBYTE *)0 && entryCtrl[0] == inputCtrl[0]) {
            tokenOk = 1;
        }

        isMatch = 0;
        if (tokenOk != 0) {
            entryLen = TEXTDISP_FindQuotedSpan(entryTitle, &entryStart, entryCtrl, &entryHasQuotes);
            entrySaved = entryStart[entryLen];
            entryStart[entryLen] = 0;

            if (inputHasQuotes != 0) {
                if (entryHasQuotes != 0 && inputLen == entryLen &&
                    STRING_CompareNoCase((const char *)inputStart, (const char *)entryStart) == 0) {
                    isMatch = -1;
                }
            } else {
                if (inputLen <= entryLen &&
                    TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold((const char *)entryStart, (const char *)inputStart) != 0) {
                    isMatch = -1;
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
