#include <exec/types.h>

typedef struct TEXTDISP_AuxData {
    UBYTE pad0[56];
    const char *titleTable[49];
} TEXTDISP_AuxData;

typedef struct TEXTDISP_SelectionEntry {
    char shortName[10];
    char longName[200];
    LONG mode;
    LONG groupIndex;
    UWORD selectionIndex;
    char detailLine[524];
} TEXTDISP_SelectionEntry;

typedef struct TEXTDISP_CandidateEntry {
    UBYTE pad0[12];
    char tagText[15];
    UBYTE flags27;
    UBYTE selectionBits[1];
} TEXTDISP_CandidateEntry;

extern UWORD TEXTDISP_FilterChannelSlotIndex;
extern UBYTE TEXTDISP_FilterModeId;
extern UWORD TEXTDISP_FilterPpvSbeMatchFlag;
extern UWORD TEXTDISP_FilterSportsMatchFlag;
extern UWORD TEXTDISP_FilterMatchCount;
extern UWORD TEXTDISP_FilterCandidateCursor;
extern UBYTE TEXTDISP_CandidateIndexList[];
extern UWORD CLOCK_HalfHourSlotIndex;
extern LONG CONFIG_TimeWindowMinutes;

extern const char SCRIPT_FilterTag_PPV[];
extern const char SCRIPT_FilterTag_SBE[];
extern const char SCRIPT_FilterTag_SPORTS[];

extern UBYTE ESQ_WildcardMatch(const char *pattern, const char *text);
extern const char *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern const char *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(const void *entry, const void *aux, LONG index, LONG window, LONG minutes);
extern LONG ESQDISP_TestEntryGridEligibility(const UBYTE *entry, UWORD index);
extern LONG ESQ_TestBit1Based(const UBYTE *bits, LONG index);
extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);
extern LONG TEXTDISP_GetGroupEntryCount(LONG mode);
extern LONG TEXTDISP_ShouldOpenEditorForEntry(const TEXTDISP_CandidateEntry *entry);
extern const char *TEXTDISP_SkipControlCodes(const char *text);
extern void TEXTDISP_SetSelectionFields(TEXTDISP_SelectionEntry *entry, LONG mode, LONG displayIndex, LONG entryIndex);
extern void TEXTDISP_BuildEntryDetailLine(TEXTDISP_SelectionEntry *entry);
extern void TEXTDISP_ResetSelectionState(TEXTDISP_SelectionEntry *entry);

#define TEXTDISP_FILTER_MODE_NONE      0
#define TEXTDISP_FILTER_MODE_FILTER    'F'
#define TEXTDISP_FILTER_MODE_EXACT     'X'
#define TEXTDISP_FILTER_PRIMARY        1
#define TEXTDISP_FILTER_SECONDARY      2
#define TEXTDISP_FILTER_DONE           3
#define TEXTDISP_FILTER_SLOT_FIRST     1
#define TEXTDISP_FILTER_SLOT_LAST      48
#define TEXTDISP_FILTER_SLOT_SENTINEL  49
#define TEXTDISP_FILTER_DAY_MINUTES    1440
#define TEXTDISP_FLAG_HIDDEN_BIT       3
#define TEXTDISP_FLAG_PPV_SBE_BIT      4

LONG TEXTDISP_FilterAndSelectEntry(TEXTDISP_SelectionEntry *entryPtr, UBYTE modeChar)
{
    TEXTDISP_SelectionEntry *entry;
    const char *nameShort;
    const char *nameLong;
    const char *candidateTitle;
    const TEXTDISP_AuxData *aux;
    const TEXTDISP_CandidateEntry *candidate;
    LONG found;
    LONG mode;
    LONG count;
    LONG idx;
    LONG slot;
    LONG titleSlot;
    LONG ppvSbe;
    LONG nameLen;
    const char *nameEnd;

    found = 0;
    entry = entryPtr;
    if (entry == 0) {
        modeChar = TEXTDISP_FILTER_MODE_NONE;
    }

    nameShort = 0;
    nameLong = 0;
    if (entry != 0) {
        nameShort = entry->shortName;
        nameLong = entry->longName;
        if (nameShort[0] == 0 || nameLong[0] == 0) {
            modeChar = TEXTDISP_FILTER_MODE_NONE;
        }
    }

    if (modeChar == TEXTDISP_FILTER_MODE_FILTER) {
        TEXTDISP_FilterChannelSlotIndex = 0;
        TEXTDISP_FilterModeId = TEXTDISP_FILTER_PRIMARY;

        ppvSbe = 1;
        if (ESQ_WildcardMatch(SCRIPT_FilterTag_PPV, nameShort) != 0 &&
            ESQ_WildcardMatch(SCRIPT_FilterTag_SBE, nameShort) != 0) {
            ppvSbe = 0;
        }
        TEXTDISP_FilterPpvSbeMatchFlag = (UWORD)ppvSbe;
        TEXTDISP_FilterSportsMatchFlag = (ESQ_WildcardMatch(SCRIPT_FilterTag_SPORTS, nameShort) == 0) ? 1 : 0;
    }

    if (modeChar != TEXTDISP_FILTER_MODE_FILTER && modeChar != TEXTDISP_FILTER_MODE_EXACT) {
        TEXTDISP_FilterModeId = TEXTDISP_FILTER_DONE;
    }

    while (found == 0 && TEXTDISP_FilterModeId != TEXTDISP_FILTER_DONE) {
        if (TEXTDISP_FilterChannelSlotIndex == 0) {
            mode = (LONG)TEXTDISP_FilterModeId;
            count = TEXTDISP_GetGroupEntryCount(mode);
            TEXTDISP_FilterMatchCount = 0;

            for (idx = 0; idx < count; idx++) {
                candidate = (const TEXTDISP_CandidateEntry *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate == 0) {
                    continue;
                }
                if ((candidate->flags27 & (1u << TEXTDISP_FLAG_HIDDEN_BIT)) != 0) {
                    continue;
                }
                if (TEXTDISP_FilterPpvSbeMatchFlag != 0 &&
                    ((candidate->flags27 & (1u << TEXTDISP_FLAG_PPV_SBE_BIT)) != 0)) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                    continue;
                }
                if (TEXTDISP_FilterSportsMatchFlag != 0 &&
                    TEXTDISP_ShouldOpenEditorForEntry(candidate) != 0) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                    continue;
                }
                if (ESQ_WildcardMatch(candidate->tagText, nameShort) == 0) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                }
            }

            if (TEXTDISP_FilterMatchCount > 0) {
                TEXTDISP_FilterCandidateCursor = 0;
                TEXTDISP_FilterChannelSlotIndex =
                    (TEXTDISP_FilterModeId == TEXTDISP_FILTER_PRIMARY) ? CLOCK_HalfHourSlotIndex : TEXTDISP_FILTER_SLOT_FIRST;
            } else {
                TEXTDISP_FilterChannelSlotIndex = TEXTDISP_FILTER_SLOT_SENTINEL;
            }
        }

        while (found == 0 && TEXTDISP_FilterChannelSlotIndex < TEXTDISP_FILTER_SLOT_SENTINEL) {
            if (TEXTDISP_FilterCandidateCursor >= TEXTDISP_FilterMatchCount) {
                break;
            }

            idx = (LONG)TEXTDISP_CandidateIndexList[TEXTDISP_FilterCandidateCursor];
            mode = (LONG)TEXTDISP_FilterModeId;
            aux = (const TEXTDISP_AuxData *)TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(idx, mode);
            if (aux == 0) {
                TEXTDISP_FilterCandidateCursor++;
                continue;
            }

            slot = (LONG)TEXTDISP_FilterChannelSlotIndex;
            titleSlot = slot;
            candidateTitle = aux->titleTable[titleSlot];

            if (TEXTDISP_FilterModeId == TEXTDISP_FILTER_PRIMARY &&
                slot == (LONG)CLOCK_HalfHourSlotIndex) {
                while (titleSlot > 0 && candidateTitle == 0) {
                    titleSlot--;
                    candidateTitle = aux->titleTable[titleSlot];
                }
            }

            if (TEXTDISP_FilterModeId == TEXTDISP_FILTER_PRIMARY && candidateTitle != 0) {
                candidate = (const TEXTDISP_CandidateEntry *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate == 0 ||
                    TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(
                        candidate, aux, titleSlot, TEXTDISP_FILTER_DAY_MINUTES, CONFIG_TimeWindowMinutes) == 0) {
                    candidateTitle = 0;
                }
            }

            if (candidateTitle != 0) {
                candidateTitle = TEXTDISP_SkipControlCodes(candidateTitle);
            }
            if (candidateTitle == 0) {
                TEXTDISP_FilterCandidateCursor++;
                continue;
            }

            if (TEXTDISP_FilterSportsMatchFlag != 0 &&
                ESQDISP_TestEntryGridEligibility((const UBYTE *)aux, (UWORD)titleSlot) == 0) {
                TEXTDISP_FilterCandidateCursor++;
                continue;
            }

            nameEnd = nameLong;
            while (*nameEnd != 0) {
                nameEnd++;
            }
            nameLen = (LONG)(nameEnd - nameLong);
            if (STRING_CompareNoCaseN(nameLong, candidateTitle, nameLen) == 0) {
                candidate = (const TEXTDISP_CandidateEntry *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate != 0 &&
                    ESQ_TestBit1Based(candidate->selectionBits, titleSlot) == -1) {
                    found = 1;
                    TEXTDISP_SetSelectionFields(entry, mode, idx, titleSlot);
                    TEXTDISP_BuildEntryDetailLine(entry);
                }
            }

            TEXTDISP_FilterCandidateCursor++;
        }

        if (found == 0) {
            if (TEXTDISP_FilterChannelSlotIndex <= TEXTDISP_FILTER_SLOT_LAST) {
                TEXTDISP_FilterChannelSlotIndex++;
                TEXTDISP_FilterCandidateCursor = 0;
            } else {
                TEXTDISP_FilterChannelSlotIndex = 0;
                if (TEXTDISP_FilterModeId == TEXTDISP_FILTER_PRIMARY) {
                    TEXTDISP_FilterModeId = TEXTDISP_FILTER_SECONDARY;
                } else {
                    TEXTDISP_FilterModeId = TEXTDISP_FILTER_DONE;
                }
            }
        }
    }

    if (found == 0) {
        TEXTDISP_ResetSelectionState(entry);
    }

    return found;
}
