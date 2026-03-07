typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD ACCUMULATOR_Row0_SaturateFlag;
extern WORD ACCUMULATOR_Row1_SaturateFlag;
extern WORD ACCUMULATOR_Row2_SaturateFlag;
extern WORD ACCUMULATOR_Row3_SaturateFlag;

extern WORD WDISP_AccumulatorRow0_MoveFlags;
extern WORD WDISP_AccumulatorRow1_MoveFlags;
extern WORD WDISP_AccumulatorRow2_MoveFlags;
extern WORD WDISP_AccumulatorRow3_MoveFlags;

extern UBYTE WDISP_AccumulatorRow0_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow1_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow2_CopperIndexStart;
extern UBYTE WDISP_AccumulatorRow3_CopperIndexStart;

extern UBYTE WDISP_AccumulatorRow0_CopperIndexEnd;
extern UBYTE WDISP_AccumulatorRow1_CopperIndexEnd;
extern UBYTE WDISP_AccumulatorRow2_CopperIndexEnd;
extern UBYTE WDISP_AccumulatorRow3_CopperIndexEnd;

extern void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(LONG start, LONG end);
extern void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(LONG start, LONG end);

static void service_row(WORD *saturate, WORD *moveFlags, UBYTE *indexStart, UBYTE *indexEnd)
{
    if (*saturate != 1) {
        return;
    }
    if (*moveFlags == 0) {
        return;
    }

    *saturate = 0;
    if ((*moveFlags & 2) != 0) {
        ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd((LONG)*indexStart, (LONG)*indexEnd);
    } else {
        ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart((LONG)*indexStart, (LONG)*indexEnd);
    }
}

void ESQIFF_ServicePendingCopperPaletteMoves(void)
{
    service_row(&ACCUMULATOR_Row0_SaturateFlag, &WDISP_AccumulatorRow0_MoveFlags,
                &WDISP_AccumulatorRow0_CopperIndexStart, &WDISP_AccumulatorRow0_CopperIndexEnd);
    service_row(&ACCUMULATOR_Row1_SaturateFlag, &WDISP_AccumulatorRow1_MoveFlags,
                &WDISP_AccumulatorRow1_CopperIndexStart, &WDISP_AccumulatorRow1_CopperIndexEnd);
    service_row(&ACCUMULATOR_Row2_SaturateFlag, &WDISP_AccumulatorRow2_MoveFlags,
                &WDISP_AccumulatorRow2_CopperIndexStart, &WDISP_AccumulatorRow2_CopperIndexEnd);
    service_row(&ACCUMULATOR_Row3_SaturateFlag, &WDISP_AccumulatorRow3_MoveFlags,
                &WDISP_AccumulatorRow3_CopperIndexStart, &WDISP_AccumulatorRow3_CopperIndexEnd);
}
