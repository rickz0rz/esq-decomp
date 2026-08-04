/* RESTORES: ESQFUNC_DrawMemoryStatusScreen
 * MODULE:   modules/groups/a/n/esqfunc_p4.s
 * STATUS:   behavioural
 *
 * The second page of the ESC diagnostics screen. It retargets the shared
 * rastport at the 696x400 bitmap, draws one of two pages of rows, and puts the
 * old bitmap pointer back. ED_DiagnosticsViewMode picks the page: 0 draws the
 * data and CTRL counters plus the free-memory line, 1 draws the calendar and
 * clock values. Any other value draws nothing, and a clear
 * ED_DiagnosticsScreenActive skips the whole body.
 *
 * The original tests the mode twice, once at the top with a branch to the
 * calendar block and once at the head of that block. Two separate `if`
 * statements reproduce that, and they are equivalent: the two arms cannot both
 * run.
 *
 * The free-memory line is a four-way choice on the low three bits of
 * ED_DiagAvailMemMask, the same longword ED2_HandleDiagnosticsMenuActions sets.
 * All three bits give a Largest-Chip / Fast / Largest triple, one bit gives one
 * value, and no bit gives a fixed "disabled" string.
 *
 * `chip`, `fast` and `far` are SAS/C keywords. A local called `chip` is a syntax
 * error with a message that names the line but not the word, so the locals here
 * carry a suffix.
 *
 * SASC-MISMATCH: a5-frame-and-sysbase-width
 *   ref:     4e55ffb0                   LINK.W A5,#-80
 *   got:     9efc004c                   SUBA.W #76,A7
 *   summary: 1164 bytes in the original against 1192 emitted, +28 over 57
 *            regions. Two classes account for the shape. The original builds an
 *            A5 frame and 6.51 addresses its locals from A7, and the original
 *            reads AbsExecBase as MOVEA.L (4).W where 6.51 emits the 6-byte
 *            absolute-long form against the EXT_ABS _SysBase. The remainder is
 *            block ordering, and this file does NOT itemise it -- see AGENTS.md
 *            rule 3 on unattributed deltas.
 *   scope:   the A5-frame class covers every restoration of a function with
 *            locals; the AbsExecBase width covers the six AvailMem sites here.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
#include "esq-graphics.h"

extern void WDISP_SPrintf(char *buf, char *fmt, ...);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp,
                                                         long x, long y,
                                                         char *text);
extern long PARSEINI_ComputeHTCMaxValues(void);
extern long PARSEINI_UpdateCtrlHDeltaMax(void);

extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap    Global_REF_696_400_BITMAP;

extern short ED_DiagnosticsScreenActive;
extern short ED_DiagnosticsViewMode;
extern long  ED_DiagAvailMemMask;

extern unsigned short ESQIFF_ParseAttemptCount;
extern short          DATACErrs;
extern short          ESQIFF_LineErrorCount;
extern unsigned short SCRIPT_CtrlCmdCount;
extern short          SCRIPT_CtrlCmdChecksumErrorCount;
extern short          SCRIPT_CtrlCmdLengthErrorCount;
extern unsigned short ESQ_SerialRbfErrorCount;

extern unsigned short Global_WORD_H_VALUE;
extern unsigned short Global_WORD_T_VALUE;
extern unsigned short Global_WORD_MAX_VALUE;
extern unsigned short CTRL_H;
extern unsigned short CTRL_HPreviousSample;
extern unsigned short CTRL_HDeltaMax;

extern unsigned char TEXTDISP_PrimaryGroupCode;
extern unsigned char TEXTDISP_SecondaryGroupCode;
extern unsigned char TEXTDISP_PrimaryGroupHeaderCode;
extern unsigned char TEXTDISP_SecondaryGroupHeaderCode;
extern unsigned char TEXTDISP_PrimaryGroupPresentFlag;
extern unsigned char TEXTDISP_SecondaryGroupPresentFlag;

extern short CLOCK_CacheDayIndex0;
extern short CLOCK_CacheMonthIndex0;
extern short ESQFUNC_CListLinePointer;
extern short CLOCK_CacheYear;
extern short CLOCK_CurrentDayOfMonth;
extern short CLOCK_CurrentMonthIndex;
extern short CLOCK_CurrentLeapYearFlag;
extern short CLOCK_CurrentYearValue;
extern short DST_PrimaryCountdown;
extern short DST_SecondaryCountdown;
extern short WDISP_BannerCharPhaseShift;
extern short CLOCK_CacheHour;
extern short Global_WORD_CURRENT_HOUR;
extern unsigned short CLOCK_HalfHourSlotIndex;

extern char Global_STR_DATA_CMDS_CERRS_LERRS[];
extern char Global_STR_CTRL_CMDS_CERRS_LERRS[];
extern char Global_STR_L_CHIP_FAST_MAX[];
extern char Global_STR_CHIP_PLACEHOLDER[];
extern char Global_STR_FAST_PLACEHOLDER[];
extern char Global_STR_MAX_PLACEHOLDER[];
extern char Global_STR_MEMORY_TYPES_DISABLED[];
extern char Global_STR_DATA_OVERRUNS_FORMATTED[];
extern char Global_STR_DATA_H_T_C_MAX_FORMATTED[];
extern char Global_STR_CTRL_H_T_C_MAX_FORMATTED[];
extern char Global_STR_JULIAN_DAY_NEXT_FORMATTED[];
extern char Global_STR_JDAY1_JDAY2_FORMATTED[];
extern char Global_STR_CURCLU_NXTCLU_FORMATTED[];
extern char Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED[];
extern char Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED[];
extern char Global_STR_C_DST_B_DST_PSHIFT_FORMATTED[];
extern char Global_STR_C_HOUR_B_HOUR_CS_FORMATTED[];

void ESQFUNC_DrawMemoryStatusScreen(void)
{
    char buf[72];
    struct BitMap *savedBitMap;
    long chipFree, fastFree, maxFree, htc;

    savedBitMap = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;

    if (ED_DiagnosticsScreenActive != 0) {
        SetAPen(Global_REF_RASTPORT_1, 1L);
        SetDrMd(Global_REF_RASTPORT_1, 1L);

        if (ED_DiagnosticsViewMode == 0) {
            WDISP_SPrintf(buf, Global_STR_DATA_CMDS_CERRS_LERRS,
                                          (long)ESQIFF_ParseAttemptCount,
                                          (long)DATACErrs,
                                          (long)ESQIFF_LineErrorCount);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 112L, buf);

            WDISP_SPrintf(buf, Global_STR_CTRL_CMDS_CERRS_LERRS,
                                          (long)SCRIPT_CtrlCmdCount,
                                          (long)SCRIPT_CtrlCmdChecksumErrorCount,
                                          (long)SCRIPT_CtrlCmdLengthErrorCount);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 142L, buf);

            if ((ED_DiagAvailMemMask & 7) == 7) {
                chipFree    = (long)AvailMem(0x20002L);
                fastFree    = (long)AvailMem(4L);
                maxFree = (long)AvailMem(0x20000L);
                WDISP_SPrintf(buf, Global_STR_L_CHIP_FAST_MAX,
                                              chipFree, fastFree, maxFree);
            } else if ((ED_DiagAvailMemMask & 1) == 1) {
                chipFree = (long)AvailMem(2L);
                WDISP_SPrintf(buf, Global_STR_CHIP_PLACEHOLDER,
                                              chipFree);
            } else if ((ED_DiagAvailMemMask & 2) == 2) {
                fastFree = (long)AvailMem(4L);
                WDISP_SPrintf(buf, Global_STR_FAST_PLACEHOLDER,
                                              fastFree);
            } else if ((ED_DiagAvailMemMask & 4) == 4) {
                maxFree = (long)AvailMem(0x20000L);
                WDISP_SPrintf(buf, Global_STR_MAX_PLACEHOLDER,
                                              maxFree);
            } else {
                WDISP_SPrintf(buf,
                                              Global_STR_MEMORY_TYPES_DISABLED);
            }
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 172L, buf);

            WDISP_SPrintf(buf, Global_STR_DATA_OVERRUNS_FORMATTED,
                                          (long)ESQ_SerialRbfErrorCount);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 202L, buf);

            htc = PARSEINI_ComputeHTCMaxValues();
            WDISP_SPrintf(buf, Global_STR_DATA_H_T_C_MAX_FORMATTED,
                                          (long)Global_WORD_H_VALUE,
                                          (long)Global_WORD_T_VALUE,
                                          htc,
                                          (long)Global_WORD_MAX_VALUE);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 232L, buf);

            htc = PARSEINI_UpdateCtrlHDeltaMax();
            WDISP_SPrintf(buf, Global_STR_CTRL_H_T_C_MAX_FORMATTED,
                                          (long)CTRL_H,
                                          (long)CTRL_HPreviousSample,
                                          htc,
                                          (long)CTRL_HDeltaMax);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 262L, buf);
        }

        if (ED_DiagnosticsViewMode == 1) {
            WDISP_SPrintf(buf, Global_STR_JULIAN_DAY_NEXT_FORMATTED,
                                          (long)TEXTDISP_PrimaryGroupCode,
                                          (long)TEXTDISP_SecondaryGroupCode);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 112L, buf);

            WDISP_SPrintf(buf, Global_STR_JDAY1_JDAY2_FORMATTED,
                                          (long)TEXTDISP_PrimaryGroupHeaderCode,
                                          (long)TEXTDISP_SecondaryGroupHeaderCode);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 142L, buf);

            WDISP_SPrintf(buf, Global_STR_CURCLU_NXTCLU_FORMATTED,
                                          (long)TEXTDISP_PrimaryGroupPresentFlag,
                                          (long)TEXTDISP_SecondaryGroupPresentFlag);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 172L, buf);

            WDISP_SPrintf(buf,
                                          Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED,
                                          (long)CLOCK_CacheDayIndex0,
                                          (long)CLOCK_CacheMonthIndex0,
                                          (long)ESQFUNC_CListLinePointer,
                                          (long)CLOCK_CacheYear);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 202L, buf);

            WDISP_SPrintf(buf,
                                          Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED,
                                          (long)CLOCK_CurrentDayOfMonth,
                                          (long)CLOCK_CurrentMonthIndex,
                                          (long)CLOCK_CurrentLeapYearFlag,
                                          (long)CLOCK_CurrentYearValue);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 232L, buf);

            WDISP_SPrintf(buf,
                                          Global_STR_C_DST_B_DST_PSHIFT_FORMATTED,
                                          (long)DST_PrimaryCountdown,
                                          (long)DST_SecondaryCountdown,
                                          (long)WDISP_BannerCharPhaseShift);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 262L, buf);

            WDISP_SPrintf(buf,
                                          Global_STR_C_HOUR_B_HOUR_CS_FORMATTED,
                                          (long)CLOCK_CacheHour,
                                          (long)Global_WORD_CURRENT_HOUR,
                                          (long)CLOCK_HalfHourSlotIndex);
            DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1,
                                                         40L, 292L, buf);
        }
    }

    Global_REF_RASTPORT_1->BitMap = savedBitMap;
}
