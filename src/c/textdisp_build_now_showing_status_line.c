/* RESTORES: TEXTDISP_BuildNowShowingStatusLine
 * MODULE:   modules/groups/b/a/textdisp_textdisp_buildnowshowingstatusline.s
 * STATUS:   behavioural
 *
 * Builds the aligned "Now Showing" status line and hands it to the highlight
 * effect. 812 bytes, and three mutually exclusive ways to fill the line:
 *
 *   1. The channel is ENABLED FOR TODAY and the entry falls inside the time
 *      window -- emit either the "Now Showing" label or the formatted entry time.
 *   2. Otherwise, if the channel code is in one of two ranges, emit that channel's
 *      label from the pointer table.
 *   3. Otherwise nothing, and `skipTitle` stays set so the whole title-building
 *      block below is skipped.
 *
 * THE DAY-ENABLED TEST IS A BITMASK PER CHANNEL CODE:
 * `Global_STR_TEXTDISP_C_3[code] & (1 << dayOfWeek)`. The table is indexed by the
 * raw character code, not by a channel number, so codes 48..67 and 72..77 index
 * into it directly.
 *
 * THE TWO RANGE TESTS ARE NOT THE SAME. The enabled test accepts code >= 48; the
 * fallback test accepts code > 48. So code 48 exactly can reach path 1 but never
 * path 2. That asymmetry is in the original and is easy to normalise away by
 * accident.
 *
 * THE PROGRAM TITLE IS COPIED WITH SPACES REMOVED, one byte at a time, from
 * entry+1. It is not a strcpy and not a strncpy: every 0x20 is dropped, so the two
 * indices advance at different rates. That is why the loop is written out.
 *
 * MEASURED: 816 emitted against 812 in the original, +4 over 29 regions.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....              JSR (d16,PC)
 *   got:     61000000              BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame-and-large-locals
 *   ref:     4e55ff28 ... 4e5d     LINK.W A5,#-216 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: channel-label-table-cast
 *   ref:     LEA (SCRIPT_StrChannelLabel_TuesdaysFridays+2),A0
 *   got:     a cast on the string label
 *   summary: the channel labels are a run of longs anchored two bytes into a string
 *            label, with no label of their own -- the same anonymous table
 *            cleanup_render_aligned_status_screen.c uses. There is no struct to
 *            describe it, so the cast IS the description.
 *   scope:   every reader of that table.
 *   retest:  n/a; it needs a label in src/data/script.s, not a compiler.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: NOT itemised. Recorded as a known-unknown per AGENTS.md rule 3.
 *   retest:  itemise again on a compiler that reserves A5.
 */
#include <exec/types.h>
#include <string.h>

struct DkTitle {
    char          pad0[7];      /*   0 */
    unsigned char slotFlag[49]; /*   7 */
    char         *slotText[49]; /*  56 */
    unsigned char extA[49];     /* 252 */
    unsigned char extB[49];     /* 301 */
    unsigned char extC[49];     /* 350 */
    char          pad399[101];  /* 399 */
};

extern short TEXTDISP_PrimaryChannelCode;
extern char  TEXTDISP_PrimarySearchText[];
extern unsigned char TEXTDISP_BannerCharSelected;
extern unsigned char TEXTDISP_BannerSelectedIsSpecialFlag;
extern unsigned char TEXTDISP_BannerFallbackIsSpecialFlag;
extern short CLOCK_CurrentDayOfWeekIndex;
extern long  CONFIG_TimeWindowMinutes;
extern char *P_TYPE_WeatherBottomLineMsgPtr;
extern unsigned char Global_STR_TEXTDISP_C_3[];
extern char  Global_STR_ALIGNED_NOW_SHOWING[];
extern char  SCRIPT_AlignedPrefixEmptyA[];
extern char  SCRIPT_AlignedPrefixEmptyB[];
extern char  SCRIPT_AlignedPrefixEmptyC[];
extern char  SCRIPT_AlignedChannelAbbrevPrefix[];
extern char  SCRIPT_AlignedCharFormat[];
extern char  SCRIPT_SpacerTripleA[];
extern char  SCRIPT_SpacerTripleB[];
extern char  SCRIPT_StrChannelLabel_TuesdaysFridays[];

extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(long idx, long kind);
extern void *TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(long idx, long kind);
extern long  TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(void *entry, void *aux,
                                                         long idx, long span,
                                                         long window);
extern void  TEXTDISP_FormatEntryTimeForIndex(char *buf, long idx, void *aux);
extern char *STR_SkipClass3Chars(char *s);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern char *TEXTDISP_FindControlToken(char *s);
extern void  WDISP_SPrintf(char *dst, char *fmt, long a);
extern void  TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(char *line, long a,
                                                            long b, long c,
                                                            long d, long e);
extern void  SCRIPT_SetupHighlightEffect(char *line);

void TEXTDISP_BuildNowShowingStatusLine(short mode, short index, short slot)
{
    char  line[137];
    char  scratch[51];
    struct DkTitle *aux;
    char *entry;
    char *titlePtr;
    char *token;
    char **labelTable;
    long  skipTitle;
    long  special;
    long  channelEnabled;
    long  srcIdx;
    long  dstIdx;
    short code;

    token = 0;
    skipTitle = 1;

    aux = (struct DkTitle *)TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(
        (long)index, mode != 0 ? 1L : 2L);
    entry = (char *)TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(
        (long)index, mode != 0 ? 1L : 2L);

    if (entry == 0 || aux == 0) {
        if (P_TYPE_WeatherBottomLineMsgPtr != 0 &&
            *P_TYPE_WeatherBottomLineMsgPtr != 0) {
            strcpy(line, SCRIPT_AlignedPrefixEmptyC);
            STRING_AppendAtNull(line, P_TYPE_WeatherBottomLineMsgPtr);
        } else {
            line[0] = 0;
        }
        SCRIPT_SetupHighlightEffect(line);
        return;
    }

    if (TEXTDISP_PrimaryChannelCode == 0)
        TEXTDISP_PrimaryChannelCode = 48;

    line[0] = 0;

    code = TEXTDISP_PrimaryChannelCode;
    if ((code >= 48 && code <= 67) || (code >= 72 && code <= 77))
        channelEnabled =
            (Global_STR_TEXTDISP_C_3[code] &
             (1L << CLOCK_CurrentDayOfWeekIndex)) != 0;
    else
        channelEnabled = 0;

    if (channelEnabled != 0 && slot > 0 && slot < 49 &&
        TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(entry, aux, (long)slot,
                                                    1440L,
                                                    CONFIG_TimeWindowMinutes) !=
            0) {
        if (TEXTDISP_BannerCharSelected == 100)
            special = TEXTDISP_BannerFallbackIsSpecialFlag;
        else
            special = TEXTDISP_BannerSelectedIsSpecialFlag;

        if (special == 1) {
            strcpy(scratch, Global_STR_ALIGNED_NOW_SHOWING);
            titlePtr = scratch;
        } else {
            TEXTDISP_FormatEntryTimeForIndex(scratch, (long)slot, aux);
            titlePtr = STR_SkipClass3Chars(scratch);
        }

        strcpy(line, SCRIPT_AlignedPrefixEmptyA);
        STRING_AppendAtNull(line, titlePtr);
        token = TEXTDISP_FindControlToken(aux->slotText[slot]);
        skipTitle = 0;

    } else {
        code = TEXTDISP_PrimaryChannelCode;
        if ((code > 48 && code <= 67) || (code >= 72 && code <= 77)) {
            strcpy(line, SCRIPT_AlignedPrefixEmptyB);
            labelTable =
                (char **)&SCRIPT_StrChannelLabel_TuesdaysFridays[2];
            STRING_AppendAtNull(line, labelTable[code]);
            token = TEXTDISP_FindControlToken(TEXTDISP_PrimarySearchText);
            skipTitle = 0;
        }
    }

    if (skipTitle == 0) {
        /* Copy the programme title with every space dropped. */
        srcIdx = dstIdx = 0;
        while (entry[1 + srcIdx] != 0) {
            if (entry[1 + srcIdx] != 32)
                scratch[dstIdx++] = entry[1 + srcIdx];
            srcIdx = srcIdx + 1;
        }
        scratch[dstIdx] = 0;

        if (scratch[0] != 0) {
            if (line[0] != 0)
                STRING_AppendAtNull(line, SCRIPT_SpacerTripleA);
            STRING_AppendAtNull(line, SCRIPT_AlignedChannelAbbrevPrefix);
            STRING_AppendAtNull(line, scratch);
        }

        if (token != 0) {
            if (line[0] != 0)
                STRING_AppendAtNull(line, SCRIPT_SpacerTripleB);
            WDISP_SPrintf(scratch, SCRIPT_AlignedCharFormat,
                          (long)(unsigned char)*token);
            STRING_AppendAtNull(line, scratch);
        }

        TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(line, (long)mode,
                                                       (long)index, (long)slot,
                                                       0L, 0L);
    }

    SCRIPT_SetupHighlightEffect(line);
}
