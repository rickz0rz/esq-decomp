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
extern UBYTE TEXTDISP_CurrentMatchIndex;
extern UWORD TEXTDISP_ActiveGroupId;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE TEXTDISP_FindModeActiveFlag;
extern UWORD TEXTDISP_SbeFilterActiveFlag;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UBYTE TEXTDISP_CandidateIndexList[];
extern UBYTE TEXTDISP_Tag_SPT_Select[];
extern UBYTE TEXTDISP_PrimaryTitlePtrTable[];
extern UBYTE TEXTDISP_SecondaryTitlePtrTable[];

extern UWORD CLOCK_HalfHourSlotIndex;
extern UBYTE CLOCK_CurrentDayOfWeekIndex;
extern UBYTE Global_STR_TEXTDISP_C_3[];

extern LONG TEXTDISP_FindEntryMatchIndex(void *titles, LONG mode, LONG flags);
extern LONG TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG idx);

LONG TEXTDISP_SelectBestMatchFromList(void *titles, UWORD candidateCount, UWORD channelCode, const char *tag)
{
    LONG i;
    LONG rc = 2;
    WORD lastChannel = 0x31;
    WORD bestDelta = 0x05a1;
    WORD altDelta = (WORD)0xfa5f;
    WORD lastScore = (WORD)0xfffa;
    UBYTE sptFlags = 0;

    TEXTDISP_BannerFallbackValidFlag = 0;
    TEXTDISP_BannerSelectedValidFlag = 0;
    TEXTDISP_BannerCharSelected = 100;

    {
        const UBYTE *a = TEXTDISP_Tag_SPT_Select;
        const UBYTE *b = (const UBYTE *)tag;
        while (*a == *b) {
            if (*a == 0) {
                sptFlags = 8;
                break;
            }
            a++;
            b++;
        }
    }

    TEXTDISP_BannerCharFallback = 0x31;
    if (channelCode == 0) channelCode = 48;

    if (!((channelCode >= 48 && channelCode <= 67) || (channelCode >= 72 && channelCode <= 77))) {
        return 1;
    }

    {
        LONG bit = 1L << CLOCK_CurrentDayOfWeekIndex;
        if (((LONG)Global_STR_TEXTDISP_C_3[channelCode] & bit) == 0) {
            return 1;
        }
    }

    for (i = 0; i < candidateCount; i++) {
        LONG idx, idx2;
        LONG t1, t2;
        LONG special = 0;
        LONG groupCode;
        const char *title;
        LONG minIndex;

        TEXTDISP_CurrentMatchIndex = TEXTDISP_CandidateIndexList[i];
        idx = TEXTDISP_FindEntryMatchIndex(titles, 1, sptFlags);

        if (idx < 49) {
            if (TEXTDISP_ActiveGroupId) {
                groupCode = TEXTDISP_PrimaryGroupCode;
                title = *(const char **)(TEXTDISP_PrimaryTitlePtrTable + ((LONG)TEXTDISP_CurrentMatchIndex << 2));
            } else {
                groupCode = TEXTDISP_SecondaryGroupCode;
                title = *(const char **)(TEXTDISP_SecondaryTitlePtrTable + ((LONG)TEXTDISP_CurrentMatchIndex << 2));
            }
            t1 = TEXTDISP_ComputeTimeOffset(groupCode, title, idx);
        } else {
            continue;
        }

        if (TEXTDISP_ActiveGroupId) {
            if (idx < CLOCK_HalfHourSlotIndex || (idx == CLOCK_HalfHourSlotIndex && t1 <= 0)) special = 1;
        }

        minIndex = TEXTDISP_ActiveGroupId ? CLOCK_HalfHourSlotIndex : 1;
        if (idx <= minIndex) {
            idx2 = TEXTDISP_FindEntryMatchIndex(titles, 2, sptFlags);
            if (idx2 < 49) {
                TEXTDISP_BannerFallbackValidFlag = 1;
            } else {
                idx2 = idx;
            }
        } else {
            idx2 = idx;
        }

        if (TEXTDISP_ActiveGroupId) {
            groupCode = TEXTDISP_PrimaryGroupCode;
            title = *(const char **)(TEXTDISP_PrimaryTitlePtrTable + ((LONG)TEXTDISP_CurrentMatchIndex << 2));
        } else {
            groupCode = TEXTDISP_SecondaryGroupCode;
            title = *(const char **)(TEXTDISP_SecondaryTitlePtrTable + ((LONG)TEXTDISP_CurrentMatchIndex << 2));
        }
        t2 = TEXTDISP_ComputeTimeOffset(groupCode, title, idx2);

        if (TEXTDISP_ActiveGroupId && idx == CLOCK_HalfHourSlotIndex && t2 > 0) {
            idx = TEXTDISP_FindEntryMatchIndex(titles, 3, sptFlags);
        }

        if (t2 > 0 && t2 < bestDelta) {
            TEXTDISP_BannerSelectedValidFlag = 1;
            TEXTDISP_BannerCharSelected = (UBYTE)idx2;
            TEXTDISP_BannerSelectedEntryIndex = TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerSelectedIsSpecialFlag = (UBYTE)special;
        } else if (!TEXTDISP_BannerSelectedValidFlag && t2 <= 0 && t2 > altDelta) {
            TEXTDISP_BannerCharSelected = (UBYTE)idx2;
            TEXTDISP_BannerSelectedEntryIndex = TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerSelectedIsSpecialFlag = (UBYTE)special;
        }

        if (t2 > 0 && t2 < bestDelta) {
            TEXTDISP_BannerFallbackValidFlag = 1;
            TEXTDISP_BannerCharFallback = (UBYTE)idx2;
            TEXTDISP_BannerFallbackEntryIndex = TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerFallbackIsSpecialFlag = (UBYTE)special;
            bestDelta = t2;
        } else if (!TEXTDISP_BannerFallbackValidFlag && t2 <= 0 && t2 > altDelta) {
            TEXTDISP_BannerCharFallback = (UBYTE)idx2;
            TEXTDISP_BannerFallbackEntryIndex = TEXTDISP_CurrentMatchIndex;
            TEXTDISP_BannerFallbackIsSpecialFlag = (UBYTE)special;
            altDelta = t2;
        }

        lastScore = ((UWORD *)title)[200 + idx2];
        lastChannel = (WORD)idx;

        if (TEXTDISP_FindModeActiveFlag == 1) {
            return 2;
        }

        if (lastChannel == 49 && !TEXTDISP_SbeFilterActiveFlag) {
            idx = TEXTDISP_FindEntryMatchIndex(titles, 0, sptFlags);
            TEXTDISP_BannerFallbackEntryIndex = TEXTDISP_CurrentMatchIndex;
            lastChannel = (WORD)idx;
        }
    }

    if (lastChannel < 0x31) {
        if (bestDelta >= 0x3d) TEXTDISP_BannerCharSelected = 100;
    }

    if (TEXTDISP_BannerCharSelected != 100) {
        if (TEXTDISP_ActiveGroupId) {
            const UBYTE *t = *(const UBYTE **)(TEXTDISP_PrimaryTitlePtrTable + ((LONG)TEXTDISP_BannerSelectedEntryIndex << 2));
            ((UWORD *)t)[200 + TEXTDISP_BannerCharSelected] += 1;
        } else {
            const UBYTE *t = *(const UBYTE **)(TEXTDISP_SecondaryTitlePtrTable + ((LONG)TEXTDISP_BannerSelectedEntryIndex << 2));
            ((UWORD *)t)[200 + TEXTDISP_BannerCharSelected] += 1;
        }
        return 2;
    }

    if ((channelCode > 48 && channelCode < 58) ||
        (channelCode > 62 && channelCode < 68) ||
        (channelCode > 71 && channelCode < 78)) {
        channelCode = 68;
        return 1;
    }

    return 0;
}
