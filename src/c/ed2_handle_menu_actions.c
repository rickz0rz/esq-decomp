/* RESTORES: ED2_HandleMenuActions
 * MODULE:   modules/groups/a/k/ed2_ed2_handlemenuactions.s
 * STATUS:   behavioural
 *
 * The ESC-menu action dispatcher, 2092 bytes: a 51-way `switch` on the first byte
 * of the current ring-table entry, and every arm converges on one tail that puts
 * RastPort 1's pens and bitmap back.
 *
 * The key codes are sparse and wide -- 2..27, 43..122, then 160, 161, 223, 229,
 * 231 and 254 -- which the original walks with a chained SUBQ/SUBI on a word.
 * A `switch` is what reproduces that; an if/else chain emits independent compares.
 * There is no explicit range guard, and `default:` falls into the shared tail.
 *
 * Two arms are worth flagging because they look like transcription slips:
 *
 * THE DIAGNOSTIC DUMP READS A TITLE POINTER IT NEVER USES. The loop over the
 * primary group loads both the entry pointer and the title pointer into locals and
 * then passes only the entry pointer to the verbose dumper. The dead load is in
 * the original and is kept here; if 6.51 drops it, that is eight bytes of the
 * measured deficit and not a difference in behaviour.
 *
 * THE CLOCK.CMD READER IS A FOUR-STATE MACHINE looking for the byte sequence
 * 0x55, 0xAA, 'K'. State 1 and state 2 reset to 0 on a mismatch but state 0 does
 * not, so a run of 0x55 bytes stays armed. On a match it hands the rest of the
 * buffer to the RTC writer and then sets the loop index to the byte count, which
 * ends the scan on the next increment -- a `break` written as an assignment.
 *
 * The colour-bar arm multiplies by 15 as `(i << 4) - i`, which is what the
 * original does (`LSL.L #4` then `SUB.L`). Per AGENTS.md, writing `i * 15` would
 * let SAS/C widen the computation and cost bytes.
 *
 * SASC-MISMATCH: register-argument-multiply
 *   ref:     723c 4eba....           MOVEQ #60,D1 / JSR MATH_Mulu32
 *   got:     the multiply inline
 *   summary: the refresh-interval conversion calls MATH_Mulu32 with both operands
 *            already in D0/D1. One site, written as `* 60`.
 *   scope:   program-wide wherever MATH_Mulu32 appears.
 *   retest:  a compiler whose multiply helper IS this routine.
 *
 * SASC-MISMATCH: cross-unit-call
 *   ref:     4eba....                JSR (d16,PC)
 *   got:     61000000                BSR.W
 *   summary: same size, different opcode; costs nothing.
 *   scope:   the whole cross-unit bucket.
 *   retest:  a compiler that picks the encoding per callee.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ff88 ... 4e5d       LINK.W A5,#-120 / UNLK A5
 *   got:     A7-relative locals
 *   scope:   program-wide; docs/compiler-version.md.
 *   retest:  a compiler that reserves A5.
 *
 * SASC-MISMATCH: unattributed-body-delta
 *   summary: 2132 against 2092, +40 over 84 regions -- 1.9%. NOT itemised. A 51-arm
 *            switch defeats casm.py the same way the two-level dispatch in
 *            script_handle_brush_command.c does: one enormous hunk covering every
 *            case body, which per AGENTS.md rule 1 cannot be read. Recorded as a
 *            known-unknown per rule 3.
 *   retest:  itemise again once the frame class is resolved.
 */
#include <exec/types.h>
#include <dos/dos.h>
#include <graphics/gfx.h>
#include <graphics/rastport.h>
#include <graphics/gfxbase.h>

#include "esq-dos.h"
#include "esq-graphics.h"

struct EdRingEntry {
    char c0;
    char c1;
    char c2;
    char c3;
    char c4;
};

struct EsqDisplayContext {
    char  pad0[2];
    short width;                /*  2 */
    short height;               /*  4 */
    char  pad6[4];
    struct RastPort rp2;        /* 10 */
};

extern long ED_StateRingIndex;
extern struct EdRingEntry ED_StateRingTable[];
extern unsigned char ED_LastKeyCode;
extern unsigned char ED_MenuStateId;
extern unsigned char ED_SavedCtasksIntervalByte;

extern short ED2_SelectedEntryIndex;
extern short ED2_SelectedFlagByteOffset;
extern short GCOMMAND_BannerRowFallbackOnFirstRowFlag;
extern short ESQ_ShutdownRequestedFlag;
extern unsigned char CLEANUP_DiagOverlayAutoRefreshFlag;
extern char  HIGHLIGHT_CustomValue;
extern short ESQPARS2_ReadModeFlags;
extern short ESQPARS2_StateIndex;
extern long  LOCAVAIL_FilterPrevClassId;
extern long  LOCAVAIL_FilterStep;
extern short TEXTDISP_DeferredActionCountdown;
extern short TEXTDISP_DeferredActionArmed;
extern short WDISP_AccumulatorCaptureActive;
extern short SCRIPT_RuntimeMode;
extern short SCRIPT_StatusRefreshHoldFlag;
extern short PARSEINI_CtrlHChangeGateFlag;
extern short ESQ_GlobalTickCounter;

extern short TEXTDISP_PrimaryGroupEntryCount;
extern unsigned char TEXTDISP_PrimaryGroupPresentFlag;
extern unsigned char TEXTDISP_PrimaryGroupHeaderCode;
extern unsigned char TEXTDISP_PrimaryGroupCode;
extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];

extern unsigned char WDISP_WeatherStatusCountdown;
extern unsigned char WDISP_WeatherStatusColorCode;
extern unsigned char WDISP_WeatherStatusBrushIndex;
extern short WDISP_WeatherStatusDigitChar;
extern short WDISP_WeatherCycleOffsetCount;
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern char *WDISP_WeatherStatusTextPtr;
extern char  WDISP_WeatherStatusLabelBuffer[];
extern long  P_TYPE_WeatherBrushRefreshPendingFlag;

extern unsigned char CONFIG_RefreshIntervalMinutes;
extern long  CONFIG_RefreshIntervalSeconds;
extern short CONFIG_BannerCopperHeadByte;

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap Global_REF_696_400_BITMAP;
extern struct EsqDisplayContext *WDISP_DisplayContextBase;
extern void *ESQSHARED_BannerRowScratchRasterBase0;
extern short CLOCK_DaySlotIndex;
extern short CLOCK_CurrentDayOfWeekIndex;

extern char Global_STR_DF0_CLOCK_CMD[];
extern char Global_STR_DF0_GRADIENT_INI_1[];
extern char Global_STR_TRUE_1[];
extern char Global_STR_FALSE_1[];
extern char ED2_STR_CTIME[];
extern char ED2_STR_BTIME[];
extern char ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU[];
extern char ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU[];
extern char ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1_[];
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

extern void ED1_DrawStatusLine1(void);
extern void ED1_DrawStatusLine2(void);
extern void ED1_EnterEscMenu(void);
extern void ED1_WaitForFlagAndClearBit0(void);
extern void ED1_WaitForFlagAndClearBit1(void);
extern void ED2_DrawEntrySummaryPanel(void);
extern void ED2_DrawEntryDetailsPanel(void);
extern void ED_InitRastport2Pens(void);
extern void DST_FormatBannerDateTime(char *name, short *slot);
extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer();
extern long ESQIFF_JMPTBL_DOS_OpenFileWithMode(char *name, long mode);
extern short GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar(void);
extern void ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(long code, long flag);
extern void GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom(void);
extern struct EsqDisplayContext *ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(
    long a, long b, long c);
extern void GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(long v);
extern void GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode(void);
extern void GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(char *p);
extern void GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry(void);
extern void GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory(void);
extern void GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(void *rp);
extern void GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(char *path);
extern void GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable(void);
extern void GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(long a, long b,
                                                              long c);
extern void ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(long mode);
extern void ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void);
extern void ESQFUNC_UpdateDiskWarningAndRefreshTick(void);
extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern short ESQDISP_TestWordIsZeroBooleanize(long v);
extern void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(long a, long b);
extern void ESQIFF_PlayNextExternalAssetFrame(long v);
extern void DISKIO2_RunDiskSyncWorkflow(long v);
extern void DISKIO2_ReloadDataFilesAndRebuildIndex(void);
extern void DISKIO1_DumpProgramSourceRecordVerbose(void *entry, long index);
extern void GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, void *a);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);

void ED2_HandleMenuActions(void)
{
    char  statusLine[50];
    char  fileBuf[50];
    void *entryPtr;
    void *titlePtr;
    char *boolText;
    long  state;
    long  fh;
    long  got;
    long  i;
    long  x1;
    char  n;

    ED_LastKeyCode = ED_StateRingTable[ED_StateRingIndex].c0;

    switch (ED_LastKeyCode) {

    case 2:
        ED1_DrawStatusLine1();
        break;

    case 102:
        ED1_DrawStatusLine2();
        break;

    case 4:
        if (ESQPARS2_StateIndex != 0)
            ESQPARS2_StateIndex = ESQPARS2_StateIndex - 1;
        ED1_DrawStatusLine1();
        break;

    case 5:
        ESQPARS2_StateIndex = ESQPARS2_StateIndex + 1;
        ED1_DrawStatusLine1();
        break;

    case 104:
        ED2_SelectedEntryIndex = ED2_SelectedEntryIndex + 1;
        ED2_DrawEntrySummaryPanel();
        break;

    case 8:
        ED2_SelectedEntryIndex = ED2_SelectedEntryIndex - 1;
        ED2_DrawEntrySummaryPanel();
        break;

    case 106:
        ED2_SelectedFlagByteOffset = ED2_SelectedFlagByteOffset + 1;
        ED2_DrawEntryDetailsPanel();
        break;

    case 10:
        ED2_SelectedFlagByteOffset = ED2_SelectedFlagByteOffset - 1;
        ED2_DrawEntryDetailsPanel();
        break;

    case 3:
        WDISP_DisplayContextBase =
            ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(3L, 0L, 4L);
        ED_InitRastport2Pens();
        SetAPen(Global_REF_RASTPORT_1, 0L);
        RectFill(Global_REF_RASTPORT_1, 0L, 20L,
                 (long)WDISP_DisplayContextBase->width,
                 (long)WDISP_DisplayContextBase->height);
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        SCRIPT_StatusRefreshHoldFlag = 1;
        break;

    case 7:
        GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(
            &WDISP_DisplayContextBase->rp2);
        Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
        GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(Global_REF_RASTPORT_1);
        break;

    case 15:
        WDISP_WeatherStatusCountdown = 0x3c;
        WDISP_WeatherStatusColorCode = 1;
        WDISP_WeatherStatusBrushIndex = 2;
        WDISP_WeatherStatusDigitChar = 0x32;
        WDISP_WeatherCycleOffsetCount = 0;
        break;

    case 19:
        ESQPARS2_ReadModeFlags = 0x200;
        break;

    case 83:
        ESQPARS2_ReadModeFlags = 0x100;
        break;

    case 115:
        ESQPARS2_ReadModeFlags = 0;
        break;

    case 21:
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_WICON_PCT_LD, (long)WDISP_WeatherStatusBrushIndex);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_W_MIN_PCT_LD_MINUTES, (long)WDISP_WeatherStatusCountdown);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_WDCNT_EVERY_PCT_LD_TIMES_PCT_LD,
            (long)WDISP_WeatherStatusDigitChar - 48,
            (long)WDISP_WeatherStatusDigitChar);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_CWCNT_PCT_LD_TIMES_FROM_NOW_PCT_LD,
            (long)WDISP_WeatherCycleOffsetCount,
            (long)WDISP_WeatherCycleOffsetCount);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_WDATA_PCT_08LX, WDISP_WeatherStatusOverlayTextPtr);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_WCITY_PCT_S, WDISP_WeatherStatusTextPtr);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_WEATHER_ID_PCT_S, WDISP_WeatherStatusLabelBuffer);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_CWCOLOR_PCT_LD, (long)WDISP_WeatherStatusColorCode);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_BANNER_FOR_WEATHER_PCT_D,
            P_TYPE_WeatherBrushRefreshPendingFlag);
        break;

    case 24:
        if (CONFIG_RefreshIntervalMinutes != 0) {
            ED_SavedCtasksIntervalByte = CONFIG_RefreshIntervalMinutes;
            CONFIG_RefreshIntervalMinutes = 0;
        } else {
            CONFIG_RefreshIntervalMinutes = ED_SavedCtasksIntervalByte;
        }
        CONFIG_RefreshIntervalSeconds =
            (long)(char)CONFIG_RefreshIntervalMinutes * 60;
        break;

    case 27:
        ED1_EnterEscMenu();
        break;

    case 43:
        ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(
            (long)(short)(GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar() + 1), 0L);
        break;

    case 45:
        ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(
            (long)(short)(GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar() - 1), 0L);
        break;

    case 61:
        ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(
            (long)CONFIG_BannerCopperHeadByte, 0L);
        break;

    case 47:
        GROUP_AK_JMPTBL_TLIBA3_SelectNextViewMode();
        break;

    case 65:
        if (LOCAVAIL_FilterStep != 0)
            break;
        LOCAVAIL_FilterPrevClassId = 2;
        GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(3L);
        TEXTDISP_DeferredActionCountdown = 3;
        TEXTDISP_DeferredActionArmed = 1;
        break;

    case 84:
        if (LOCAVAIL_FilterStep != 0)
            break;
        LOCAVAIL_FilterPrevClassId = 3;
        GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(3L);
        TEXTDISP_DeferredActionCountdown = 3;
        TEXTDISP_DeferredActionArmed = 1;
        break;

    case 68:
        DISKIO2_ReloadDataFilesAndRebuildIndex();
        break;

    case 71:
        ESQIFF_PlayNextExternalAssetFrame(1L);
        break;

    case 73:
        SCRIPT_RuntimeMode = 0;
        break;

    case 75:
        GROUP_AK_JMPTBL_PARSEINI_ScanLogoDirectory();
        break;

    case 76:
        ED1_WaitForFlagAndClearBit1();
        break;

    case 82:
        ED1_WaitForFlagAndClearBit0();
        break;

    case 77:
        GROUP_AK_JMPTBL_GCOMMAND_CopyGfxToWorkIfAvailable();
        break;

    case 78:
        Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
        GROUP_AM_JMPTBL_WDISP_SPrintf(statusLine, ED2_FMT_BITPLANE1_PCT_8LX,
                                      ESQSHARED_BannerRowScratchRasterBase0);
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40L, 232L,
                                      statusLine);
        break;

    case 92:
        ED_MenuStateId = 0x18;
        break;

    case 99:
        ED_InitRastport2Pens();
        for (n = 0; n < 32; n++) {
            SetAPen(Global_REF_RASTPORT_1, (long)n);
            x1 = ((long)n << 4) - (long)n;
            RectFill(Global_REF_RASTPORT_1, x1, 120L,
                     (((long)n << 4) - (long)n) + 15L, 200L);
        }
        break;

    case 101:
        GROUP_AK_JMPTBL_PARSEINI_WriteErrorLogEntry();
        break;

    case 103:
        ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh();
        break;

    case 107:
        state = 0;
        fh = ESQIFF_JMPTBL_DOS_OpenFileWithMode(Global_STR_DF0_CLOCK_CMD,
                                                MODE_OLDFILE);
        if (fh == 0)
            break;
        got = Read(fh, fileBuf, 50L);
        if (got >= 11) {
            for (i = 0; i < got; i++) {
                if (state == 0) {
                    if (fileBuf[i] == 85)
                        state = state + 1;
                } else if (state == 1) {
                    if (fileBuf[i] == (char)0xAA)
                        state = state + 1;
                    else
                        state = 0;
                } else if (state == 2) {
                    if (fileBuf[i] == 75)
                        state = state + 1;
                    else
                        state = 0;
                } else if (state == 3) {
                    GROUP_AK_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(&fileBuf[i]);
                    i = got;
                }
            }
        }
        Close(fh);
        break;

    case 108:
        GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(1L, 0L, 0L);
        break;

    case 114:
        GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen(0L, 0L, 0L);
        break;

    case 110:
        GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();
        ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(0L);
        GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(1L);
        break;

    case 112:
        GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(
            Global_STR_DF0_GRADIENT_INI_1);
        break;

    case 120:
        HIGHLIGHT_CustomValue = 0x1f;
        GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom();
        break;

    case 121:
        ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(0L, 31L);
        WDISP_AccumulatorCaptureActive = 0;
        break;

    case 122:
        ESQFUNC_UpdateDiskWarningAndRefreshTick();
        PARSEINI_CtrlHChangeGateFlag =
            ESQDISP_TestWordIsZeroBooleanize((long)PARSEINI_CtrlHChangeGateFlag);
        break;

    case 160:
        DISKIO2_RunDiskSyncWorkflow(0L);
        break;

    case 161:
        CLEANUP_DiagOverlayAutoRefreshFlag =
            (unsigned char)~CLEANUP_DiagOverlayAutoRefreshFlag;
        break;

    case 223:
        GCOMMAND_BannerRowFallbackOnFirstRowFlag =
            !GCOMMAND_BannerRowFallbackOnFirstRowFlag;
        break;

    case 229:
        ESQ_ShutdownRequestedFlag = 1;
        break;

    case 231:
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU);
        if (TEXTDISP_PrimaryGroupPresentFlag != 0)
            boolText = Global_STR_TRUE_1;
        else
            boolText = Global_STR_FALSE_1;
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1_,
            (long)TEXTDISP_PrimaryGroupEntryCount, boolText,
            (long)TEXTDISP_PrimaryGroupHeaderCode,
            (long)TEXTDISP_PrimaryGroupCode);
        for (n = 0; (long)n < (long)TEXTDISP_PrimaryGroupEntryCount; n++) {
            ESQ_GlobalTickCounter = 0;
            entryPtr = TEXTDISP_PrimaryEntryPtrTable[n];
            titlePtr = TEXTDISP_PrimaryTitlePtrTable[n];
            DISKIO1_DumpProgramSourceRecordVerbose(entryPtr, (long)n);
            ESQFUNC_ServiceUiTickIfRunning();
        }
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU);
        break;

    case 254:
        DST_FormatBannerDateTime(ED2_STR_CTIME, &CLOCK_DaySlotIndex);
        DST_FormatBannerDateTime(ED2_STR_BTIME, &CLOCK_CurrentDayOfWeekIndex);
        break;

    default:
        break;
    }

    SetAPen(Global_REF_RASTPORT_1, 1L);
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    SetDrMd(Global_REF_RASTPORT_1, 1L);
    SetBPen(Global_REF_RASTPORT_1, 2L);
}
