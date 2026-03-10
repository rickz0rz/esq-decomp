typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;
typedef signed short WORD;

extern UBYTE TEXTDISP_BannerFallbackValidFlag;
extern UBYTE TEXTDISP_BannerSelectedValidFlag;
extern UBYTE TEXTDISP_BannerCharSelected;
extern UBYTE TEXTDISP_BannerCharFallback;
extern UBYTE TEXTDISP_BannerFallbackEntryIndex;
extern UBYTE TEXTDISP_BannerSelectedEntryIndex;
extern UBYTE TEXTDISP_BannerFallbackIsSpecialFlag;
extern UBYTE TEXTDISP_BannerSelectedIsSpecialFlag;
extern UWORD TEXTDISP_CurrentMatchIndex;
extern UWORD TEXTDISP_ActiveGroupId;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE TEXTDISP_FindModeActiveFlag;
extern UWORD TEXTDISP_SbeFilterActiveFlag;
extern UBYTE TEXTDISP_CandidateIndexList[];
extern const UBYTE TEXTDISP_Tag_SPT_Select[];
extern char *TEXTDISP_PrimaryTitlePtrTable[];
extern char *TEXTDISP_SecondaryTitlePtrTable[];

extern UWORD CLOCK_HalfHourSlotIndex;
extern UBYTE CLOCK_CurrentDayOfWeekIndex;
extern const UBYTE Global_STR_TEXTDISP_C_3[];

extern LONG TEXTDISP_FindEntryMatchIndex(char *titles, LONG mode, LONG flags);
extern LONG TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG idx);

static const char *TEXTDISP_GetActiveTitlePtr(UWORD matchIndex, LONG *groupCodeOut)
{
    if (TEXTDISP_ActiveGroupId != 0) {
        *groupCodeOut = (LONG)TEXTDISP_PrimaryGroupCode;
        return TEXTDISP_PrimaryTitlePtrTable[matchIndex];
    }

    *groupCodeOut = (LONG)TEXTDISP_SecondaryGroupCode;
    return TEXTDISP_SecondaryTitlePtrTable[matchIndex];
}

static UWORD TEXTDISP_GetUsageCount(const char *titlePtr, WORD slotIndex)
{
    return ((UWORD *)titlePtr)[200 + (UWORD)slotIndex];
}

LONG TEXTDISP_SelectBestMatchFromList(char *titles, UWORD candidateCount, UWORD channelCode, const char *tag)
{
    LONG i;
    WORD lastMatchIndex;
    WORD bestPositiveDelta;
    WORD bestNegativeDelta;
    WORD previousUsageCount;
    UBYTE sptMask;

    lastMatchIndex = 0x31;
    bestPositiveDelta = 0x05a1;
    bestNegativeDelta = (WORD)0xfa5f;
    previousUsageCount = (WORD)0xfffa;

    TEXTDISP_BannerFallbackValidFlag = 0;
    TEXTDISP_BannerSelectedValidFlag = 0;
    TEXTDISP_BannerCharSelected = 100;

    sptMask = 0;
    {
        const UBYTE *a = TEXTDISP_Tag_SPT_Select;
        const UBYTE *b = (const UBYTE *)tag;

        while (*a == *b) {
            if (*a == 0) {
                sptMask = 8;
                break;
            }
            ++a;
            ++b;
        }
    }

    TEXTDISP_BannerCharFallback = 0x31;

    if (channelCode == 0) {
        channelCode = 48;
    }

    if (!((channelCode >= 48 && channelCode <= 67) ||
          (channelCode >= 72 && channelCode <= 77))) {
        return 1;
    }

    if (((LONG)Global_STR_TEXTDISP_C_3[channelCode] & (1L << CLOCK_CurrentDayOfWeekIndex)) == 0) {
        return 1;
    }

    for (i = 0; i < (LONG)candidateCount; ++i) {
        LONG groupCode;
        LONG slotIndex;
        LONG candidateSlot;
        LONG timeOffset;
        LONG minIndex;
        LONG specialFlag;
        const char *titlePtr;
        UWORD usageCount;

        TEXTDISP_CurrentMatchIndex = (UWORD)TEXTDISP_CandidateIndexList[i];
        slotIndex = TEXTDISP_FindEntryMatchIndex(titles, 1, (LONG)sptMask);
        if (slotIndex >= 49) {
            continue;
        }

        titlePtr = TEXTDISP_GetActiveTitlePtr(TEXTDISP_CurrentMatchIndex, &groupCode);
        timeOffset = TEXTDISP_ComputeTimeOffset(groupCode, titlePtr, slotIndex);

        specialFlag = 0;
        if (TEXTDISP_ActiveGroupId != 0) {
            if (slotIndex < (LONG)CLOCK_HalfHourSlotIndex ||
                (slotIndex == (LONG)CLOCK_HalfHourSlotIndex && timeOffset <= 0)) {
                specialFlag = 1;
            }
        }

        if (TEXTDISP_ActiveGroupId != 0) {
            minIndex = (LONG)CLOCK_HalfHourSlotIndex;
        } else {
            minIndex = 1;
        }

        if (slotIndex <= minIndex) {
            candidateSlot = TEXTDISP_FindEntryMatchIndex(titles, 2, (LONG)sptMask);
            if (candidateSlot < 49) {
                TEXTDISP_BannerFallbackValidFlag = 1;
            } else {
                candidateSlot = slotIndex;
            }
        } else {
            candidateSlot = slotIndex;
        }

        timeOffset = TEXTDISP_ComputeTimeOffset(groupCode, titlePtr, candidateSlot);

        if (TEXTDISP_ActiveGroupId != 0 &&
            slotIndex == (LONG)CLOCK_HalfHourSlotIndex &&
            timeOffset > 0) {
            slotIndex = TEXTDISP_FindEntryMatchIndex(titles, 3, (LONG)sptMask);
        }

        usageCount = TEXTDISP_GetUsageCount(titlePtr, (WORD)candidateSlot);

        if (timeOffset > 0 && usageCount > (UWORD)previousUsageCount) {
            TEXTDISP_BannerSelectedValidFlag = 1;
            TEXTDISP_BannerCharSelected = (UBYTE)candidateSlot;
            TEXTDISP_BannerSelectedEntryIndex = (UBYTE)TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerSelectedIsSpecialFlag = (UBYTE)specialFlag;
        }

        if (timeOffset > 0 && timeOffset < (LONG)bestPositiveDelta) {
            TEXTDISP_BannerFallbackValidFlag = 1;
            TEXTDISP_BannerCharFallback = (UBYTE)candidateSlot;
            TEXTDISP_BannerFallbackEntryIndex = (UBYTE)TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerFallbackIsSpecialFlag = (UBYTE)specialFlag;
            bestPositiveDelta = (WORD)timeOffset;
        } else if (TEXTDISP_BannerSelectedValidFlag == 0 &&
                   timeOffset <= 0 &&
                   timeOffset > (LONG)bestNegativeDelta &&
                   usageCount > (UWORD)previousUsageCount) {
            TEXTDISP_BannerCharSelected = (UBYTE)candidateSlot;
            TEXTDISP_BannerSelectedEntryIndex = (UBYTE)TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerSelectedIsSpecialFlag = (UBYTE)specialFlag;
        }

        if (TEXTDISP_BannerFallbackValidFlag == 0 &&
            timeOffset <= 0 &&
            timeOffset > (LONG)bestNegativeDelta) {
            TEXTDISP_BannerCharFallback = (UBYTE)candidateSlot;
            TEXTDISP_BannerFallbackEntryIndex = (UBYTE)TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerFallbackIsSpecialFlag = (UBYTE)specialFlag;
            bestNegativeDelta = (WORD)timeOffset;
        }

        previousUsageCount = (WORD)usageCount;
        lastMatchIndex = (WORD)slotIndex;

        if (TEXTDISP_FindModeActiveFlag == 1) {
            return 2;
        }

        if (lastMatchIndex == 49 && TEXTDISP_SbeFilterActiveFlag == 0) {
            lastMatchIndex = (WORD)TEXTDISP_FindEntryMatchIndex(titles, 0, (LONG)sptMask);
            TEXTDISP_BannerFallbackEntryIndex = (UBYTE)TEXTDISP_CurrentMatchIndex;
        }
    }

    if (lastMatchIndex < 0x31) {
        if (bestPositiveDelta >= 0x3d) {
            TEXTDISP_BannerCharSelected = 100;
        }

        if (TEXTDISP_BannerCharSelected != 100) {
            LONG groupCode;
            const char *titlePtr = TEXTDISP_GetActiveTitlePtr(
                (UWORD)TEXTDISP_BannerSelectedEntryIndex,
                &groupCode);

            (void)groupCode;
            ++((UWORD *)titlePtr)[200 + TEXTDISP_BannerCharSelected];
            return 2;
        }
    }

    if ((channelCode > 48 && channelCode < 58) ||
        (channelCode > 62 && channelCode < 68) ||
        (channelCode > 71 && channelCode < 78)) {
        channelCode = 68;
        (void)channelCode;
        return 1;
    }

    return 0;
}
