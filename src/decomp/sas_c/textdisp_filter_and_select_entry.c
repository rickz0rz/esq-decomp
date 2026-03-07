typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

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

extern LONG UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *pattern, const char *text);
extern LONG TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern LONG TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void *entry, void *aux, LONG index, LONG window, LONG minutes);
extern LONG TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(void *aux, LONG slot);
extern LONG TLIBA2_JMPTBL_ESQ_TestBit1Based(void *bits, LONG index);
extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);
extern LONG TEXTDISP_GetGroupEntryCount(LONG mode);
extern LONG TEXTDISP_ShouldOpenEditorForEntry(void *entry);
extern UBYTE *TEXTDISP_SkipControlCodes(UBYTE *text);
extern void TEXTDISP_SetSelectionFields(void *entry, LONG mode, LONG displayIndex, LONG entryIndex);
extern void TEXTDISP_BuildEntryDetailLine(void *entry);
extern void TEXTDISP_ResetSelectionState(void *entry);

LONG TEXTDISP_FilterAndSelectEntry(void *entryPtr, UBYTE modeChar)
{
    const UBYTE CH_NUL = 0;
    const UBYTE CH_MODE_FILTER = 'F';
    const UBYTE CH_MODE_EXACT = 'X';
    const LONG MODE_FILTER_PRIMARY = 1;
    const LONG MODE_FILTER_SECONDARY = 2;
    const LONG MODE_FILTER_DONE = 3;
    const LONG SLOT_FIRST = 1;
    const LONG SLOT_MAX = 49;
    const LONG SLOT_LAST_VALID = 48;
    const LONG MINUTES_PER_DAY = 1440;
    const LONG BIT_SHIFT_HIDDEN = 3;
    const LONG BIT_SHIFT_PPV_SBE = 4;
    const LONG ENTRY_SHORT_NAME_OFFSET = 0;
    const LONG ENTRY_LONG_NAME_OFFSET = 10;
    const LONG ENTRY_TAG_OFFSET = 12;
    const LONG ENTRY_FLAGS_OFFSET = 27;
    const LONG ENTRY_BITMAP_OFFSET = 28;
    const LONG AUX_TITLE_TABLE_OFFSET = 56;
    const LONG MATCH_FOUND_FLAG = -1;
    UBYTE *entry;
    UBYTE *nameShort;
    UBYTE *nameLong;
    UBYTE *candidateName;
    UBYTE *candidateTitle;
    void *aux;
    void *candidate;
    LONG found;
    LONG mode;
    LONG count;
    LONG idx;
    LONG slot;
    LONG ppvSbe;
    LONG nameLen;

    found = 0;
    entry = (UBYTE *)entryPtr;
    if (entry == (UBYTE *)0) {
        modeChar = CH_NUL;
    }

    nameShort = (UBYTE *)0;
    nameLong = (UBYTE *)0;
    if (entry != (UBYTE *)0) {
        nameShort = entry + ENTRY_SHORT_NAME_OFFSET;
        nameLong = entry + ENTRY_LONG_NAME_OFFSET;
        if (nameShort[0] == CH_NUL || nameLong[0] == CH_NUL) {
            modeChar = CH_NUL;
        }
    }

    if (modeChar == CH_MODE_FILTER) {
        TEXTDISP_FilterChannelSlotIndex = 0;
        TEXTDISP_FilterModeId = MODE_FILTER_PRIMARY;

        ppvSbe = 1;
        if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(SCRIPT_FilterTag_PPV, (const char *)nameShort) != 0 &&
            UNKNOWN_JMPTBL_ESQ_WildcardMatch(SCRIPT_FilterTag_SBE, (const char *)nameShort) != 0) {
            ppvSbe = 0;
        }
        TEXTDISP_FilterPpvSbeMatchFlag = (UWORD)ppvSbe;
        TEXTDISP_FilterSportsMatchFlag = (UNKNOWN_JMPTBL_ESQ_WildcardMatch(SCRIPT_FilterTag_SPORTS, (const char *)nameShort) == 0) ? 1 : 0;
    }

    if (modeChar != CH_MODE_FILTER && modeChar != CH_MODE_EXACT) {
        TEXTDISP_FilterModeId = MODE_FILTER_DONE;
    }

    while (found == 0 && TEXTDISP_FilterModeId != MODE_FILTER_DONE) {
        if (TEXTDISP_FilterChannelSlotIndex == 0) {
            mode = (LONG)TEXTDISP_FilterModeId;
            count = TEXTDISP_GetGroupEntryCount(mode);
            TEXTDISP_FilterMatchCount = 0;

            for (idx = 0; idx < count; idx++) {
                candidate = (void *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate == (void *)0) {
                    continue;
                }
                if ((((UBYTE *)candidate)[ENTRY_FLAGS_OFFSET] & (1u << BIT_SHIFT_HIDDEN)) != 0) {
                    continue;
                }
                if (TEXTDISP_FilterPpvSbeMatchFlag != 0 &&
                    ((((UBYTE *)candidate)[ENTRY_FLAGS_OFFSET] & (1u << BIT_SHIFT_PPV_SBE)) != 0)) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                    continue;
                }
                if (TEXTDISP_FilterSportsMatchFlag != 0 && TEXTDISP_ShouldOpenEditorForEntry(candidate) != 0) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                    continue;
                }
                if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(
                        (const char *)(candidate ? ((UBYTE *)candidate + ENTRY_TAG_OFFSET) : (UBYTE *)0),
                        (const char *)nameShort) == 0) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                }
            }

            if (TEXTDISP_FilterMatchCount > 0) {
                TEXTDISP_FilterCandidateCursor = 0;
                TEXTDISP_FilterChannelSlotIndex =
                    (TEXTDISP_FilterModeId == MODE_FILTER_PRIMARY) ? CLOCK_HalfHourSlotIndex : SLOT_FIRST;
            } else {
                TEXTDISP_FilterChannelSlotIndex = SLOT_MAX;
            }
        }

        while (found == 0 && TEXTDISP_FilterChannelSlotIndex < SLOT_MAX) {
            if (TEXTDISP_FilterCandidateCursor >= TEXTDISP_FilterMatchCount) {
                break;
            }

            idx = (LONG)TEXTDISP_CandidateIndexList[TEXTDISP_FilterCandidateCursor];
            mode = (LONG)TEXTDISP_FilterModeId;
            aux = (void *)TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(idx, mode);
            if (aux == (void *)0) {
                TEXTDISP_FilterCandidateCursor++;
                continue;
            }

            slot = (LONG)TEXTDISP_FilterChannelSlotIndex;
            candidateTitle = (UBYTE *)((ULONG *)((UBYTE *)aux + AUX_TITLE_TABLE_OFFSET))[slot];
            if (TEXTDISP_FilterModeId == MODE_FILTER_PRIMARY) {
                candidate = (void *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate == (void *)0 ||
                    TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(
                        candidate, aux, slot, MINUTES_PER_DAY, CONFIG_TimeWindowMinutes) == 0) {
                    candidateTitle = (UBYTE *)0;
                }
            }

            if (candidateTitle != (UBYTE *)0) {
                candidateTitle = TEXTDISP_SkipControlCodes(candidateTitle);
            }
            if (candidateTitle == (UBYTE *)0) {
                TEXTDISP_FilterCandidateCursor++;
                continue;
            }

            if (TEXTDISP_FilterSportsMatchFlag != 0 &&
                TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(aux, slot) == 0) {
                TEXTDISP_FilterCandidateCursor++;
                continue;
            }

            candidateName = nameLong;
            nameLen = 0;
            while (candidateName[nameLen] != CH_NUL) {
                nameLen++;
            }
            if (STRING_CompareNoCaseN((const char *)candidateName, (const char *)candidateTitle, nameLen) == 0) {
                candidate = (void *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate != (void *)0 &&
                    TLIBA2_JMPTBL_ESQ_TestBit1Based((void *)((UBYTE *)candidate + ENTRY_BITMAP_OFFSET), slot) ==
                        MATCH_FOUND_FLAG) {
                    found = 1;
                    TEXTDISP_SetSelectionFields(entry, mode, idx, slot);
                    TEXTDISP_BuildEntryDetailLine(entry);
                }
            }

            TEXTDISP_FilterCandidateCursor++;
        }

        if (found == 0) {
            if (TEXTDISP_FilterChannelSlotIndex <= SLOT_LAST_VALID) {
                TEXTDISP_FilterChannelSlotIndex++;
                TEXTDISP_FilterCandidateCursor = 0;
            } else {
                TEXTDISP_FilterChannelSlotIndex = 0;
                if (TEXTDISP_FilterModeId == MODE_FILTER_PRIMARY) {
                    TEXTDISP_FilterModeId = MODE_FILTER_SECONDARY;
                } else {
                    TEXTDISP_FilterModeId = MODE_FILTER_DONE;
                }
            }
        }
    }

    if (found == 0) {
        TEXTDISP_ResetSelectionState(entry);
    }

    return found;
}
