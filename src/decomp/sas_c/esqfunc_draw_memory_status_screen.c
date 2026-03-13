typedef signed long LONG;
typedef signed short WORD;
typedef signed char BYTE;
typedef unsigned char UBYTE;

typedef struct RastPortLike {
    void *layerOrReserved;
    void *bitmap;
} RastPortLike;

extern RastPortLike *Global_REF_RASTPORT_1;
extern void *Global_REF_696_400_BITMAP;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *AbsExecBase;

extern WORD ED_DiagnosticsScreenActive;
extern WORD ED_DiagnosticsViewMode;
extern LONG ED_DiagAvailMemMask;

extern WORD ESQIFF_ParseAttemptCount;
extern WORD DATACErrs;
extern WORD ESQIFF_LineErrorCount;
extern WORD SCRIPT_CtrlCmdCount;
extern WORD SCRIPT_CtrlCmdChecksumErrorCount;
extern WORD SCRIPT_CtrlCmdLengthErrorCount;
extern WORD ESQ_SerialRbfErrorCount;
extern WORD Global_WORD_H_VALUE;
extern WORD Global_WORD_T_VALUE;
extern WORD Global_WORD_MAX_VALUE;
extern WORD CTRL_H;
extern WORD CTRL_HPreviousSample;
extern WORD CTRL_HDeltaMax;
extern BYTE TEXTDISP_PrimaryGroupCode;
extern BYTE TEXTDISP_SecondaryGroupCode;
extern BYTE TEXTDISP_PrimaryGroupHeaderCode;
extern BYTE TEXTDISP_SecondaryGroupHeaderCode;
extern BYTE TEXTDISP_PrimaryGroupPresentFlag;
extern BYTE TEXTDISP_SecondaryGroupPresentFlag;
extern WORD CLOCK_CacheDayIndex0;
extern WORD CLOCK_CacheMonthIndex0;
extern WORD ESQFUNC_CListLinePointer;
extern WORD CLOCK_CacheYear;
extern WORD CLOCK_CurrentDayOfMonth;
extern WORD CLOCK_CurrentMonthIndex;
extern WORD CLOCK_CurrentLeapYearFlag;
extern WORD CLOCK_CurrentYearValue;
extern WORD DST_PrimaryCountdown;
extern WORD DST_SecondaryCountdown;
extern WORD WDISP_BannerCharPhaseShift;
extern WORD CLOCK_CacheHour;
extern WORD Global_WORD_CURRENT_HOUR;
extern WORD CLOCK_HalfHourSlotIndex;

extern const char Global_STR_DATA_CMDS_CERRS_LERRS[];
extern const char Global_STR_CTRL_CMDS_CERRS_LERRS[];
extern const char Global_STR_L_CHIP_FAST_MAX[];
extern const char Global_STR_CHIP_PLACEHOLDER[];
extern const char Global_STR_FAST_PLACEHOLDER[];
extern const char Global_STR_MAX_PLACEHOLDER[];
extern const char Global_STR_MEMORY_TYPES_DISABLED[];
extern const char Global_STR_DATA_OVERRUNS_FORMATTED[];
extern const char Global_STR_DATA_H_T_C_MAX_FORMATTED[];
extern const char Global_STR_CTRL_H_T_C_MAX_FORMATTED[];
extern const char Global_STR_JULIAN_DAY_NEXT_FORMATTED[];
extern const char Global_STR_JDAY1_JDAY2_FORMATTED[];
extern const char Global_STR_CURCLU_NXTCLU_FORMATTED[];
extern const char Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED[];
extern const char Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED[];
extern const char Global_STR_C_DST_B_DST_PSHIFT_FORMATTED[];
extern const char Global_STR_C_HOUR_B_HOUR_CS_FORMATTED[];

extern void _LVOSetAPen(void *graphicsBase, RastPortLike *rastPort, LONG pen);
extern void _LVOSetDrMd(void *graphicsBase, RastPortLike *rastPort, LONG drawMode);
extern LONG _LVOAvailMem(void *execBase, LONG attributes);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void DISPLIB_DisplayTextAtPosition(RastPortLike *rastPort, LONG y, LONG x, const char *text);
extern LONG PARSEINI_ComputeHTCMaxValues(void);
extern LONG PARSEINI_UpdateCtrlHDeltaMax(void);

void ESQFUNC_DrawMemoryStatusScreen(void)
{
    char lineBuffer[72];
    void *savedBitmap;
    LONG chipLargest;
    LONG fastMem;
    LONG maxMem;
    LONG currentMaxValue;

    savedBitmap = Global_REF_RASTPORT_1->bitmap;
    Global_REF_RASTPORT_1->bitmap = Global_REF_696_400_BITMAP;

    if (ED_DiagnosticsScreenActive == 0) {
        goto restore_bitmap;
    }

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);

    if (ED_DiagnosticsViewMode == 0) {
        WDISP_SPrintf(
            lineBuffer,
            Global_STR_DATA_CMDS_CERRS_LERRS,
            (LONG)ESQIFF_ParseAttemptCount,
            (LONG)DATACErrs,
            (LONG)ESQIFF_LineErrorCount
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 112, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_CTRL_CMDS_CERRS_LERRS,
            (LONG)SCRIPT_CtrlCmdCount,
            (LONG)SCRIPT_CtrlCmdChecksumErrorCount,
            (LONG)SCRIPT_CtrlCmdLengthErrorCount
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 142, lineBuffer);

        if ((ED_DiagAvailMemMask & 7) == 7) {
            chipLargest = _LVOAvailMem(AbsExecBase, 0x20002L);
            fastMem = _LVOAvailMem(AbsExecBase, 4);
            maxMem = _LVOAvailMem(AbsExecBase, 0x00020000L);
            WDISP_SPrintf(
                lineBuffer,
                Global_STR_L_CHIP_FAST_MAX,
                chipLargest,
                fastMem,
                maxMem
            );
        } else if ((ED_DiagAvailMemMask & 1) == 1) {
            chipLargest = _LVOAvailMem(AbsExecBase, 2);
            WDISP_SPrintf(lineBuffer, Global_STR_CHIP_PLACEHOLDER, chipLargest);
        } else if ((ED_DiagAvailMemMask & 2) == 2) {
            fastMem = _LVOAvailMem(AbsExecBase, 4);
            WDISP_SPrintf(lineBuffer, Global_STR_FAST_PLACEHOLDER, fastMem);
        } else if ((ED_DiagAvailMemMask & 4) == 4) {
            maxMem = _LVOAvailMem(AbsExecBase, 0x00020000L);
            WDISP_SPrintf(lineBuffer, Global_STR_MAX_PLACEHOLDER, maxMem);
        } else {
            WDISP_SPrintf(lineBuffer, Global_STR_MEMORY_TYPES_DISABLED);
        }
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 172, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_DATA_OVERRUNS_FORMATTED,
            (LONG)ESQ_SerialRbfErrorCount
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 202, lineBuffer);

        currentMaxValue = PARSEINI_ComputeHTCMaxValues();
        WDISP_SPrintf(
            lineBuffer,
            Global_STR_DATA_H_T_C_MAX_FORMATTED,
            (LONG)Global_WORD_H_VALUE,
            (LONG)Global_WORD_T_VALUE,
            currentMaxValue,
            (LONG)Global_WORD_MAX_VALUE
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 232, lineBuffer);

        currentMaxValue = PARSEINI_UpdateCtrlHDeltaMax();
        WDISP_SPrintf(
            lineBuffer,
            Global_STR_CTRL_H_T_C_MAX_FORMATTED,
            (LONG)CTRL_H,
            (LONG)CTRL_HPreviousSample,
            currentMaxValue,
            (LONG)CTRL_HDeltaMax
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 262, lineBuffer);
    }

    if (ED_DiagnosticsViewMode == 1) {
        WDISP_SPrintf(
            lineBuffer,
            Global_STR_JULIAN_DAY_NEXT_FORMATTED,
            (LONG)(UBYTE)TEXTDISP_PrimaryGroupCode,
            (LONG)(UBYTE)TEXTDISP_SecondaryGroupCode
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 112, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_JDAY1_JDAY2_FORMATTED,
            (LONG)(UBYTE)TEXTDISP_PrimaryGroupHeaderCode,
            (LONG)(UBYTE)TEXTDISP_SecondaryGroupHeaderCode
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 142, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_CURCLU_NXTCLU_FORMATTED,
            (LONG)(UBYTE)TEXTDISP_PrimaryGroupPresentFlag,
            (LONG)(UBYTE)TEXTDISP_SecondaryGroupPresentFlag
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 172, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED,
            (LONG)CLOCK_CacheDayIndex0,
            (LONG)CLOCK_CacheMonthIndex0,
            (LONG)ESQFUNC_CListLinePointer,
            (LONG)CLOCK_CacheYear
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 202, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED,
            (LONG)CLOCK_CurrentDayOfMonth,
            (LONG)CLOCK_CurrentMonthIndex,
            (LONG)CLOCK_CurrentLeapYearFlag,
            (LONG)CLOCK_CurrentYearValue
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 232, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_C_DST_B_DST_PSHIFT_FORMATTED,
            (LONG)DST_PrimaryCountdown,
            (LONG)DST_SecondaryCountdown,
            (LONG)WDISP_BannerCharPhaseShift
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 262, lineBuffer);

        WDISP_SPrintf(
            lineBuffer,
            Global_STR_C_HOUR_B_HOUR_CS_FORMATTED,
            (LONG)CLOCK_CacheHour,
            (LONG)Global_WORD_CURRENT_HOUR,
            (LONG)CLOCK_HalfHourSlotIndex
        );
        DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 292, lineBuffer);
    }

restore_bitmap:
    Global_REF_RASTPORT_1->bitmap = savedBitmap;
}
