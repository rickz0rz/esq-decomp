#include <exec/types.h>

#define CLEANUP3_STATE_NONE 0
#define CLEANUP3_STATE_SELECTED 1
#define CLEANUP3_STATE_TEMPLATE_OVERRIDE 2

#define CLEANUP3_SOURCE_SECONDARY 0
#define CLEANUP3_SOURCE_PRIMARY 1

#define CLEANUP3_TEMPLATE_CODE_0 '0'
#define CLEANUP3_TEMPLATE_CODE_E 'E'
#define CLEANUP3_TEMPLATE_CODE_F 'F'
#define CLEANUP3_TEMPLATE_CODE_G 'G'
#define CLEANUP3_TEMPLATE_CODE_N 'N'
#define CLEANUP3_TEMPLATE_CODE_O 'O'

#define CLEANUP3_BANNER_CHAR_NONE 100
#define CLEANUP3_SLOT_COUNT 48
#define CLEANUP3_MAX_SCAN_RETRIES 60
#define CLEANUP3_VIEWMODE_PRIMARY 0
#define CLEANUP3_VIEWMODE_SECONDARY 1
#define CLEANUP3_VIEWCFG_PLAIN 1
#define CLEANUP3_VIEWCFG_HILITE 4
#define CLEANUP3_DRAWMODE_JAM1 0
#define CLEANUP3_DRAWMODE_COMPLEMENT 1
#define CLEANUP3_BLIT_MINTERM_COPY 192
#define CLEANUP3_FILL_MAX_X 703
#define CLEANUP3_DRAWMODE_FRAME 3

typedef struct CLEANUP3_DisplayContext {
    UBYTE pad0[2];
    UWORD width2;
    UWORD height4;
    UBYTE pad6[8];
    void *bitmap14;
} CLEANUP3_DisplayContext;

typedef struct CLEANUP3_BitMapLike {
    UBYTE pad0[5];
    UBYTE depth5;
} CLEANUP3_BitMapLike;

typedef struct CLEANUP3_DateTimeScratch {
    UBYTE pad0[8];
    WORD month8;
    WORD dayOfYear10;
    UBYTE pad12[6];
    WORD overflow18;
    UBYTE pad20[4];
    WORD hour24;
    WORD minute26;
} CLEANUP3_DateTimeScratch;

extern char TEXTDISP_PrimarySearchText[];
extern char TEXTDISP_SecondarySearchText[];
extern WORD TEXTDISP_PrimaryChannelCode;
extern WORD TEXTDISP_SecondaryChannelCode;
extern WORD TEXTDISP_ChannelSourceMode;
extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD TEXTDISP_CurrentMatchIndexSaved;
extern WORD TEXTDISP_ActiveGroupId;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern char TEXTDISP_ChannelLabelBuffer[];
extern char TEXTDISP_EntryShortNameScratch[];
extern LONG TEXTDISP_ChannelLabelReadyFlag;
extern WORD TEXTDISP_LinePenOverrideStateWord;
extern WORD TEXTDISP_LinePenOverrideEnabledFlag;
extern UBYTE TEXTDISP_BannerCharFallback;
extern UBYTE TEXTDISP_BannerCharSelected;
extern UBYTE TEXTDISP_BannerFallbackIsSpecialFlag;
extern UBYTE TEXTDISP_BannerSelectedIsSpecialFlag;
extern UBYTE TEXTDISP_BannerFallbackValidFlag;
extern UBYTE TEXTDISP_BannerSelectedValidFlag;
extern const char TEXTDISP_CenterAlignToken[];
extern const char TEXTDISP_LeftAlignToken[];
extern const char *TEXTDISP_PrimaryTitlePtrTable[];

extern char CLEANUP_AlignedStatusSuffixBuffer[];
extern char CLEANUP_AlignedStatusClockEntryBuffer[];
extern char CLEANUP_AlignedStatusAltTimeBuffer[];
extern WORD CLEANUP_AlignedStatusMatchIndex;
extern WORD CLEANUP_AlignedStatusClockEntryIndex;
extern UWORD CLEANUP_AlignedStatusEntryCycleTable[];

extern LONG WDISP_DisplayContextBase;
extern WORD WDISP_AccumulatorFlushPending;
extern char *Global_REF_RASTPORT_2;
/* Global_REF_320_240_BITMAP is the BitMap STRUCT (wdisp.s, InitBitMap'd in-place);
   BltBitMapRastPort needs its ADDRESS. Declaring it void* + passing by value gave the
   blitter a garbage source bitmap -> wild blit. Array decays to the address. */
extern char Global_REF_320_240_BITMAP[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern char *ESQIFF_PrimaryLineHeadPtr;
extern char *ESQIFF_PrimaryLineTailPtr;

extern WORD CLOCK_CurrentDayOfYear;
extern const char CLOCK_STR_TEMPLATE_CODE_SET_FGN[];
extern const UBYTE SCRIPT_StrChannelLabel_TuesdaysFridays[];
extern const char Global_STR_ALIGNED_NOW_SHOWING[];
extern const char Global_STR_ALIGNED_NEXT_SHOWING[];
extern const char Global_STR_ALIGNED_TOMORROW_AT[];
extern const char Global_STR_ALIGNED_TODAY_AT[];
extern const char Global_STR_ALIGNED_TONIGHT_AT[];

extern char *STR_FindCharPtr(const char *s, LONG c);
extern WORD TLIBA1_BuildClockFormatEntryIfVisible(WORD groupIndex, WORD modeIndex, char *outText, WORD style);
extern LONG DISPLIB_NormalizeValueByStep(WORD value, WORD lowerBound, WORD step);
extern const char *ESQDISP_GetEntryPointerByMode(LONG index, LONG mode);
extern void TEXTDISP_BuildEntryShortName(const char *entry, char *out);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern LONG DST_ComputeBannerIndex(void *ctx, WORD lane, UBYTE slot_hint);
extern LONG DATETIME_AdjustMonthIndex(void *ctx);
extern LONG DATETIME_NormalizeMonthRange(void *ctx);
extern void TEXTDISP_FormatEntryTime(char *out, WORD entryIndex);
extern void TEXTDISP_BuildChannelLabel(WORD includeOnPrefix);
extern void CLEANUP_BuildAlignedStatusLine(char *out, LONG activeGroupId, LONG matchIndex, LONG clockEntryIndex, LONG alignToken, LONG missingChannelLabel);
extern void TEXTDISP_DrawChannelBanner(WORD mode, WORD drawMode);
extern void TEXTDISP_TrimTextToPixelWidth(char *text, LONG maxWidth);
extern void TEXTDISP_DrawInsetRectFrame(const char *text, WORD mode);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2);
extern LONG ESQFUNC_SelectAndApplyBrushForCurrentEntry(WORD useSecondarySelection);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte);
extern void ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void ESQIFF_RunCopperDropTransition(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void ESQ_NoOp(void);
extern char *TLIBA3_GetViewModeRastPort(LONG viewModeIndex);
extern LONG TLIBA3_GetViewModeHeight(LONG viewModeIndex);
extern LONG GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void *bitMap, LONG sx, LONG sy, char *rastPort, LONG dx, LONG dy, LONG width, LONG height, LONG minterm, LONG mask);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVORectFill(void *gfxBase, char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);

static void CLEANUP3_CopyString(char *dst, const char *src)
{
    do {
        *dst++ = *src;
    } while (*src++ != 0);
}

static void CLEANUP3_ClearString(char *dst)
{
    dst[0] = 0;
}

static LONG CLEANUP3_GetViewModeFromSource(UWORD sourceMode)
{
    return (sourceMode == 0) ? CLEANUP3_VIEWMODE_SECONDARY : CLEANUP3_VIEWMODE_PRIMARY;
}

static void CLEANUP3_PrepareClockBuffers(WORD channelCode)
{
    if (STR_FindCharPtr(CLOCK_STR_TEMPLATE_CODE_SET_FGN, (LONG)channelCode) != 0) {
        CLEANUP3_ClearString(CLEANUP_AlignedStatusClockEntryBuffer);
        TLIBA1_BuildClockFormatEntryIfVisible(
            CLEANUP_AlignedStatusMatchIndex,
            CLEANUP_AlignedStatusClockEntryIndex,
            CLEANUP_AlignedStatusClockEntryBuffer,
            0);
    } else if (channelCode == CLEANUP3_TEMPLATE_CODE_O) {
        CLEANUP3_ClearString(CLEANUP_AlignedStatusAltTimeBuffer);
        TLIBA1_BuildClockFormatEntryIfVisible(
            CLEANUP_AlignedStatusMatchIndex,
            CLEANUP_AlignedStatusClockEntryIndex,
            CLEANUP_AlignedStatusAltTimeBuffer,
            1);
    }
}

void CLEANUP_BuildAndRenderAlignedStatusBanner(UWORD sourceMode, UWORD modeSel, UWORD slot)
{
    char templateText[200];
    WORD channelCode;
    WORD state;
    WORD selectedIndex;
    CLEANUP3_DateTimeScratch timeCtx;
    CLEANUP3_DisplayContext *context;
    char *rastPort;
    LONG viewMode;
    LONG midY;
    LONG bottomY;

    TEXTDISP_ChannelSourceMode = sourceMode;
    CLEANUP3_ClearString(templateText);
    WDISP_AccumulatorFlushPending = 0;
    state = CLEANUP3_STATE_NONE;

    if (sourceMode == CLEANUP3_SOURCE_PRIMARY) {
        CLEANUP3_CopyString(templateText, TEXTDISP_PrimarySearchText);
        channelCode = TEXTDISP_PrimaryChannelCode;
    } else {
        CLEANUP3_CopyString(templateText, TEXTDISP_SecondarySearchText);
        channelCode = TEXTDISP_SecondaryChannelCode;
    }

    if (channelCode == 0) {
        channelCode = CLEANUP3_TEMPLATE_CODE_0;
    }

    CLEANUP3_PrepareClockBuffers(channelCode);

    if (channelCode == CLEANUP3_TEMPLATE_CODE_E) {
        const UBYTE *entryBase;
        WORD entryCycle;
        WORD attempts;

        entryBase = (const UBYTE *)TEXTDISP_PrimaryTitlePtrTable[(UWORD)TEXTDISP_CurrentMatchIndex];
        entryCycle = (WORD)CLEANUP_AlignedStatusEntryCycleTable[(UWORD)TEXTDISP_CurrentMatchIndex];
        attempts = 0;

        for (;;) {
            entryCycle = (WORD)DISPLIB_NormalizeValueByStep(
                (WORD)(entryCycle + 1),
                1,
                CLEANUP3_SLOT_COUNT);

            if (entryCycle == (WORD)CLEANUP_AlignedStatusEntryCycleTable[(UWORD)TEXTDISP_CurrentMatchIndex]) {
                break;
            }

            if (*(char **)(entryBase + 56 + ((LONG)entryCycle * 4)) != 0) {
                break;
            }

            if (attempts >= CLEANUP3_MAX_SCAN_RETRIES) {
                break;
            }
            ++attempts;
        }

        if (entryCycle != (WORD)CLEANUP_AlignedStatusEntryCycleTable[(UWORD)TEXTDISP_CurrentMatchIndex] ||
            TEXTDISP_CurrentMatchIndexSaved != TEXTDISP_CurrentMatchIndex) {
            CLEANUP_AlignedStatusEntryCycleTable[(UWORD)TEXTDISP_CurrentMatchIndex] = (UWORD)entryCycle;
            CLEANUP3_CopyString(
                templateText,
                *(char **)(entryBase + 56 + ((LONG)entryCycle * 4)));
            state = CLEANUP3_STATE_TEMPLATE_OVERRIDE;
        }
    } else if (channelCode == CLEANUP3_TEMPLATE_CODE_F) {
        if (CLEANUP_AlignedStatusMatchIndex == -1) {
            goto done;
        }
        if (CLEANUP_AlignedStatusClockEntryBuffer[0] == 0) {
            if (ESQIFF_PrimaryLineHeadPtr == 0) {
                goto done;
            }
            CLEANUP3_CopyString(templateText, ESQIFF_PrimaryLineHeadPtr);
        } else {
            CLEANUP3_CopyString(templateText, CLEANUP_AlignedStatusClockEntryBuffer);
        }
        state = CLEANUP3_STATE_TEMPLATE_OVERRIDE;
    } else if (channelCode == CLEANUP3_TEMPLATE_CODE_G) {
        if (CLEANUP_AlignedStatusMatchIndex == -1) {
            goto done;
        }
        if (CLEANUP_AlignedStatusClockEntryBuffer[0] == 0) {
            if (ESQIFF_PrimaryLineTailPtr == 0) {
                goto done;
            }
            CLEANUP3_CopyString(templateText, ESQIFF_PrimaryLineTailPtr);
        } else {
            CLEANUP3_CopyString(templateText, CLEANUP_AlignedStatusClockEntryBuffer);
        }
        state = CLEANUP3_STATE_TEMPLATE_OVERRIDE;
    } else if (channelCode == CLEANUP3_TEMPLATE_CODE_N) {
        if (CLEANUP_AlignedStatusMatchIndex == -1) {
            goto done;
        }
        if (CLEANUP_AlignedStatusClockEntryBuffer[0] == 0) {
            goto done;
        }
        CLEANUP3_CopyString(templateText, CLEANUP_AlignedStatusClockEntryBuffer);
        state = CLEANUP3_STATE_TEMPLATE_OVERRIDE;
    } else if (channelCode == CLEANUP3_TEMPLATE_CODE_O) {
        if (CLEANUP_AlignedStatusMatchIndex == -1) {
            goto done;
        }
        if (CLEANUP_AlignedStatusAltTimeBuffer[0] == 0) {
            goto done;
        }
        CLEANUP3_CopyString(templateText, CLEANUP_AlignedStatusAltTimeBuffer);
        state = CLEANUP3_STATE_TEMPLATE_OVERRIDE;
    }

    if (state != CLEANUP3_STATE_TEMPLATE_OVERRIDE) {
        CLEANUP_AlignedStatusMatchIndex = -1;
        CLEANUP_AlignedStatusClockEntryIndex = -1;
    }

    if (modeSel == 53) {
        ESQ_SetCopperEffect_OffDisableHighlight();
    }

    ESQIFF_RunCopperDropTransition();

    context = (CLEANUP3_DisplayContext *)WDISP_DisplayContextBase;
    if (context != 0 && context->bitmap14 != 0) {
        CLEANUP3_BitMapLike *bitMap = (CLEANUP3_BitMapLike *)context->bitmap14;
        LONG clearMask = (1L << (LONG)bitMap->depth5) - 1;
        _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, (char *)((UBYTE *)context + 2), clearMask);
    }

    viewMode = CLEANUP3_GetViewModeFromSource(sourceMode);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(viewMode, 0, CLEANUP3_VIEWCFG_PLAIN);

    if (slot == 0) {
        ESQFUNC_SelectAndApplyBrushForCurrentEntry(sourceMode);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(viewMode, 0, CLEANUP3_VIEWCFG_HILITE);
    SCRIPT_UpdateSerialShadowFromCtrlByte((UBYTE)((sourceMode == 0) ? 2 : 1));

    if (slot == 1) {
        _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, 0);
    }

    ESQ_NoOp();
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, 1);

    TEXTDISP_CurrentMatchIndexSaved = TEXTDISP_CurrentMatchIndex;

    if (channelCode == CLEANUP3_TEMPLATE_CODE_0 && templateText[0] == 0) {
        TEXTDISP_DrawChannelBanner(sourceMode, CLEANUP3_DRAWMODE_FRAME);
        ESQ_SetCopperEffect_OnEnableHighlight();
        CLEANUP3_ClearString(CLEANUP_AlignedStatusSuffixBuffer);
        CLEANUP_AlignedStatusMatchIndex = TEXTDISP_CurrentMatchIndex;
        CLEANUP_AlignedStatusClockEntryIndex = -1;
        goto done;
    }

    if (TEXTDISP_BannerCharSelected != CLEANUP3_BANNER_CHAR_NONE) {
        selectedIndex = (WORD)(UBYTE)TEXTDISP_BannerCharSelected;
    } else {
        selectedIndex = (WORD)(UBYTE)TEXTDISP_BannerCharFallback;
    }

    if (selectedIndex < 49 && templateText[0] != 0) {
        CLEANUP_AlignedStatusMatchIndex = TEXTDISP_CurrentMatchIndex;
        CLEANUP_AlignedStatusClockEntryIndex = selectedIndex;
        state = CLEANUP3_STATE_SELECTED;
    } else if (state != CLEANUP3_STATE_TEMPLATE_OVERRIDE) {
        CLEANUP3_ClearString(CLEANUP_AlignedStatusSuffixBuffer);
        CLEANUP_AlignedStatusMatchIndex = TEXTDISP_CurrentMatchIndex;
        CLEANUP_AlignedStatusClockEntryIndex = -1;
    }

    if (state != CLEANUP3_STATE_TEMPLATE_OVERRIDE) {
        const char *entry;
        LONG entryMode;

        entryMode = (TEXTDISP_ActiveGroupId != 0) ? 1 : 2;
        entry = ESQDISP_GetEntryPointerByMode((LONG)TEXTDISP_CurrentMatchIndex, entryMode);
        TEXTDISP_BuildEntryShortName(entry, TEXTDISP_EntryShortNameScratch);
        CLEANUP3_CopyString(TEXTDISP_ChannelLabelBuffer, TEXTDISP_EntryShortNameScratch);
    } else {
        CLEANUP3_ClearString(TEXTDISP_ChannelLabelBuffer);
    }

    if (templateText[0] != 0) {
        STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, TEXTDISP_LeftAlignToken);
    }
    STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, templateText);

    if (state == CLEANUP3_STATE_SELECTED) {
        LONG specialFlag;

        if (TEXTDISP_BannerCharSelected != CLEANUP3_BANNER_CHAR_NONE) {
            specialFlag = (LONG)(UBYTE)TEXTDISP_BannerSelectedIsSpecialFlag;
        } else {
            specialFlag = (LONG)(UBYTE)TEXTDISP_BannerFallbackIsSpecialFlag;
        }

        if (specialFlag != 0) {
            CLEANUP3_CopyString(CLEANUP_AlignedStatusSuffixBuffer, Global_STR_ALIGNED_NOW_SHOWING);

            if (TEXTDISP_BannerCharSelected != CLEANUP3_BANNER_CHAR_NONE) {
                specialFlag = (LONG)(UBYTE)TEXTDISP_BannerSelectedValidFlag;
            } else {
                specialFlag = (LONG)(UBYTE)TEXTDISP_BannerFallbackValidFlag;
            }

            if (specialFlag != 0) {
                char timeBuffer[80];

                STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, CLEANUP_AlignedStatusSuffixBuffer);
                CLEANUP3_CopyString(CLEANUP_AlignedStatusSuffixBuffer, Global_STR_ALIGNED_NEXT_SHOWING);
                TEXTDISP_FormatEntryTime(timeBuffer, selectedIndex);
                STRING_AppendAtNull(CLEANUP_AlignedStatusSuffixBuffer, timeBuffer);
            }
        } else {
            LONG groupCode;
            char timeBuffer[80];

            if (TEXTDISP_ActiveGroupId != 0) {
                groupCode = (LONG)(UBYTE)TEXTDISP_PrimaryGroupCode;
            } else {
                groupCode = (LONG)(UBYTE)TEXTDISP_SecondaryGroupCode;
            }

            DST_ComputeBannerIndex(&timeCtx, (WORD)selectedIndex, (UBYTE)groupCode);
            DATETIME_AdjustMonthIndex(&timeCtx);

            if (timeCtx.dayOfYear10 != CLOCK_CurrentDayOfYear) {
                CLEANUP3_CopyString(CLEANUP_AlignedStatusSuffixBuffer, Global_STR_ALIGNED_TOMORROW_AT);
            } else if (timeCtx.hour24 < 17 || (timeCtx.hour24 == 17 && timeCtx.minute26 < 30)) {
                CLEANUP3_CopyString(CLEANUP_AlignedStatusSuffixBuffer, Global_STR_ALIGNED_TODAY_AT);
            } else {
                CLEANUP3_CopyString(CLEANUP_AlignedStatusSuffixBuffer, Global_STR_ALIGNED_TONIGHT_AT);
            }

            DATETIME_NormalizeMonthRange(&timeCtx);
            TEXTDISP_FormatEntryTime(timeBuffer, selectedIndex);
            STRING_AppendAtNull(CLEANUP_AlignedStatusSuffixBuffer, timeBuffer);
        }

        STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, CLEANUP_AlignedStatusSuffixBuffer);
    } else if (state != CLEANUP3_STATE_TEMPLATE_OVERRIDE) {
        if ((channelCode > CLEANUP3_TEMPLATE_CODE_0 && channelCode <= 'C') ||
            (channelCode >= 'H' && channelCode <= 'M')) {
            STRING_AppendAtNull(CLEANUP_AlignedStatusSuffixBuffer, TEXTDISP_CenterAlignToken);
            STRING_AppendAtNull(
                CLEANUP_AlignedStatusSuffixBuffer,
                ((const char **)(SCRIPT_StrChannelLabel_TuesdaysFridays + 2))[channelCode]);
            STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, CLEANUP_AlignedStatusSuffixBuffer);
        }
    }

    if (state == CLEANUP3_STATE_TEMPLATE_OVERRIDE ||
        channelCode == CLEANUP3_TEMPLATE_CODE_F ||
        channelCode == CLEANUP3_TEMPLATE_CODE_G ||
        channelCode == CLEANUP3_TEMPLATE_CODE_N ||
        channelCode == CLEANUP3_TEMPLATE_CODE_O) {
        LONG selectedMode;
        LONG missingLabelFlag;

        TEXTDISP_BuildChannelLabel(0);
        selectedMode = (state == CLEANUP3_STATE_TEMPLATE_OVERRIDE) ? 1 : 0;
        missingLabelFlag = (TEXTDISP_ChannelLabelReadyFlag == 0) ? -1 : 0;

        CLEANUP_BuildAlignedStatusLine(
            TEXTDISP_ChannelLabelBuffer,
            (LONG)TEXTDISP_ActiveGroupId,
            (LONG)CLEANUP_AlignedStatusMatchIndex,
            (LONG)CLEANUP_AlignedStatusClockEntryIndex,
            selectedMode,
            missingLabelFlag);

        if (state == CLEANUP3_STATE_TEMPLATE_OVERRIDE) {
            STRING_AppendAtNull(TEXTDISP_ChannelLabelBuffer, CLEANUP_AlignedStatusSuffixBuffer);
        }
    }

    TEXTDISP_BannerCharSelected = CLEANUP3_BANNER_CHAR_NONE;
    TEXTDISP_BannerCharFallback = '1';
    TEXTDISP_LinePenOverrideStateWord = 0;
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, CLEANUP3_DRAWMODE_JAM1);
    TEXTDISP_LinePenOverrideEnabledFlag = 1;

    context = (CLEANUP3_DisplayContext *)WDISP_DisplayContextBase;
    TEXTDISP_TrimTextToPixelWidth(TEXTDISP_ChannelLabelBuffer, (LONG)context->width2);
    TEXTDISP_DrawInsetRectFrame(TEXTDISP_ChannelLabelBuffer, CLEANUP3_DRAWMODE_FRAME);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, CLEANUP3_DRAWMODE_COMPLEMENT);
    rastPort = TLIBA3_GetViewModeRastPort(2);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);

    midY = TLIBA3_GetViewModeHeight(2);
    if (midY < 0) {
        ++midY;
    }
    midY >>= 1;
    bottomY = TLIBA3_GetViewModeHeight(2) - 1;
    _LVORectFill(Global_REF_GRAPHICS_LIBRARY, rastPort, 0, midY, CLEANUP3_FILL_MAX_X, bottomY);

    ESQ_SetCopperEffect_OnEnableHighlight();

    context = (CLEANUP3_DisplayContext *)WDISP_DisplayContextBase;
    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(
        Global_REF_320_240_BITMAP,
        0,
        0,
        (char *)((UBYTE *)context + 2),
        0,
        0,
        (LONG)context->width2 - 1,
        (LONG)context->height4 - 1,
        CLEANUP3_BLIT_MINTERM_COPY,
        0);

    ESQIFF_RunCopperRiseTransition();

done:
    return;
}

void CLEANUP_RenderAlignedStatusScreen(UWORD sourceMode, UWORD modeSel, UWORD slot)
{
    CLEANUP_BuildAndRenderAlignedStatusBanner(sourceMode, modeSel, slot);
}
