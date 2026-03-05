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
        modeChar = 0;
    }

    nameShort = (UBYTE *)0;
    nameLong = (UBYTE *)0;
    if (entry != (UBYTE *)0) {
        nameShort = entry;
        nameLong = entry + 10;
        if (nameShort[0] == 0 || nameLong[0] == 0) {
            modeChar = 0;
        }
    }

    if (modeChar == 'F') {
        TEXTDISP_FilterChannelSlotIndex = 0;
        TEXTDISP_FilterModeId = 1;

        ppvSbe = 1;
        if (UNKNOWN_JMPTBL_ESQ_WildcardMatch(SCRIPT_FilterTag_PPV, (const char *)nameShort) != 0 &&
            UNKNOWN_JMPTBL_ESQ_WildcardMatch(SCRIPT_FilterTag_SBE, (const char *)nameShort) != 0) {
            ppvSbe = 0;
        }
        TEXTDISP_FilterPpvSbeMatchFlag = (UWORD)ppvSbe;
        TEXTDISP_FilterSportsMatchFlag = (UNKNOWN_JMPTBL_ESQ_WildcardMatch(SCRIPT_FilterTag_SPORTS, (const char *)nameShort) == 0) ? 1 : 0;
    }

    if (modeChar != 'F' && modeChar != 'X') {
        TEXTDISP_FilterModeId = 3;
    }

    while (found == 0 && TEXTDISP_FilterModeId != 3) {
        if (TEXTDISP_FilterChannelSlotIndex == 0) {
            mode = (LONG)TEXTDISP_FilterModeId;
            count = TEXTDISP_GetGroupEntryCount(mode);
            TEXTDISP_FilterMatchCount = 0;

            for (idx = 0; idx < count; idx++) {
                candidate = (void *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate == (void *)0) {
                    continue;
                }
                if ((((UBYTE *)candidate)[27] & (1u << 3)) != 0) {
                    continue;
                }
                if (TEXTDISP_FilterPpvSbeMatchFlag != 0 && ((((UBYTE *)candidate)[27] & (1u << 4)) != 0)) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                    continue;
                }
                if (TEXTDISP_FilterSportsMatchFlag != 0 && TEXTDISP_ShouldOpenEditorForEntry(candidate) != 0) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                    continue;
                }
                if (UNKNOWN_JMPTBL_ESQ_WildcardMatch((const char *)(candidate ? ((UBYTE *)candidate + 12) : (UBYTE *)0), (const char *)nameShort) == 0) {
                    TEXTDISP_CandidateIndexList[TEXTDISP_FilterMatchCount++] = (UBYTE)idx;
                }
            }

            if (TEXTDISP_FilterMatchCount > 0) {
                TEXTDISP_FilterCandidateCursor = 0;
                TEXTDISP_FilterChannelSlotIndex = (TEXTDISP_FilterModeId == 1) ? CLOCK_HalfHourSlotIndex : 1;
            } else {
                TEXTDISP_FilterChannelSlotIndex = 49;
            }
        }

        while (found == 0 && TEXTDISP_FilterChannelSlotIndex < 49) {
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
            candidateTitle = (UBYTE *)((ULONG *)((UBYTE *)aux + 56))[slot];
            if (TEXTDISP_FilterModeId == 1) {
                candidate = (void *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate == (void *)0 ||
                    TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(candidate, aux, slot, 1440, CONFIG_TimeWindowMinutes) == 0) {
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
            while (candidateName[nameLen] != 0) {
                nameLen++;
            }
            if (STRING_CompareNoCaseN((const char *)candidateName, (const char *)candidateTitle, nameLen) == 0) {
                candidate = (void *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(idx, mode);
                if (candidate != (void *)0 &&
                    TLIBA2_JMPTBL_ESQ_TestBit1Based((void *)((UBYTE *)candidate + 28), slot) == -1) {
                    found = 1;
                    TEXTDISP_SetSelectionFields(entry, mode, idx, slot);
                    TEXTDISP_BuildEntryDetailLine(entry);
                }
            }

            TEXTDISP_FilterCandidateCursor++;
        }

        if (found == 0) {
            if (TEXTDISP_FilterChannelSlotIndex <= 48) {
                TEXTDISP_FilterChannelSlotIndex++;
                TEXTDISP_FilterCandidateCursor = 0;
            } else {
                TEXTDISP_FilterChannelSlotIndex = 0;
                if (TEXTDISP_FilterModeId == 1) {
                    TEXTDISP_FilterModeId = 2;
                } else {
                    TEXTDISP_FilterModeId = 3;
                }
            }
        }
    }

    if (found == 0) {
        TEXTDISP_ResetSelectionState(entry);
    }

    return found;
}
