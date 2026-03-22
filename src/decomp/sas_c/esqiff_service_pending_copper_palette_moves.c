#include <exec/types.h>
#include "wdisp_accumulator_rows.h"

extern WORD ACCUMULATOR_Row0_SaturateFlag;
extern WORD ACCUMULATOR_Row1_SaturateFlag;
extern WORD ACCUMULATOR_Row2_SaturateFlag;
extern WORD ACCUMULATOR_Row3_SaturateFlag;

extern WORD WDISP_AccumulatorRow0_MoveFlags;
extern WORD WDISP_AccumulatorRow1_MoveFlags;
extern WORD WDISP_AccumulatorRow2_MoveFlags;
extern WORD WDISP_AccumulatorRow3_MoveFlags;

extern void ESQ_MoveCopperEntryTowardEnd(LONG start, LONG end);
extern void ESQ_MoveCopperEntryTowardStart(LONG start, LONG end);

void ESQIFF_ServicePendingCopperPaletteMoves(void)
{
    if (ACCUMULATOR_Row0_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow0_MoveFlags != 0) {
            ACCUMULATOR_Row0_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow0_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd(
                    (LONG)WDISP_AccumulatorRowTable[0].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[0].copperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart(
                    (LONG)WDISP_AccumulatorRowTable[0].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[0].copperIndexEnd);
            }
        }
    }

    if (ACCUMULATOR_Row1_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow1_MoveFlags != 0) {
            ACCUMULATOR_Row1_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow1_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd(
                    (LONG)WDISP_AccumulatorRowTable[1].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[1].copperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart(
                    (LONG)WDISP_AccumulatorRowTable[1].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[1].copperIndexEnd);
            }
        }
    }

    if (ACCUMULATOR_Row2_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow2_MoveFlags != 0) {
            ACCUMULATOR_Row2_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow2_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd(
                    (LONG)WDISP_AccumulatorRowTable[2].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[2].copperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart(
                    (LONG)WDISP_AccumulatorRowTable[2].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[2].copperIndexEnd);
            }
        }
    }

    if (ACCUMULATOR_Row3_SaturateFlag == 1) {
        if (WDISP_AccumulatorRow3_MoveFlags != 0) {
            ACCUMULATOR_Row3_SaturateFlag = 0;
            if ((WDISP_AccumulatorRow3_MoveFlags & 2) != 0) {
                ESQ_MoveCopperEntryTowardEnd(
                    (LONG)WDISP_AccumulatorRowTable[3].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[3].copperIndexEnd);
            } else {
                ESQ_MoveCopperEntryTowardStart(
                    (LONG)WDISP_AccumulatorRowTable[3].copperIndexStart,
                    (LONG)WDISP_AccumulatorRowTable[3].copperIndexEnd);
            }
        }
    }
}
