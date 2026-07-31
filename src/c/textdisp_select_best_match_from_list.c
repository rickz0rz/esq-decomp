/* RESTORES: TEXTDISP_SelectBestMatchFromList
 * MODULE:   modules/groups/b/a/textdisp3_p1_p5.s
 * STATUS:   behavioural
 *
 * Scans the candidate list and picks TWO winners: a "selected" banner entry and
 * a "fallback" one. They are chosen by different rules, tracked in separate
 * globals, and either can end up unset. Most of the function is the four-way
 * scoring test applied to each candidate.
 *
 * THE TWO SCORE BOUNDS START AT MIRRORED SENTINELS -- 1441 and -1441, which is
 * one more than the 1440 minutes in a day. So the first candidate with a
 * positive offset always beats bestScore, and the first with a non-positive one
 * always beats altScore. The third sentinel, lastUsage, starts at -6 and is
 * compared UNSIGNED, so it starts effectively at 65530 and any real usage count
 * beats it.
 *
 * That unsigned comparison is not incidental. `BLS` is used at both usage
 * sites, and reading them as signed inverts the selection for every entry whose
 * counter has wrapped.
 *
 * THE SCORING IS A CHAIN, NOT FOUR INDEPENDENT TESTS. A candidate that wins the
 * fallback-by-score arm branches straight to the end of the loop, skipping both
 * remaining tests. The two after it are guarded on the corresponding valid flag
 * being still clear, so they only ever fire before anything has been selected.
 * That is why the C below nests them in an `else` rather than listing four
 * `if`s.
 *
 * THE TIME OFFSET IS COMPUTED TWICE with different arguments and the second
 * result overwrites the first. The first call uses the raw match index; the
 * second uses the entry index, which may have come from a different search.
 * Only the second is scored. The first exists solely to feed the `special`
 * decision above it.
 *
 * THE CHANNEL CODE IS RANGE-CHECKED TWICE, AGAINST DIFFERENT RANGES, at
 * opposite ends of the function. On entry it must be in 48..67 or 72..77 or the
 * function refuses outright. At the end -- reached only when no candidate
 * produced a usable index -- the ranges 49..57, 63..67 and 72..77 are rejected
 * INSTEAD. The two overlap, so a code in 72..77 passes the entry check and
 * fails the exit one. Both are transcribed as they stand.
 *
 * The exit assignment `channel = 68` is dead: nothing reads it and the function
 * returns immediately. 6.51 deletes it, the original keeps it, and it is 2 of
 * the bytes below. It is written out anyway because deleting it from the source
 * would hide that the original recorded a default.
 *
 * The day mask is `1 << CLOCK_CurrentDayOfWeekIndex` tested against a per-
 * channel byte, so the channel table encodes which days each channel runs.
 *
 * 1270 ref vs 1340 got, 26 differing regions. The tag comparison, both channel
 * range checks, the day mask, all five FindEntryMatchIndex calls with their
 * distinct mode arguments, all four ComputeTimeOffset calls, both group table
 * selections at each of the four sites, the usage array at +400, all four
 * scoring arms with their sentinel bounds, the find-mode early return and the
 * usage increment match in kind and size.
 *
 * TWO CANDIDATE SOURCE FORMS WERE MEASURED AND BOTH ARE WORSE, which is worth
 * recording so the next reader does not retry them:
 *
 *   as written below                                  1340
 *   `special` computed into a register, stored once   1348
 *   `min` zero-extended from the word                 1344
 *   both together                                     1352
 *
 * The single-store form looked like the obvious fix -- the original computes the
 * flag in D0 and stores it once, where 6.51 stores into the frame slot in each
 * arm. Introducing a temporary to force that made the function LONGER, because
 * 6.51 then keeps both the temporary and the flag live across the arms. The
 * zero-extension is the same story: the original does `MOVEQ #0,D0 / MOVE.W`,
 * but writing the cast that produces it costs more elsewhere than it saves.
 *
 * SASC-MISMATCH: per-arm-store-of-a-flag
 *   ref:     7001 / 7000 then one 1b40ffe9   MOVEQ into D0 per arm, ONE store
 *   got:     1f7c0001003c / 422f003c         a store per arm, no register form
 *   summary: the largest single region, 26 bytes. The original computes the
 *            special-case flag into a register through a four-way chain and
 *            stores the register once at the join; 6.51 sinks the store into
 *            each arm. Same value, same arms, one extra store each.
 *   tried:   a register temporary assigned in each arm and stored once after
 *            the chain. MEASURED at 1348 against 1340 -- 8 bytes WORSE, and it
 *            did not produce the single store either.
 *   scope:   any multi-arm computation of a value held in a frame slot.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>

struct TextDispTitle {
    char  pad0[400];
    short usage[50];                    /* +400, one counter per slot */
};

extern short TEXTDISP_FindEntryMatchIndex(void *arg, long mode, long sptFlag);
extern short TEXTDISP_ComputeTimeOffset(long groupCode,
                                        struct TextDispTitle *title,
                                        long idx);

extern struct TextDispTitle *TEXTDISP_PrimaryTitlePtrTable[];
extern struct TextDispTitle *TEXTDISP_SecondaryTitlePtrTable[];

extern unsigned char TEXTDISP_CandidateIndexList[];
extern unsigned char Global_STR_TEXTDISP_C_3[];
extern char  TEXTDISP_Tag_SPT_Select[];

extern char  TEXTDISP_PrimaryGroupCode;
extern char  TEXTDISP_SecondaryGroupCode;
extern short TEXTDISP_ActiveGroupId;
extern short TEXTDISP_CurrentMatchIndex;
extern short TEXTDISP_FindModeActiveFlag;
extern short TEXTDISP_SbeFilterActiveFlag;
extern short CLOCK_CurrentDayOfWeekIndex;
extern short CLOCK_HalfHourSlotIndex;

extern char TEXTDISP_BannerSelectedValidFlag;
extern char TEXTDISP_BannerFallbackValidFlag;
extern char TEXTDISP_BannerCharSelected;
extern char TEXTDISP_BannerCharFallback;
extern char TEXTDISP_BannerSelectedEntryIndex;
extern char TEXTDISP_BannerFallbackEntryIndex;
extern char TEXTDISP_BannerSelectedIsSpecialFlag;
extern char TEXTDISP_BannerFallbackIsSpecialFlag;

long TEXTDISP_SelectBestMatchFromList(void *arg, short count, short channel,
                                      char *tag)
{
    struct TextDispTitle *title;
    char  sptFlag;
    char  special;
    short i;
    short idx;
    short lastIdx;
    short entryIdx;
    short timeOffset;
    short lastUsage;
    short bestScore;
    short altScore;
    long  mask;
    long  min;

    lastUsage = -6;
    bestScore = 1441;
    altScore  = -1441;

    TEXTDISP_BannerFallbackValidFlag = TEXTDISP_BannerSelectedValidFlag = 0;
    TEXTDISP_BannerCharSelected      = 100;
    special = 0;

    if (strcmp(TEXTDISP_Tag_SPT_Select, tag) == 0)
        sptFlag = 8;
    else
        sptFlag = 0;

    lastIdx = 49;
    TEXTDISP_BannerCharFallback = (char)lastIdx;

    if (channel == 0)
        channel = 48;

    if (!(channel >= 48 && channel <= 67)) {
        if (channel < 72)
            return 1;
        if (channel > 77)
            return 1;
    }

    mask = 1L << CLOCK_CurrentDayOfWeekIndex;
    if (((long)Global_STR_TEXTDISP_C_3[channel] & mask) == 0)
        return 1;

    for (i = 0; i < count; i++) {

        TEXTDISP_CurrentMatchIndex = (short)TEXTDISP_CandidateIndexList[i];

        idx = TEXTDISP_FindEntryMatchIndex(arg, 1L, (long)sptFlag);

        if (idx < 49) {

            if (TEXTDISP_ActiveGroupId != 0)
                timeOffset = TEXTDISP_ComputeTimeOffset(
                    (long)TEXTDISP_PrimaryGroupCode,
                    TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_CurrentMatchIndex],
                    (long)idx);
            else
                timeOffset = TEXTDISP_ComputeTimeOffset(
                    (long)TEXTDISP_SecondaryGroupCode,
                    TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_CurrentMatchIndex],
                    (long)idx);

            if (TEXTDISP_ActiveGroupId == 0) {
                special = 0;
            } else {
                if (idx < CLOCK_HalfHourSlotIndex)
                    special = 1;
                else if (CLOCK_HalfHourSlotIndex != idx)
                    special = 0;
                else if (timeOffset > 0)
                    special = 0;
                else
                    special = 1;
            }

            if (TEXTDISP_ActiveGroupId != 0)
                min = (long)CLOCK_HalfHourSlotIndex;
            else
                min = 1;

            if ((long)idx > min) {
                entryIdx = idx;
            } else {
                entryIdx = TEXTDISP_FindEntryMatchIndex(arg, 2L,
                                                        (long)sptFlag);
                if (entryIdx >= 49)
                    entryIdx = idx;
                else
                    TEXTDISP_BannerFallbackValidFlag = 1;
            }

            if (TEXTDISP_ActiveGroupId != 0)
                timeOffset = TEXTDISP_ComputeTimeOffset(
                    (long)TEXTDISP_PrimaryGroupCode,
                    TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_CurrentMatchIndex],
                    (long)entryIdx);
            else
                timeOffset = TEXTDISP_ComputeTimeOffset(
                    (long)TEXTDISP_SecondaryGroupCode,
                    TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_CurrentMatchIndex],
                    (long)entryIdx);

            if (TEXTDISP_ActiveGroupId != 0
                && idx == CLOCK_HalfHourSlotIndex
                && timeOffset > 0)
                idx = TEXTDISP_FindEntryMatchIndex(arg, 3L, (long)sptFlag);

            if (TEXTDISP_ActiveGroupId != 0)
                title =
                    TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_CurrentMatchIndex];
            else
                title =
                    TEXTDISP_SecondaryTitlePtrTable[TEXTDISP_CurrentMatchIndex];

            if (timeOffset > 0
                && (unsigned short)lastUsage
                       > (unsigned short)title->usage[entryIdx]) {
                TEXTDISP_BannerSelectedValidFlag    = 1;
                TEXTDISP_BannerCharSelected         = (char)entryIdx;
                TEXTDISP_BannerSelectedEntryIndex   =
                    (char)TEXTDISP_CurrentMatchIndex;
                TEXTDISP_BannerSelectedIsSpecialFlag = special;
            }

            if (timeOffset > 0 && timeOffset < bestScore) {

                TEXTDISP_BannerFallbackValidFlag     = 1;
                TEXTDISP_BannerCharFallback          = (char)entryIdx;
                TEXTDISP_BannerFallbackEntryIndex    =
                    (char)TEXTDISP_CurrentMatchIndex;
                TEXTDISP_BannerFallbackIsSpecialFlag = special;
                bestScore = timeOffset;

            } else {

                if (TEXTDISP_BannerSelectedValidFlag == 0
                    && timeOffset <= 0
                    && timeOffset > altScore
                    && (unsigned short)lastUsage
                           > (unsigned short)title->usage[entryIdx]) {
                    TEXTDISP_BannerCharSelected          = (char)entryIdx;
                    TEXTDISP_BannerSelectedEntryIndex    =
                        (char)TEXTDISP_CurrentMatchIndex;
                    TEXTDISP_BannerSelectedIsSpecialFlag = special;
                }

                if (TEXTDISP_BannerFallbackValidFlag == 0
                    && timeOffset <= 0
                    && timeOffset > altScore) {
                    TEXTDISP_BannerCharFallback          = (char)entryIdx;
                    TEXTDISP_BannerFallbackEntryIndex    =
                        (char)TEXTDISP_CurrentMatchIndex;
                    TEXTDISP_BannerFallbackIsSpecialFlag = special;
                    altScore = timeOffset;
                }
            }

            lastUsage = title->usage[entryIdx];
            lastIdx   = idx;

            if (TEXTDISP_FindModeActiveFlag == 1)
                return 2;
        }

        if (lastIdx == 49 && TEXTDISP_SbeFilterActiveFlag == 0) {
            idx = TEXTDISP_FindEntryMatchIndex(arg, 0L, (long)sptFlag);
            TEXTDISP_BannerFallbackEntryIndex =
                (char)TEXTDISP_CurrentMatchIndex;
            lastIdx = idx;
        }
    }

    if (lastIdx < 49) {

        if (bestScore < 61)
            TEXTDISP_BannerCharSelected = 100;

        if (TEXTDISP_BannerCharSelected == 100)
            return 2;

        if (TEXTDISP_ActiveGroupId != 0)
            title = TEXTDISP_PrimaryTitlePtrTable[
                        (unsigned char)TEXTDISP_BannerSelectedEntryIndex];
        else
            title = TEXTDISP_SecondaryTitlePtrTable[
                        (unsigned char)TEXTDISP_BannerSelectedEntryIndex];

        title->usage[(unsigned char)TEXTDISP_BannerCharSelected]++;

        return 2;
    }

    if (channel > 48 && channel < 58)
        goto setDefault;
    if (channel > 62 && channel < 68)
        goto setDefault;
    if (channel > 71 && channel < 78)
        goto setDefault;

    return 0;

setDefault:
    channel = 68;
    return 1;
}
