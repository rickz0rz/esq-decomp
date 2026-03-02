#include "esq_types.h"

extern s32 GCOMMAND_NicheForceMode5Flag;
extern s32 GCOMMAND_NicheModeCycleCount;

s32 NEWGRID_IsGridReadyForInput(s32 gate_selector) __attribute__((noinline));
s32 NEWGRID_SelectNextMode(void) __attribute__((noinline));

s32 NEWGRID_MapSelectionToMode(s32 selection, s16 gate_selector) __attribute__((noinline, used));

s32 NEWGRID_MapSelectionToMode(s32 selection, s16 gate_selector)
{
    s32 mapped;

    if ((u32)selection >= 13u) {
        return 0;
    }

    switch (selection) {
    case 0:
    case 12:
        mapped = 1;
        break;

    case 1:
        mapped = 2;
        break;

    case 2:
        mapped = 3;
        break;

    case 3:
        if (NEWGRID_IsGridReadyForInput((s32)gate_selector) != 0) {
            mapped = 11;
        } else {
            mapped = 4;
        }
        break;

    case 4:
        if (GCOMMAND_NicheForceMode5Flag != 0) {
            mapped = 5;
            GCOMMAND_NicheModeCycleCount = 0;
            break;
        }
        /* fall through */
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
        mapped = NEWGRID_SelectNextMode();
        break;

    case 11:
        mapped = 1;
        break;

    default:
        mapped = 0;
        break;
    }

    return mapped;
}
