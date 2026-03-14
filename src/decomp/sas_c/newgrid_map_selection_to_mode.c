#include <exec/types.h>
extern LONG GCOMMAND_NicheForceMode5Flag;
extern LONG GCOMMAND_NicheModeCycleCount;

extern LONG NEWGRID_IsGridReadyForInput(LONG gateSelector);
extern LONG NEWGRID_SelectNextMode(void);

LONG NEWGRID_MapSelectionToMode(LONG selection, WORD gateSelector)
{
    const ULONG SELECTION_LIMIT = 13UL;
    const LONG MAP_INVALID = 0;
    const LONG MAP_HOME = 1;
    const LONG MAP_NEXT_A = 2;
    const LONG MAP_NEXT_B = 3;
    const LONG MAP_READY = 11;
    const LONG MAP_FALLBACK = 4;
    const LONG MAP_FORCE = 5;
    LONG mapped;

    if ((ULONG)selection >= SELECTION_LIMIT) {
        return MAP_INVALID;
    }

    switch (selection) {
    case 0:
    case 12:
        mapped = MAP_HOME;
        break;
    case 1:
        mapped = MAP_NEXT_A;
        break;
    case 2:
        mapped = MAP_NEXT_B;
        break;
    case 3:
        if (NEWGRID_IsGridReadyForInput((LONG)gateSelector) != 0) {
            mapped = MAP_READY;
        } else {
            mapped = MAP_FALLBACK;
        }
        break;
    case 4:
        if (GCOMMAND_NicheForceMode5Flag != 0) {
            mapped = MAP_FORCE;
            GCOMMAND_NicheModeCycleCount = MAP_INVALID;
            break;
        }
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
        mapped = NEWGRID_SelectNextMode();
        break;
    case 11:
        mapped = MAP_HOME;
        break;
    default:
        mapped = MAP_INVALID;
        break;
    }

    return mapped;
}
