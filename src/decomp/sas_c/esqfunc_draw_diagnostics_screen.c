typedef signed long LONG;
typedef unsigned long ULONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef signed char BYTE;
typedef unsigned char UBYTE;

typedef struct ESQFUNC_DisplayContext {
    UBYTE pad0[2];
    UBYTE rastPort[1];
} ESQFUNC_DisplayContext;

extern LONG WDISP_DisplayContextBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_TOPAZ_FONT;
extern void *Global_HANDLE_PREVUEC_FONT;
extern LONG AbsExecBase;

extern LONG ESQFUNC_DiagRowCounter;
extern WORD Global_RefreshTickCounter;
extern WORD ESQDISP_PrimarySecondaryMirrorFlag;
extern UBYTE ED_MenuStateId;

extern WORD SCRIPT_CtrlHandshakeStage;
extern WORD SCRIPT_RuntimeMode;
extern WORD SCRIPT_PlaybackFallbackCounter;

extern WORD ESQPARS2_ReadModeFlags;
extern WORD ESQIFF_ParseAttemptCount;
extern WORD ESQIFF_LineErrorCount;
extern WORD DATACErrs;

extern WORD TEXTDISP_DeferredActionCountdown;
extern WORD TEXTDISP_DeferredActionArmed;

extern LONG LOCAVAIL_PrimaryFilterState_Field08;
extern LONG LOCAVAIL_PrimaryFilterState_Field0C;
extern LONG LOCAVAIL_FilterModeFlag;
extern LONG LOCAVAIL_FilterStep;
extern LONG LOCAVAIL_FilterClassId;
extern WORD LOCAVAIL_FilterCooldownTicks;

extern WORD CLOCK_CacheMonthIndex0;
extern WORD CLOCK_CacheDayIndex0;
extern WORD CLOCK_CacheYear;
extern WORD CLOCK_CacheHour;
extern WORD CLOCK_CacheMinuteOrSecond;
extern WORD Global_REF_CLOCKDATA_STRUCT;
extern WORD CLOCK_CacheAmPmFlag;

extern WORD SCRIPT_CtrlCmdCount;
extern WORD SCRIPT_CtrlCmdChecksumErrorCount;
extern WORD SCRIPT_CtrlCmdLengthErrorCount;
extern WORD CTRL_HDeltaMax;
extern WORD Global_WORD_H_VALUE;
extern WORD Global_WORD_T_VALUE;
extern WORD Global_WORD_MAX_VALUE;

extern WORD ESQ_CopperStatusDigitsA;
extern WORD ESQ_CopperStatusDigitsB;
extern WORD ESQ_CopperStatusDigitsA_ColorRegistersA;
extern WORD ESQ_CopperStatusDigitsA_ColorRegistersB;
extern WORD ESQ_CopperStatusDigitsA_ColorRegistersC;
extern WORD ESQ_CopperStatusDigitsA_TailColorWord;
extern WORD ESQ_CopperStatusDigitsB_ColorRegistersA;
extern WORD ESQ_CopperStatusDigitsB_TailColorWord;

extern const char *ESQFUNC_VideoInsertionStateStrings[];
extern const char ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT[];
extern const char ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X[];
extern const char ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L[];
extern const char ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC[];
extern const char ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT[];
extern const char ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR[];
extern const char ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR[];
extern const char ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS[];
extern const char ESQFUNC_STR_CLOSED_ENABLED[];
extern const char ESQFUNC_STR_OPEN_DISABLED[];
extern const char ESQFUNC_TAG_CLOSED[];
extern const char ESQFUNC_TAG_OPEN[];
extern const char ESQFUNC_STR_CLOSED_ON_AIR[];
extern const char ESQFUNC_STR_OPEN_OFF_AIR[];
extern const char ESQFUNC_STR_ON_AIR[];
extern const char ESQFUNC_STR_OFF_AIR[];
extern const char ESQFUNC_STR_NO_DETECT[];
extern const char ESQFUNC_STR_PM[];
extern const char ESQFUNC_STR_AM[];
extern const char Global_STR_TRUE_2[];
extern const char Global_STR_FALSE_2[];

extern void _LVOSetFont(void *graphicsBase, char *rastPort, void *font);
extern LONG _LVOAvailMem(LONG execBase, LONG attributes);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y);
extern LONG ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void);
extern LONG SCRIPT_GetCtrlLineFlag(void);
extern LONG ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag(void);
extern LONG PARSEINI_ComputeHTCMaxValues(void);
extern LONG PARSEINI_UpdateCtrlHDeltaMax(void);

void ESQFUNC_DrawDiagnosticsScreen(void)
{
    char lineBuffer[132];
    const char *videoInsertionStateStrings[4];
    ESQFUNC_DisplayContext *displayContext;
    char *rastPort;
    const char *cartSwitchText;
    const char *cartReleaseText;
    const char *videoSwitchText;
    const char *runtimeModeText;
    const char *amPmText;
    LONG currentMaxValue;
    LONG chipMem;
    LONG fastMem;
    LONG maxMem;

    videoInsertionStateStrings[0] = ESQFUNC_VideoInsertionStateStrings[0];
    videoInsertionStateStrings[1] = ESQFUNC_VideoInsertionStateStrings[1];
    videoInsertionStateStrings[2] = ESQFUNC_VideoInsertionStateStrings[2];
    videoInsertionStateStrings[3] = ESQFUNC_VideoInsertionStateStrings[3];

    ESQ_CopperStatusDigitsA_ColorRegistersA = 0x0fff;
    ESQ_CopperStatusDigitsB_ColorRegistersA = 0x0fff;
    ESQ_CopperStatusDigitsA = 0;
    ESQ_CopperStatusDigitsB = 0;
    ESQ_CopperStatusDigitsA_ColorRegistersB = 0;
    ESQ_CopperStatusDigitsB_TailColorWord = 0;
    ESQ_CopperStatusDigitsA_ColorRegistersC = 0;
    ESQ_CopperStatusDigitsA_TailColorWord = 0;

    displayContext = (ESQFUNC_DisplayContext *)WDISP_DisplayContextBase;
    rastPort = (char *)displayContext->rastPort;
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_HANDLE_TOPAZ_FONT);

    if (ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask() != 0) {
        cartSwitchText = ESQFUNC_STR_CLOSED_ENABLED;
    } else {
        cartSwitchText = ESQFUNC_STR_OPEN_DISABLED;
    }

    if (SCRIPT_GetCtrlLineFlag() != 0) {
        cartReleaseText = ESQFUNC_TAG_CLOSED;
    } else {
        cartReleaseText = ESQFUNC_TAG_OPEN;
    }

    if (ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag() != 0) {
        videoSwitchText = ESQFUNC_STR_CLOSED_ON_AIR;
    } else {
        videoSwitchText = ESQFUNC_STR_OPEN_OFF_AIR;
    }

    if ((WORD)(SCRIPT_CtrlHandshakeStage - 2) == 0) {
        runtimeModeText = ESQFUNC_STR_ON_AIR;
    } else if ((WORD)(SCRIPT_CtrlHandshakeStage - 1) == 0) {
        runtimeModeText = ESQFUNC_STR_OFF_AIR;
    } else {
        runtimeModeText = ESQFUNC_STR_NO_DETECT;
    }

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT,
        cartSwitchText,
        cartReleaseText,
        videoSwitchText,
        runtimeModeText
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 92);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X,
        videoInsertionStateStrings[(LONG)SCRIPT_RuntimeMode],
        (LONG)ESQPARS2_ReadModeFlags
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 110);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L,
        (LONG)TEXTDISP_DeferredActionCountdown,
        (LONG)TEXTDISP_DeferredActionArmed,
        LOCAVAIL_FilterModeFlag,
        LOCAVAIL_FilterStep,
        LOCAVAIL_FilterClassId,
        LOCAVAIL_PrimaryFilterState_Field08,
        LOCAVAIL_PrimaryFilterState_Field0C
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 128);

    if (CLOCK_CacheAmPmFlag != 0) {
        amPmText = ESQFUNC_STR_PM;
    } else {
        amPmText = ESQFUNC_STR_AM;
    }

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC,
        (LONG)CLOCK_CacheMonthIndex0,
        (LONG)CLOCK_CacheDayIndex0,
        (LONG)CLOCK_CacheYear,
        (LONG)CLOCK_CacheHour,
        (LONG)CLOCK_CacheMinuteOrSecond,
        (LONG)Global_REF_CLOCKDATA_STRUCT,
        amPmText,
        (LONG)LOCAVAIL_FilterCooldownTicks
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 146);

    chipMem = _LVOAvailMem(AbsExecBase, 0x20002L);
    fastMem = _LVOAvailMem(AbsExecBase, 4);
    maxMem = _LVOAvailMem(AbsExecBase, 0x00020000L);
    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT,
        chipMem,
        fastMem,
        maxMem
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 164);

    currentMaxValue = PARSEINI_ComputeHTCMaxValues();
    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR,
        (LONG)ESQIFF_ParseAttemptCount,
        (LONG)DATACErrs,
        (LONG)ESQIFF_LineErrorCount,
        (LONG)Global_WORD_MAX_VALUE,
        currentMaxValue
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 182);

    currentMaxValue = PARSEINI_UpdateCtrlHDeltaMax();
    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR,
        (LONG)SCRIPT_CtrlCmdCount,
        (LONG)SCRIPT_CtrlCmdChecksumErrorCount,
        (LONG)SCRIPT_CtrlCmdLengthErrorCount,
        (LONG)CTRL_HDeltaMax,
        currentMaxValue
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 200);

    ESQFUNC_DiagRowCounter += 1;
    if (ESQDISP_PrimarySecondaryMirrorFlag != 0) {
        cartSwitchText = Global_STR_TRUE_2;
    } else {
        cartSwitchText = Global_STR_FALSE_2;
    }

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        lineBuffer,
        ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS,
        ESQFUNC_DiagRowCounter,
        (LONG)Global_RefreshTickCounter,
        cartSwitchText,
        (LONG)SCRIPT_PlaybackFallbackCounter,
        (LONG)(BYTE)ED_MenuStateId
    );
    TLIBA3_DrawCenteredWrappedTextLines(rastPort, lineBuffer, 218);

    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_HANDLE_PREVUEC_FONT);
}
