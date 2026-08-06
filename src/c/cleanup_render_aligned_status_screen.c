/* RESTORES: CLEANUP_RenderAlignedStatusScreen
 * MODULE:   modules/groups/a/d/cleanup3.s
 * STATUS:   behavioural
 *
 * Builds the aligned status banner and paints it into RastPort 2. 2224 bytes,
 * and it reads as four stages: choose the template text, resolve a one-letter
 * TEMPLATE CODE into a title, compose the line, then render it.
 *
 * The template code is the character in TEXTDISP_Primary/SecondaryChannelCode,
 * defaulting to '0' (48) when zero. Five codes take their own path -- 'E' (69)
 * walks the entry cycle table for the next non-empty title, 'F' (70) and 'G'
 * (71) take the clock entry buffer with the IFF line head or tail as a
 * fallback, 'N' (78) requires the clock entry buffer, and 'O' (79) requires the
 * alt-time buffer. Anything else leaves the copied template text in place.
 *
 * THE MODULE USED TO CARRY TWO LABELS ON ONE ADDRESS:
 * CLEANUP_BuildAndRenderAlignedStatusBanner and
 * CLEANUP_RenderAlignedStatusScreen were the same instruction. The first name is
 * referenced NOWHERE in the program -- checked across src/ -- and while the
 * module exported two labels it could not be swapped for a C object at all,
 * because replacement is per module and gen_all_manifest.py refuses a module with
 * more than one label. The dead alias is therefore RECORDED IN A COMMENT in
 * cleanup3.s and removed from the code. A label and an XDEF emit no bytes, so
 * both gates stayed green across the removal -- verified.
 *
 * The display context's RastPort really starts at offset 10, not 8. Every site
 * in the program writes `Offset_RastPort2_FromDisplayContextBase + 2`, and this
 * function proves the +2 belongs to the offset rather than to the caller: it
 * reads the BitMap pointer at context+14, which is rp_BitMap of a RastPort based
 * at 10. `struct EsqDisplayContext` therefore embeds a real `struct RastPort` at
 * 10, so the depth read is `ctx->rp2.BitMap->Depth` instead of a blind offset.
 *
 * The schedule-label lookup is a pointer table anchored at
 * `SCRIPT_StrChannelLabel_TuesdaysFridays + 2` and indexed by the raw template
 * code. That is a cast on a string label, which AGENTS.md would normally rule
 * out in favour of a struct -- but there is no struct here to describe. The
 * table is a run of longs inside the data section with no label of its own, so
 * the cast IS the description. See the note on SCRIPT_ChannelLabelPtrTable in
 * src/data/script.s.
 *
 * `dateParts` is sized generously at 16 words. The original's frame gives it
 * offsets -34 through -18, i.e. 9 words, but the three DATETIME/DST helpers
 * write into it and this function cannot verify how far they go. Over-sizing a
 * local costs frame bytes and nothing else; under-sizing it would corrupt the
 * neighbouring locals.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                        JSR (d16,PC)
 *   got:     61000000                        BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame-and-large-locals
 *   ref:     4e55fcb8                        LINK.W A5,#-840
 *   got:     A7-relative locals
 *   summary: 840 bytes of locals off A5 in the original, off A7 here. Every one
 *            of the ~120 local accesses carries the difference. The generous
 *            `dateParts` and template buffers add to the frame as well.
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * MEASURED: 2208 emitted against 2224 in the original, i.e. SIXTEEN BYTES SHORT,
 * over 65 regions. Two size-independent checks say the shape is right rather than
 * merely the size:
 *
 *   - `12d866fc` (MOVE.B (A0)+,(A1)+ / BNE) appears SEVENTEEN times in each
 *     stream. Every one of the original's inline string copies is reproduced
 *     verbatim by strcpy, in the same places.
 *   - `4eae` (JSR d16(A6)) appears SEVEN times in each. Same library calls, same
 *     count, so no base reload was added or lost.
 *   - `LEA (d16,An),Am`: reference 2, emitted 0. A deficit, which per AGENTS.md
 *     rule 2 is the safe direction -- nothing is being recomputed that the
 *     original folded.
 *
 * SASC-MISMATCH: unattributed-body-deficit
 *   summary: -16 is NOT itemised, and an UNDERSHOOT deserves more suspicion than
 *            an overshoot: it can mean a block was dropped rather than encoded
 *            differently. What rules that out here is the pair of counts above --
 *            all 17 copies and all 7 library calls survive, and every branch of
 *            the template-code chain is present. The likeliest source is the
 *            frame class, where 6.51's A7-relative epilogue is shorter than
 *            LINK/UNLK plus a 840-byte frame, but that is a candidate and not a
 *            measurement. Recorded as a known-unknown per AGENTS.md rule 3.
 *   tried:   the two structural counts above, in place of source shuffling.
 *   retest:  itemise on a compiler that reserves A5; until then the deficit
 *            cannot be separated from the frame difference.
 */
#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>

#include <string.h>

#include "esq-graphics.h"

struct EsqDisplayContext {
    char  pad0[2];
    short width;                /*  2 */
    short height;               /*  4 */
    char  pad6[4];              /*  6 */
    struct RastPort rp2;        /* 10 -- so rp2.BitMap lands on context+14 */
};

/* The primary-title table entries carry their per-slot title pointers at +56. */
struct TitleEntry {
    char  pad0[56];
    char *titles[1];
};

extern char  TEXTDISP_PrimarySearchText[];
extern char  TEXTDISP_SecondarySearchText[];
extern short TEXTDISP_PrimaryChannelCode;
extern short TEXTDISP_SecondaryChannelCode;
extern short TEXTDISP_ChannelSourceMode;
extern short TEXTDISP_CurrentMatchIndex;
extern short TEXTDISP_CurrentMatchIndexSaved;
extern short TEXTDISP_ActiveGroupId;
extern long  TEXTDISP_ChannelLabelReadyFlag;
extern char  TEXTDISP_ChannelLabelBuffer[];
extern char  TEXTDISP_EntryShortNameScratch[];
extern char  TEXTDISP_LeftAlignToken[];
extern char  TEXTDISP_CenterAlignToken[];
extern short TEXTDISP_LinePenOverrideEnabledFlag;
extern short TEXTDISP_LinePenOverrideStateWord;
extern unsigned char TEXTDISP_BannerCharSelected;
extern unsigned char TEXTDISP_BannerCharFallback;
extern unsigned char TEXTDISP_BannerFallbackIsSpecialFlag;
extern unsigned char TEXTDISP_BannerSelectedIsSpecialFlag;
extern unsigned char TEXTDISP_BannerFallbackValidFlag;
extern unsigned char TEXTDISP_BannerSelectedValidFlag;
extern unsigned char TEXTDISP_PrimaryGroupCode;
extern unsigned char TEXTDISP_SecondaryGroupCode;
extern struct TitleEntry *TEXTDISP_PrimaryTitlePtrTable[];

extern char  CLEANUP_AlignedStatusClockEntryBuffer[];
extern char  CLEANUP_AlignedStatusAltTimeBuffer[];
extern char  CLEANUP_AlignedStatusSuffixBuffer[];
extern short CLEANUP_AlignedStatusMatchIndex;
extern short CLEANUP_AlignedStatusClockEntryIndex;
extern short CLEANUP_AlignedStatusEntryCycleTable[];

extern char  CLOCK_STR_TEMPLATE_CODE_SET_FGN[];
extern short CLOCK_CurrentDayOfYear;
extern char *ESQIFF_PrimaryLineHeadPtr;
extern char *ESQIFF_PrimaryLineTailPtr;
extern short WDISP_AccumulatorFlushPending;
extern struct EsqDisplayContext *WDISP_DisplayContextBase;
extern struct RastPort *Global_REF_RASTPORT_2;
extern struct BitMap Global_REF_320_240_BITMAP;
extern char  SCRIPT_StrChannelLabel_TuesdaysFridays[];

extern char Global_STR_ALIGNED_NOW_SHOWING[];
extern char Global_STR_ALIGNED_NEXT_SHOWING[];
extern char Global_STR_ALIGNED_TODAY_AT[];
extern char Global_STR_ALIGNED_TONIGHT_AT[];
extern char Global_STR_ALIGNED_TOMORROW_AT[];

extern char *STR_FindCharPtr(char *s, long c);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern void  TLIBA1_BuildClockFormatEntryIfVisible(long a, long b,
                                                                   char *buf,
                                                                   long flag);
extern long  DISPLIB_NormalizeValueByStep(long v, long lo, long hi);
extern void  ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void  ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void  ESQ_NoOp(void);
extern void  ESQIFF_RunCopperDropTransition(void);
extern void  ESQIFF_RunCopperRiseTransition(void);
extern struct EsqDisplayContext *TLIBA3_BuildDisplayContextForViewMode(
    long a, long b, long c);
extern void  ESQFUNC_SelectAndApplyBrushForCurrentEntry(long m);
extern void  SCRIPT_UpdateSerialShadowFromCtrlByte(long v);
extern void  TEXTDISP_DrawChannelBanner(long mode, long kind);
extern void *ESQDISP_GetEntryPointerByMode(long idx, long mode);
extern void  TEXTDISP_BuildEntryShortName(void *entry, char *out);
extern void  TEXTDISP_FormatEntryTime(char *out, long idx);
extern void  DST_ComputeBannerIndex(short *parts, long idx,
                                                    long group);
extern void  DATETIME_AdjustMonthIndex(short *parts);
extern void  DATETIME_NormalizeMonthRange(short *parts);
extern void  TEXTDISP_BuildChannelLabel(long v);
extern void  CLEANUP_BuildAlignedStatusLine(char *buf, long group, long match,
                                            long clockEntry, long mode,
                                            long notReady);
extern void  TEXTDISP_TrimTextToPixelWidth(char *s, long px);
extern void  TEXTDISP_DrawInsetRectFrame(char *s, long kind);
extern struct RastPort *TLIBA3_GetViewModeRastPort(long mode);
extern unsigned short TLIBA3_GetViewModeHeight(long mode);
extern void  GRAPHICS_BltBitMapRastPort(struct BitMap *bm,
                                                        long sx, long sy,
                                                        struct RastPort *rp,
                                                        long dx, long dy,
                                                        long w, long h,
                                                        long minterm);

void CLEANUP_RenderAlignedStatusScreen(short mode, short effectCode,
                                       short suppressFlag)
{
    char  templateText[512];
    char  templateBackup[200];
    char  timeText[80];
    short dateParts[16];
    struct RastPort *viewRp;
    struct TitleEntry *titleEntry;
    void *entryPtr;
    char **labelTable;
    long  y1;
    long  bottom;
    short templateCode;
    short titleState;
    short entryCycle;
    short bannerIndex;
    short special;

    TEXTDISP_ChannelSourceMode = mode;
    templateText[0] = 0;
    WDISP_AccumulatorFlushPending = 0;
    titleState = 0;

    if (mode == 1) {
        strcpy(templateText, TEXTDISP_PrimarySearchText);
        templateCode = TEXTDISP_PrimaryChannelCode;
    } else {
        strcpy(templateText, TEXTDISP_SecondarySearchText);
        templateCode = TEXTDISP_SecondaryChannelCode;
    }
    strcpy(templateBackup, templateText);

    if (templateCode == 0)
        templateCode = 48;

    if (STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN,
                                        (long)templateCode) != 0) {
        CLEANUP_AlignedStatusClockEntryBuffer[0] = 0;
        TLIBA1_BuildClockFormatEntryIfVisible(
            (long)CLEANUP_AlignedStatusMatchIndex,
            (long)CLEANUP_AlignedStatusClockEntryIndex,
            CLEANUP_AlignedStatusClockEntryBuffer, 0L);
    } else if (templateCode == 79) {
        CLEANUP_AlignedStatusAltTimeBuffer[0] = 0;
        TLIBA1_BuildClockFormatEntryIfVisible(
            (long)CLEANUP_AlignedStatusMatchIndex,
            (long)CLEANUP_AlignedStatusClockEntryIndex,
            CLEANUP_AlignedStatusAltTimeBuffer, 1L);
    }

    if (templateCode == 69) {
        titleEntry = TEXTDISP_PrimaryTitlePtrTable[TEXTDISP_CurrentMatchIndex];
        entryCycle = CLEANUP_AlignedStatusEntryCycleTable[TEXTDISP_CurrentMatchIndex];
        bannerIndex = 0;

        for (;;) {
            entryCycle = entryCycle + 1;
            entryCycle = (short)DISPLIB_NormalizeValueByStep((long)entryCycle,
                                                             1L, 48L);
            if (entryCycle ==
                CLEANUP_AlignedStatusEntryCycleTable[TEXTDISP_CurrentMatchIndex])
                break;
            if (titleEntry->titles[entryCycle] != 0)
                break;
            if (bannerIndex >= 60)
                break;
            bannerIndex = bannerIndex + 1;
        }

        if (entryCycle ==
                CLEANUP_AlignedStatusEntryCycleTable[TEXTDISP_CurrentMatchIndex] &&
            TEXTDISP_CurrentMatchIndexSaved == TEXTDISP_CurrentMatchIndex)
            return;

        CLEANUP_AlignedStatusEntryCycleTable[TEXTDISP_CurrentMatchIndex] =
            entryCycle;
        strcpy(templateText,
               titleEntry->titles[
                   CLEANUP_AlignedStatusEntryCycleTable[TEXTDISP_CurrentMatchIndex]]);
        titleState = 2;

    } else if (templateCode == 70) {
        if (CLEANUP_AlignedStatusMatchIndex != -1 &&
            CLEANUP_AlignedStatusClockEntryBuffer[0] != 0) {
            strcpy(templateText, CLEANUP_AlignedStatusClockEntryBuffer);
        } else {
            if (ESQIFF_PrimaryLineHeadPtr == 0)
                return;
            strcpy(templateText, ESQIFF_PrimaryLineHeadPtr);
        }
        titleState = 2;

    } else if (templateCode == 71) {
        if (CLEANUP_AlignedStatusMatchIndex != -1 &&
            CLEANUP_AlignedStatusClockEntryBuffer[0] != 0) {
            strcpy(templateText, CLEANUP_AlignedStatusClockEntryBuffer);
        } else {
            if (ESQIFF_PrimaryLineTailPtr == 0)
                return;
            strcpy(templateText, ESQIFF_PrimaryLineTailPtr);
        }
        titleState = 2;

    } else if (templateCode == 78) {
        if (CLEANUP_AlignedStatusMatchIndex == -1)
            return;
        if (CLEANUP_AlignedStatusClockEntryBuffer[0] == 0)
            return;
        strcpy(templateText, CLEANUP_AlignedStatusClockEntryBuffer);
        titleState = 2;

    } else if (templateCode == 79) {
        if (CLEANUP_AlignedStatusMatchIndex == -1)
            return;
        if (CLEANUP_AlignedStatusAltTimeBuffer[0] == 0)
            return;
        strcpy(templateText, CLEANUP_AlignedStatusAltTimeBuffer);
        titleState = 2;
    }

    if (titleState != 2) {
        CLEANUP_AlignedStatusMatchIndex = -1;
        CLEANUP_AlignedStatusClockEntryIndex = -1;
    }

    if (effectCode == 53)
        ESQ_SetCopperEffect_OffDisableHighlight();

    ESQIFF_RunCopperDropTransition();

    SetRast(&WDISP_DisplayContextBase->rp2,
            (1L << WDISP_DisplayContextBase->rp2.BitMap->Depth) - 1);

    if (mode == 0)
        WDISP_DisplayContextBase =
            TLIBA3_BuildDisplayContextForViewMode(1L, 0L, 1L);
    else
        WDISP_DisplayContextBase =
            TLIBA3_BuildDisplayContextForViewMode(0L, 0L, 1L);

    if (suppressFlag == 0)
        ESQFUNC_SelectAndApplyBrushForCurrentEntry((long)mode);

    if (mode == 0) {
        WDISP_DisplayContextBase =
            TLIBA3_BuildDisplayContextForViewMode(1L, 0L, 4L);
        SCRIPT_UpdateSerialShadowFromCtrlByte(2L);
    } else {
        WDISP_DisplayContextBase =
            TLIBA3_BuildDisplayContextForViewMode(0L, 0L, 4L);
        SCRIPT_UpdateSerialShadowFromCtrlByte(1L);
    }

    if (suppressFlag == 1)
        SetRast(Global_REF_RASTPORT_2, 0L);

    ESQ_NoOp();
    SetAPen(Global_REF_RASTPORT_2, 1L);

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;

    if (templateCode == 48 && templateText[0] == 0) {
        TEXTDISP_DrawChannelBanner((long)mode, 3L);
        ESQ_SetCopperEffect_OnEnableHighlight();
        CLEANUP_AlignedStatusSuffixBuffer[0] = 0;
        CLEANUP_AlignedStatusMatchIndex = TEXTDISP_CurrentMatchIndex;
        CLEANUP_AlignedStatusClockEntryIndex = -1;
        return;
    }

    if (TEXTDISP_BannerCharSelected == 100)
        bannerIndex = TEXTDISP_BannerCharFallback;
    else
        bannerIndex = TEXTDISP_BannerCharSelected;

    if (bannerIndex < 49 && templateText[0] != 0) {
        CLEANUP_AlignedStatusMatchIndex = TEXTDISP_CurrentMatchIndex;
        CLEANUP_AlignedStatusClockEntryIndex = bannerIndex;
        titleState = 1;
    } else if (titleState != 2) {
        CLEANUP_AlignedStatusSuffixBuffer[0] = 0;
        CLEANUP_AlignedStatusMatchIndex = TEXTDISP_CurrentMatchIndex;
        CLEANUP_AlignedStatusClockEntryIndex = -1;
    }

    if (titleState == 2) {
        TEXTDISP_ChannelLabelBuffer[0] = 0;
    } else {
        entryPtr = ESQDISP_GetEntryPointerByMode(
            (long)TEXTDISP_CurrentMatchIndex,
            TEXTDISP_ActiveGroupId != 0 ? 1L : 2L);
        TEXTDISP_BuildEntryShortName(
            entryPtr, TEXTDISP_EntryShortNameScratch);
        strcpy(TEXTDISP_ChannelLabelBuffer, TEXTDISP_EntryShortNameScratch);
    }

    if (templateText[0] != 0)
        STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer,
                                            TEXTDISP_LeftAlignToken);
    STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer,
                                        templateText);

    if (titleState == 1) {
        if (TEXTDISP_BannerCharSelected == 100)
            special = TEXTDISP_BannerFallbackIsSpecialFlag;
        else
            special = TEXTDISP_BannerSelectedIsSpecialFlag;

        if (special != 0) {
            strcpy(CLEANUP_AlignedStatusSuffixBuffer,
                   Global_STR_ALIGNED_NOW_SHOWING);

            if (TEXTDISP_BannerCharSelected == 100)
                special = TEXTDISP_BannerFallbackValidFlag;
            else
                special = TEXTDISP_BannerSelectedValidFlag;

            if (special != 0) {
                STRING_AppendAtNull(
                    TEXTDISP_ChannelLabelBuffer,
                    CLEANUP_AlignedStatusSuffixBuffer);
                strcpy(CLEANUP_AlignedStatusSuffixBuffer,
                       Global_STR_ALIGNED_NEXT_SHOWING);
                TEXTDISP_FormatEntryTime(timeText,
                                                         (long)bannerIndex);
                STRING_AppendAtNull(
                    CLEANUP_AlignedStatusSuffixBuffer, timeText);
            }
        } else {
            DST_ComputeBannerIndex(
                dateParts, (long)bannerIndex,
                TEXTDISP_ActiveGroupId != 0 ? (long)TEXTDISP_PrimaryGroupCode
                                            : (long)TEXTDISP_SecondaryGroupCode);
            DATETIME_AdjustMonthIndex(dateParts);

            if (dateParts[8] != CLOCK_CurrentDayOfYear) {
                strcpy(CLEANUP_AlignedStatusSuffixBuffer,
                       Global_STR_ALIGNED_TOMORROW_AT);
            } else if (dateParts[4] < 17 ||
                       (dateParts[4] == 17 && dateParts[5] < 30)) {
                strcpy(CLEANUP_AlignedStatusSuffixBuffer,
                       Global_STR_ALIGNED_TODAY_AT);
            } else {
                strcpy(CLEANUP_AlignedStatusSuffixBuffer,
                       Global_STR_ALIGNED_TONIGHT_AT);
            }

            DATETIME_NormalizeMonthRange(dateParts);
            TEXTDISP_FormatEntryTime(timeText,
                                                     (long)bannerIndex);
            STRING_AppendAtNull(
                CLEANUP_AlignedStatusSuffixBuffer, timeText);
        }

        STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer,
                                            CLEANUP_AlignedStatusSuffixBuffer);

    } else if (titleState != 2 &&
               ((templateCode > 48 && templateCode <= 67) ||
                (templateCode >= 72 && templateCode <= 77))) {
        strcpy(CLEANUP_AlignedStatusSuffixBuffer, TEXTDISP_CenterAlignToken);
        labelTable = (char **)&SCRIPT_StrChannelLabel_TuesdaysFridays[2];
        STRING_AppendAtNull(CLEANUP_AlignedStatusSuffixBuffer,
                                            labelTable[templateCode]);
        STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer,
                                            CLEANUP_AlignedStatusSuffixBuffer);
    }

    if (titleState != 2 || templateCode == 70 || templateCode == 71 ||
        templateCode == 78 || templateCode == 79) {
        TEXTDISP_BuildChannelLabel(0L);
        CLEANUP_BuildAlignedStatusLine(TEXTDISP_ChannelLabelBuffer,
                                       (long)TEXTDISP_ActiveGroupId,
                                       (long)CLEANUP_AlignedStatusMatchIndex,
                                       (long)CLEANUP_AlignedStatusClockEntryIndex,
                                       titleState == 2 ? 1L : 0L,
                                       !TEXTDISP_ChannelLabelReadyFlag);
        if (titleState == 2)
            STRING_AppendAtNull(
                TEXTDISP_ChannelLabelBuffer, CLEANUP_AlignedStatusSuffixBuffer);
    }

    TEXTDISP_BannerCharSelected = 'd';
    TEXTDISP_BannerCharFallback = '1';
    TEXTDISP_LinePenOverrideStateWord = 0;

    SetDrMd(Global_REF_RASTPORT_2, 0L);
    TEXTDISP_LinePenOverrideEnabledFlag = 1;
    TEXTDISP_TrimTextToPixelWidth(
        TEXTDISP_ChannelLabelBuffer, (long)WDISP_DisplayContextBase->width);
    TEXTDISP_DrawInsetRectFrame(TEXTDISP_ChannelLabelBuffer, 3L);
    SetDrMd(Global_REF_RASTPORT_2, 1L);

    viewRp = TLIBA3_GetViewModeRastPort(2L);
    SetAPen(viewRp, 0L);
    y1 = (long)TLIBA3_GetViewModeHeight(2L) / 2;
    bottom = (long)TLIBA3_GetViewModeHeight(2L) - 1;
    RectFill(viewRp, 0L, y1, 703L, bottom);

    ESQ_SetCopperEffect_OnEnableHighlight();

    GRAPHICS_BltBitMapRastPort(
        &Global_REF_320_240_BITMAP, 0L, 0L, &WDISP_DisplayContextBase->rp2,
        0L, 0L, (long)WDISP_DisplayContextBase->width - 1,
        (long)WDISP_DisplayContextBase->height - 1, 192L);

    ESQIFF_RunCopperRiseTransition();
}
