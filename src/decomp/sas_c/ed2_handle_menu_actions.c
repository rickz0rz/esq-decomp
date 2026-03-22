#include <exec/types.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>

typedef struct ED2_DisplayContextHeader {
    UWORD unused0;
    UWORD width;
    UWORD height;
} ED2_DisplayContextHeader;

typedef struct DST_BannerTimeInfo DST_BannerTimeInfo;

extern void *Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct RastPort *Global_REF_RASTPORT_2;
extern struct BitMap Global_REF_696_400_BITMAP;

extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;
extern WORD ESQ_GlobalTickCounter;

extern UWORD ESQPARS2_StateIndex;
extern UWORD ESQPARS2_ReadModeFlags;
extern UWORD ED2_SelectedEntryIndex;
extern UWORD ED2_SelectedFlagByteOffset;
extern UBYTE ED_MenuStateId;
extern UWORD SCRIPT_StatusRefreshHoldFlag;
extern UWORD SCRIPT_RuntimeMode;
extern UWORD WDISP_AccumulatorCaptureActive;
extern UWORD PARSEINI_CtrlHChangeGateFlag;
extern UWORD TEXTDISP_DeferredActionCountdown;
extern UWORD TEXTDISP_DeferredActionArmed;
extern UWORD ESQ_ShutdownRequestedFlag;

extern UBYTE WDISP_WeatherStatusCountdown;
extern UBYTE WDISP_WeatherStatusColorCode;
extern UBYTE WDISP_WeatherStatusBrushIndex;
extern UWORD WDISP_WeatherStatusDigitChar;
extern UWORD WDISP_WeatherCycleOffsetCount;
extern char WDISP_WeatherStatusLabelBuffer[];
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern char *WDISP_WeatherStatusTextPtr;
extern UBYTE CLEANUP_DiagOverlayAutoRefreshFlag;

extern UBYTE CONFIG_RefreshIntervalMinutes;
extern UBYTE ED_SavedCtasksIntervalByte;
extern LONG CONFIG_RefreshIntervalSeconds;
extern UWORD CONFIG_BannerCopperHeadByte;
extern UBYTE HIGHLIGHT_CustomValue;
extern LONG WDISP_DisplayContextBase;
extern LONG LOCAVAIL_FilterStep;
extern LONG LOCAVAIL_FilterPrevClassId;
extern LONG P_TYPE_WeatherBrushRefreshPendingFlag;
extern UBYTE TEXTDISP_PrimaryGroupPresentFlag;
extern UBYTE TEXTDISP_PrimaryGroupHeaderCode;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern char *TEXTDISP_PrimaryTitlePtrTable[];
extern WORD GCOMMAND_BannerRowFallbackOnFirstRowFlag;

extern char Global_STR_DF0_CLOCK_CMD[];
extern char Global_STR_DF0_GRADIENT_INI_1[];
extern char Global_STR_TRUE_1[];
extern char Global_STR_FALSE_1[];

extern char ED2_STR_CTIME[];
extern char ED2_STR_BTIME[];
extern char ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU[];
extern char ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1_[];
extern char ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU[];
extern char ED2_FMT_WICON_PCT_LD[];
extern char ED2_FMT_W_MIN_PCT_LD_MINUTES[];
extern char ED2_FMT_WDCNT_EVERY_PCT_LD_TIMES_PCT_LD[];
extern char ED2_FMT_CWCNT_PCT_LD_TIMES_FROM_NOW_PCT_LD[];
extern char ED2_FMT_WDATA_PCT_08LX[];
extern char ED2_FMT_WCITY_PCT_S[];
extern char ED2_FMT_WEATHER_ID_PCT_S[];
extern char ED2_FMT_CWCOLOR_PCT_LD[];
extern char ED2_FMT_BANNER_FOR_WEATHER_PCT_D[];
extern char ED2_FMT_BITPLANE1_PCT_8LX[];

extern DST_BannerTimeInfo CLOCK_DaySlotIndex;
extern DST_BannerTimeInfo CLOCK_CurrentDayOfWeekIndex;
extern UBYTE ESQSHARED_BannerRowScratchRasterBase0[];

extern void ED1_DrawStatusLine1(void);
extern void ED1_DrawStatusLine2(void);
extern void ED2_DrawEntrySummaryPanel(void);
extern void ED2_DrawEntryDetailsPanel(void);
extern void ED1_EnterEscMenu(void);
extern void ED_InitRastport2Pens(void);
extern void ED1_WaitForFlagAndClearBit0(void);
extern void ED1_WaitForFlagAndClearBit1(void);
extern void DST_FormatBannerDateTime(char *dst, const DST_BannerTimeInfo *info);
extern LONG FORMAT_RawDoFmtWithScratchBuffer(char *fmt, ...);
extern LONG _LVORead(void *dosBase, LONG fh, void *buf, LONG len);
extern LONG _LVOClose(void *dosBase, LONG fh);
extern void _LVOSetAPen(void *gfxBase, struct RastPort *rp, LONG pen);
extern void _LVOSetBPen(void *gfxBase, struct RastPort *rp, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, struct RastPort *rp, LONG mode);
extern void _LVORectFill(void *gfxBase, struct RastPort *rp, LONG xMin, LONG yMin, LONG xMax, LONG yMax);
extern LONG DOS_OpenFileWithMode(const char *path, LONG mode);
extern void ESQPARS_ApplyRtcBytesAndPersist(UBYTE *ptr);
extern void TLIBA3_SelectNextViewMode(void);
extern void TLIBA3_DrawViewModeGuides(struct RastPort *rp);
extern void DISKIO2_RunDiskSyncWorkflow(ULONG showStatus);
extern void DISKIO2_ReloadDataFilesAndRebuildIndex(void);
extern LONG DISKIO1_DumpProgramSourceRecordVerbose(LONG entryIndex, void *entry);
extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG GCOMMAND_GetBannerChar(void);
extern void GCOMMAND_CopyGfxToWorkIfAvailable(void);
extern void SCRIPT_BeginBannerCharTransition(LONG nextChar, LONG flags);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte);
extern void ESQ_SetCopperEffect_Custom(void);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void ESQ_MoveCopperEntryTowardEnd(LONG srcIndex, LONG dstIndex);
extern void ESQIFF_PlayNextExternalAssetFrame(WORD refreshMode);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG mode, LONG a, LONG b);
extern LONG PARSEINI_WriteErrorLogEntry(void);
extern void PARSEINI_ScanLogoDirectory(void);
extern LONG PARSEINI_ParseIniBufferAndDispatch(const char *path);
extern void CLEANUP_RenderAlignedStatusScreen(UWORD sourceMode, UWORD modeSel, UWORD slot);
extern void ESQFUNC_UpdateDiskWarningAndRefreshTick(void);
extern LONG ESQDISP_TestWordIsZeroBooleanize(WORD value);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rastPort, LONG x, LONG y, const char *text);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern void TEXTDISP_SetRastForMode(WORD modeIndex);

static void ED2_RestoreDisplayState(void)
{
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 2);
}

void ED2_HandleMenuActions(void)
{
    char statusLineBuffer[50];
    UBYTE clockBuf[50];
    UBYTE key;

    key = ED_StateRingTable[ED_StateRingIndex * 5];
    ED_LastKeyCode = key;

    switch ((ULONG)key) {
    case 2:
        ED1_DrawStatusLine1();
        break;

    case 3: {
        ED2_DisplayContextHeader *context;

        WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 4);
        ED_InitRastport2Pens();

        _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 0);
        context = (ED2_DisplayContextHeader *)WDISP_DisplayContextBase;
        _LVORectFill(
            Global_REF_GRAPHICS_LIBRARY,
            Global_REF_RASTPORT_1,
            0,
            20,
            (LONG)context->width,
            (LONG)context->height * 2);

        ESQ_SetCopperEffect_OnEnableHighlight();
        SCRIPT_StatusRefreshHoldFlag = 1;
        break;
    }

    case 4:
        if (ESQPARS2_StateIndex != 0) {
            ESQPARS2_StateIndex -= 1;
        }
        ED1_DrawStatusLine1();
        break;

    case 5:
        ESQPARS2_StateIndex += 1;
        ED1_DrawStatusLine1();
        break;

    case 7:
        TLIBA3_DrawViewModeGuides(Global_REF_RASTPORT_2);
        Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
        TLIBA3_DrawViewModeGuides(Global_REF_RASTPORT_1);
        break;

    case 8:
        ED2_SelectedEntryIndex -= 1;
        ED2_DrawEntrySummaryPanel();
        break;

    case 10:
        ED2_SelectedFlagByteOffset -= 1;
        ED2_DrawEntryDetailsPanel();
        break;

    case 15:
        WDISP_WeatherStatusCountdown = 0x3c;
        WDISP_WeatherStatusColorCode = 1;
        WDISP_WeatherStatusBrushIndex = 2;
        WDISP_WeatherStatusDigitChar = 0x32;
        WDISP_WeatherCycleOffsetCount = 0;
        break;

    case 19:
        ESQPARS2_ReadModeFlags = 0x0200;
        break;

    case 21:
        {
            UBYTE refreshMinutes;

            refreshMinutes = CONFIG_RefreshIntervalMinutes;
            if (refreshMinutes != 0) {
                ED_SavedCtasksIntervalByte = refreshMinutes;
                CONFIG_RefreshIntervalMinutes = 0;
            } else {
                CONFIG_RefreshIntervalMinutes = ED_SavedCtasksIntervalByte;
            }

            CONFIG_RefreshIntervalSeconds = ESQIFF_JMPTBL_MATH_Mulu32(
                (LONG)(UBYTE)CONFIG_RefreshIntervalMinutes,
                60);
        }
        break;

    case 24:
        {
            LONG weatherDigit;

            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_WICON_PCT_LD,
                (LONG)(UBYTE)WDISP_WeatherStatusBrushIndex);
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_W_MIN_PCT_LD_MINUTES,
                (LONG)(UBYTE)WDISP_WeatherStatusCountdown);

            weatherDigit = (LONG)WDISP_WeatherStatusDigitChar - (LONG)'0';
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_WDCNT_EVERY_PCT_LD_TIMES_PCT_LD,
                weatherDigit,
                (LONG)WDISP_WeatherStatusDigitChar);
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_CWCNT_PCT_LD_TIMES_FROM_NOW_PCT_LD,
                (LONG)(UWORD)WDISP_WeatherCycleOffsetCount,
                (LONG)(UWORD)WDISP_WeatherCycleOffsetCount);
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_WDATA_PCT_08LX,
                WDISP_WeatherStatusOverlayTextPtr);
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_WCITY_PCT_S,
                WDISP_WeatherStatusTextPtr);
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_WEATHER_ID_PCT_S,
                WDISP_WeatherStatusLabelBuffer);
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_CWCOLOR_PCT_LD,
                (LONG)(UBYTE)WDISP_WeatherStatusColorCode);
            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_BANNER_FOR_WEATHER_PCT_D,
                P_TYPE_WeatherBrushRefreshPendingFlag);
        }
        break;

    case 27:
        ED1_EnterEscMenu();
        break;

    case 43:
        {
            LONG nextChar;

            nextChar = GCOMMAND_GetBannerChar() + 1;
            SCRIPT_BeginBannerCharTransition(nextChar, 0);
        }
        break;

    case 45:
        {
            LONG prevChar;

            prevChar = GCOMMAND_GetBannerChar() - 1;
            SCRIPT_BeginBannerCharTransition(prevChar, 0);
        }
        break;

    case 47:
        TLIBA3_SelectNextViewMode();
        break;

    case 61:
        SCRIPT_BeginBannerCharTransition((LONG)(UWORD)CONFIG_BannerCopperHeadByte, 0);
        break;

    case 65:
        if (LOCAVAIL_FilterStep == 0) {
            LOCAVAIL_FilterPrevClassId = 2;
            SCRIPT_UpdateSerialShadowFromCtrlByte(3);
            TEXTDISP_DeferredActionCountdown = 3;
            TEXTDISP_DeferredActionArmed = 1;
        }
        break;

    case 68:
        DISKIO2_ReloadDataFilesAndRebuildIndex();
        break;

    case 71:
        ESQIFF_PlayNextExternalAssetFrame(1);
        break;

    case 73:
        SCRIPT_RuntimeMode = 0;
        break;

    case 75:
        PARSEINI_ScanLogoDirectory();
        break;

    case 76:
        ED1_WaitForFlagAndClearBit1();
        break;

    case 77:
        GCOMMAND_CopyGfxToWorkIfAvailable();
        break;

    case 78:
        Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
        WDISP_SPrintf(
            statusLineBuffer,
            ED2_FMT_BITPLANE1_PCT_8LX,
            ESQSHARED_BannerRowScratchRasterBase0);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 232, statusLineBuffer);
        break;

    case 82:
        ED1_WaitForFlagAndClearBit0();
        break;

    case 83:
        ESQPARS2_ReadModeFlags = 0x0100;
        break;

    case 84:
        if (LOCAVAIL_FilterStep == 0) {
            LOCAVAIL_FilterPrevClassId = 3;
            SCRIPT_UpdateSerialShadowFromCtrlByte(3);
            TEXTDISP_DeferredActionCountdown = 3;
            TEXTDISP_DeferredActionArmed = 1;
        }
        break;

    case 92:
        ED_MenuStateId = 0x18;
        break;

    case 99:
        {
            LONG color;
            LONG xMin;

            ED_InitRastport2Pens();

            for (color = 0; color < 32; color++) {
                xMin = color * 15;
                _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, color);
                _LVORectFill(
                    Global_REF_GRAPHICS_LIBRARY,
                    Global_REF_RASTPORT_1,
                    xMin,
                    120,
                    xMin + 15,
                    200);
            }
        }
        break;

    case 101:
        PARSEINI_WriteErrorLogEntry();
        break;

    case 102:
        ED1_DrawStatusLine2();
        break;

    case 103:
        TEXTDISP_ResetSelectionAndRefresh();
        break;

    case 104:
        ED2_SelectedEntryIndex += 1;
        ED2_DrawEntrySummaryPanel();
        break;

    case 106:
        ED2_SelectedFlagByteOffset += 1;
        ED2_DrawEntryDetailsPanel();
        break;

    case 107:
        {
            LONG fh;
            LONG rd;
            LONG i;
            LONG syncState;

            fh = DOS_OpenFileWithMode(Global_STR_DF0_CLOCK_CMD, 1005);
            if (fh != 0) {
                rd = _LVORead(Global_REF_DOS_LIBRARY_2, fh, clockBuf, 50);
                if (rd >= 11) {
                    syncState = 0;
                    for (i = 0; i < rd; i++) {
                        if (syncState == 0) {
                            if (clockBuf[i] == 'U') {
                                syncState = 1;
                            }
                        } else if (syncState == 1) {
                            if (clockBuf[i] == 0xAA) {
                                syncState = 2;
                            } else {
                                syncState = 0;
                            }
                        } else if (syncState == 2) {
                            if (clockBuf[i] == 'K') {
                                syncState = 3;
                            } else {
                                syncState = 0;
                            }
                        } else {
                            ESQPARS_ApplyRtcBytesAndPersist(&clockBuf[i]);
                            break;
                        }
                    }
                }
                _LVOClose(Global_REF_DOS_LIBRARY_2, fh);
            }
        }
        break;

    case 108:
        CLEANUP_RenderAlignedStatusScreen(1, 0, 0);
        break;

    case 110:
        ESQ_SetCopperEffect_OnEnableHighlight();
        TEXTDISP_SetRastForMode(0);
        SCRIPT_UpdateSerialShadowFromCtrlByte(1);
        break;

    case 112:
        PARSEINI_ParseIniBufferAndDispatch(Global_STR_DF0_GRADIENT_INI_1);
        break;

    case 114:
        CLEANUP_RenderAlignedStatusScreen(0, 0, 0);
        break;

    case 115:
        ESQPARS2_ReadModeFlags = 0;
        break;

    case 120:
        HIGHLIGHT_CustomValue = 0x1f;
        ESQ_SetCopperEffect_Custom();
        break;

    case 121:
        ESQ_MoveCopperEntryTowardEnd(0, 31);
        WDISP_AccumulatorCaptureActive = 0;
        break;

    case 122:
        ESQFUNC_UpdateDiskWarningAndRefreshTick();
        PARSEINI_CtrlHChangeGateFlag =
            (UWORD)ESQDISP_TestWordIsZeroBooleanize(PARSEINI_CtrlHChangeGateFlag);
        break;

    case 160:
        DISKIO2_RunDiskSyncWorkflow(0);
        break;

    case 161:
        CLEANUP_DiagOverlayAutoRefreshFlag =
            (UBYTE)~CLEANUP_DiagOverlayAutoRefreshFlag;
        break;

    case 223:
        GCOMMAND_BannerRowFallbackOnFirstRowFlag =
            (GCOMMAND_BannerRowFallbackOnFirstRowFlag == 0) ? (WORD)-1 : (WORD)0;
        break;

    case 229:
        ESQ_ShutdownRequestedFlag = 1;
        break;

    case 231:
        {
            LONG entryCount;
            LONG entryIndex;
            char *groupPresentString;

            FORMAT_RawDoFmtWithScratchBuffer(ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU);

            entryCount = (LONG)(UWORD)TEXTDISP_PrimaryGroupEntryCount;
            if (TEXTDISP_PrimaryGroupPresentFlag != 0) {
                groupPresentString = Global_STR_TRUE_1;
            } else {
                groupPresentString = Global_STR_FALSE_1;
            }

            FORMAT_RawDoFmtWithScratchBuffer(
                ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1_,
                entryCount,
                groupPresentString,
                (LONG)(UBYTE)TEXTDISP_PrimaryGroupHeaderCode,
                (LONG)(UBYTE)TEXTDISP_PrimaryGroupCode);

            for (entryIndex = 0; entryIndex < entryCount; entryIndex++) {
                ESQ_GlobalTickCounter = 0;
                DISKIO1_DumpProgramSourceRecordVerbose(
                    entryIndex,
                    TEXTDISP_PrimaryEntryPtrTable[entryIndex]);
                ESQFUNC_ServiceUiTickIfRunning();
            }

            FORMAT_RawDoFmtWithScratchBuffer(ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU);
        }
        break;

    case 254:
        DST_FormatBannerDateTime(ED2_STR_CTIME, &CLOCK_DaySlotIndex);
        DST_FormatBannerDateTime(ED2_STR_BTIME, &CLOCK_CurrentDayOfWeekIndex);
        break;

    default:
        break;
    }

    ED2_RestoreDisplayState();
}
