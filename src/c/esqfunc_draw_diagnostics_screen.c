/* RESTORES: ESQFUNC_DrawDiagnosticsScreen
 * MODULE:   modules/groups/a/n/esqfunc_p4.s
 * STATUS:   behavioural
 *
 * The first page of the ESC diagnostics screen: eight rows of subsystem state,
 * each built into one shared 132-byte buffer and drawn through
 * TLIBA3_DrawCenteredWrappedTextLines into the rastport at
 * WDISP_DisplayContextBase+10. The font changes to topaz on the way in and back
 * to PrevueC on the way out, so the rest of the program sees no change.
 *
 * The four state strings on the first row come from probes, not from stored
 * state: CartSW reads CIA-B bit 5, CartREL reads the CTRL line flag, and VidSW
 * reads CIA-B bit 3. Only the on_air tag comes from a variable
 * (SCRIPT_CtrlHandshakeStage, three values).
 *
 * The original copies the four-pointer table
 * ESQFUNC_VideoInsertionStateStrings into the frame with four MOVE.L before it
 * indexes it by SCRIPT_RuntimeMode. A struct assignment reproduces that copy.
 * Reading the table in place would be shorter, so the copy is evidence that the
 * original source declared a local array.
 *
 * The two LOCAVAIL_PrimaryFilterState fields are element 2 and element 3 of one
 * longword array, not two separate symbols. Declaring them separately would
 * need two renames and describes the data less well.
 *
 * SASC-MISMATCH: a5-frame-and-sysbase-width
 *   ref:     4e55ff5c                   LINK.W A5,#-164
 *   got:     9efc00c0                   SUBA.W #192,A7
 *   summary: 1002 bytes in the original against 1032 emitted, +30 over 47
 *            regions. The frame class leads, the same as in
 *            esqfunc_draw_memory_status_screen.c, and the three AvailMem calls
 *            each pay 2 bytes for the absolute-long _SysBase load against the
 *            original's MOVEA.L (4).W. The rest is block ordering and is NOT
 *            itemised -- see AGENTS.md rule 3.
 *   scope:   both classes are program-wide; see docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
#include "esq-graphics.h"

struct VideoInsertionStateStrings { char *s[4]; };

extern void WDISP_SPrintf(char *buf, char *fmt, ...);
extern void TLIBA3_DrawCenteredWrappedTextLines(void *rp,
                                                               char *text,
                                                               long y);
extern char SCRIPT_ReadHandshakeBit5Mask(void);
extern char SCRIPT_GetCtrlLineFlag(void);
extern char SCRIPT_ReadHandshakeBit3Flag(void);
extern long PARSEINI_ComputeHTCMaxValues(void);
extern long PARSEINI_UpdateCtrlHDeltaMax(void);

extern struct VideoInsertionStateStrings ESQFUNC_VideoInsertionStateStrings;
extern void *WDISP_DisplayContextBase;
extern struct TextFont *Global_HANDLE_TOPAZ_FONT;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;

extern short ESQ_CopperStatusDigitsA;
extern short ESQ_CopperStatusDigitsB;
extern short ESQ_CopperStatusDigitsA_ColorRegistersA;
extern short ESQ_CopperStatusDigitsA_ColorRegistersB;
extern short ESQ_CopperStatusDigitsA_ColorRegistersC;
extern short ESQ_CopperStatusDigitsA_TailColorWord;
extern short ESQ_CopperStatusDigitsB_ColorRegistersA;
extern short ESQ_CopperStatusDigitsB_TailColorWord;

extern char ESQFUNC_STR_CLOSED_ENABLED[];
extern char ESQFUNC_STR_OPEN_DISABLED[];
extern char ESQFUNC_TAG_CLOSED[];
extern char ESQFUNC_TAG_OPEN[];
extern char ESQFUNC_STR_CLOSED_ON_AIR[];
extern char ESQFUNC_STR_OPEN_OFF_AIR[];
extern char ESQFUNC_STR_ON_AIR[];
extern char ESQFUNC_STR_OFF_AIR[];
extern char ESQFUNC_STR_NO_DETECT[];
extern char ESQFUNC_STR_AM[];
extern char ESQFUNC_STR_PM[];
extern char Global_STR_TRUE_2[];
extern char Global_STR_FALSE_2[];

extern char ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT[];
extern char ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X[];
extern char ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L[];
extern char ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC[];
extern char ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT[];
extern char ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR[];
extern char ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR[];
extern char ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS[];

extern short SCRIPT_CtrlHandshakeStage;
extern short SCRIPT_RuntimeMode;
extern short ESQPARS2_ReadModeFlags;
extern unsigned short TEXTDISP_DeferredActionCountdown;
extern unsigned short TEXTDISP_DeferredActionArmed;
extern long  LOCAVAIL_FilterModeFlag;
extern long  LOCAVAIL_FilterStep;
extern long  LOCAVAIL_FilterClassId;
extern long  LOCAVAIL_PrimaryFilterState[];
extern short LOCAVAIL_FilterCooldownTicks;

extern short CLOCK_CacheMonthIndex0;
extern short CLOCK_CacheDayIndex0;
extern short CLOCK_CacheYear;
extern short CLOCK_CacheHour;
extern short CLOCK_CacheMinuteOrSecond;
extern short CLOCK_CacheAmPmFlag;
extern short Global_REF_CLOCKDATA_STRUCT;

extern unsigned short ESQIFF_ParseAttemptCount;
extern short          DATACErrs;
extern short          ESQIFF_LineErrorCount;
extern unsigned short Global_WORD_MAX_VALUE;
extern unsigned short SCRIPT_CtrlCmdCount;
extern short          SCRIPT_CtrlCmdChecksumErrorCount;
extern short          SCRIPT_CtrlCmdLengthErrorCount;
extern unsigned short CTRL_HDeltaMax;

extern long  ESQFUNC_DiagRowCounter;
extern short Global_RefreshTickCounter;
extern short ESQDISP_PrimarySecondaryMirrorFlag;
extern short SCRIPT_PlaybackFallbackCounter;
extern char  ED_MenuStateId;

void ESQFUNC_DrawDiagnosticsScreen(void)
{
    struct VideoInsertionStateStrings insertState;
    char buf[132];
    char *cartSw, *cartRel, *vidSw, *onAir, *ampm, *mirrored;
    long chipFree, fastFree, maxFree, htc;
    struct RastPort *rp;

    insertState = ESQFUNC_VideoInsertionStateStrings;

    ESQ_CopperStatusDigitsA_ColorRegistersA =
        ESQ_CopperStatusDigitsB_ColorRegistersA = 0xfff;
    ESQ_CopperStatusDigitsA = ESQ_CopperStatusDigitsB =
        ESQ_CopperStatusDigitsA_ColorRegistersB =
        ESQ_CopperStatusDigitsB_TailColorWord =
        ESQ_CopperStatusDigitsA_ColorRegistersC =
        ESQ_CopperStatusDigitsA_TailColorWord = 0;

    rp = (struct RastPort *)((char *)WDISP_DisplayContextBase + 10);
    SetFont(rp, Global_HANDLE_TOPAZ_FONT);

    if (SCRIPT_ReadHandshakeBit5Mask())
        cartSw = ESQFUNC_STR_CLOSED_ENABLED;
    else
        cartSw = ESQFUNC_STR_OPEN_DISABLED;

    if (SCRIPT_GetCtrlLineFlag())
        cartRel = ESQFUNC_TAG_CLOSED;
    else
        cartRel = ESQFUNC_TAG_OPEN;

    if (SCRIPT_ReadHandshakeBit3Flag())
        vidSw = ESQFUNC_STR_CLOSED_ON_AIR;
    else
        vidSw = ESQFUNC_STR_OPEN_OFF_AIR;

    if (SCRIPT_CtrlHandshakeStage == 2)
        onAir = ESQFUNC_STR_ON_AIR;
    else if (SCRIPT_CtrlHandshakeStage == 1)
        onAir = ESQFUNC_STR_OFF_AIR;
    else
        onAir = ESQFUNC_STR_NO_DETECT;

    WDISP_SPrintf(buf,
        ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT,
        cartSw, cartRel, vidSw, onAir);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 92L);

    WDISP_SPrintf(buf,
        ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X,
        insertState.s[SCRIPT_RuntimeMode], (long)ESQPARS2_ReadModeFlags);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 110L);

    WDISP_SPrintf(buf,
        ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L,
        (long)TEXTDISP_DeferredActionCountdown,
        (long)TEXTDISP_DeferredActionArmed,
        LOCAVAIL_FilterModeFlag, LOCAVAIL_FilterStep, LOCAVAIL_FilterClassId,
        LOCAVAIL_PrimaryFilterState[2], LOCAVAIL_PrimaryFilterState[3]);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 128L);

    if (CLOCK_CacheAmPmFlag != 0)
        ampm = ESQFUNC_STR_PM;
    else
        ampm = ESQFUNC_STR_AM;

    WDISP_SPrintf(buf,
        ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC,
        (long)CLOCK_CacheMonthIndex0, (long)CLOCK_CacheDayIndex0,
        (long)CLOCK_CacheYear, (long)CLOCK_CacheHour,
        (long)CLOCK_CacheMinuteOrSecond, (long)Global_REF_CLOCKDATA_STRUCT,
        ampm, (long)LOCAVAIL_FilterCooldownTicks);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 146L);

    chipFree = (long)AvailMem(0x20002L);
    fastFree = (long)AvailMem(4L);
    maxFree  = (long)AvailMem(0x20000L);
    WDISP_SPrintf(buf,
        ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT,
        chipFree, fastFree, maxFree);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 164L);

    htc = PARSEINI_ComputeHTCMaxValues();
    WDISP_SPrintf(buf,
        ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR,
        (long)ESQIFF_ParseAttemptCount, (long)DATACErrs,
        (long)ESQIFF_LineErrorCount, (long)Global_WORD_MAX_VALUE, htc);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 182L);

    htc = PARSEINI_UpdateCtrlHDeltaMax();
    WDISP_SPrintf(buf,
        ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR,
        (long)SCRIPT_CtrlCmdCount, (long)SCRIPT_CtrlCmdChecksumErrorCount,
        (long)SCRIPT_CtrlCmdLengthErrorCount, (long)CTRL_HDeltaMax, htc);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 200L);

    ESQFUNC_DiagRowCounter++;
    if (ESQDISP_PrimarySecondaryMirrorFlag != 0)
        mirrored = Global_STR_TRUE_2;
    else
        mirrored = Global_STR_FALSE_2;

    WDISP_SPrintf(buf,
        ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS,
        ESQFUNC_DiagRowCounter, (long)Global_RefreshTickCounter, mirrored,
        (long)SCRIPT_PlaybackFallbackCounter, (long)ED_MenuStateId);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, buf, 218L);

    rp = (struct RastPort *)((char *)WDISP_DisplayContextBase + 10);
    SetFont(rp, Global_HANDLE_PREVUEC_FONT);
}
