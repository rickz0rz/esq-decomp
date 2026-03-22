#include <exec/types.h>

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

extern void ESQ_MoveCopperEntryTowardEnd(LONG start, LONG end);
extern void ESQ_MoveCopperEntryTowardStart(LONG start, LONG end);

void ESQIFF_ServicePendingCopperPaletteMoves(void)
{
    if (ACCUMULATOR_Row0_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow0_MoveFlags != 0) {
            ACCUMULATOR_Row0_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow0_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd((LONG)WDISP_AccumulatorRow0_CopperIndexStart,
                                             (LONG)WDISP_AccumulatorRow0_CopperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart((LONG)WDISP_AccumulatorRow0_CopperIndexStart,
                                               (LONG)WDISP_AccumulatorRow0_CopperIndexEnd);
            }
        }
    }

    if (ACCUMULATOR_Row1_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow1_MoveFlags != 0) {
            ACCUMULATOR_Row1_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow1_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd((LONG)WDISP_AccumulatorRow1_CopperIndexStart,
                                             (LONG)WDISP_AccumulatorRow1_CopperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart((LONG)WDISP_AccumulatorRow1_CopperIndexStart,
                                               (LONG)WDISP_AccumulatorRow1_CopperIndexEnd);
            }
        }
    }

    if (ACCUMULATOR_Row2_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow2_MoveFlags != 0) {
            ACCUMULATOR_Row2_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow2_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd((LONG)WDISP_AccumulatorRow2_CopperIndexStart,
                                             (LONG)WDISP_AccumulatorRow2_CopperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart((LONG)WDISP_AccumulatorRow2_CopperIndexStart,
                                               (LONG)WDISP_AccumulatorRow2_CopperIndexEnd);
            }
        }
    }

    if (ACCUMULATOR_Row3_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow3_MoveFlags != 0) {
            ACCUMULATOR_Row3_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow3_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd((LONG)WDISP_AccumulatorRow3_CopperIndexStart,
                                             (LONG)WDISP_AccumulatorRow3_CopperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart((LONG)WDISP_AccumulatorRow3_CopperIndexStart,
                                               (LONG)WDISP_AccumulatorRow3_CopperIndexEnd);
            }
        }
    }
}
