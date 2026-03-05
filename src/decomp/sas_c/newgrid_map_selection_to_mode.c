typedef signed long LONG;
typedef signed short WORD;
typedef unsigned long ULONG;

extern LONG GCOMMAND_NicheForceMode5Flag;
extern LONG GCOMMAND_NicheModeCycleCount;

extern LONG NEWGRID_IsGridReadyForInput(LONG gateSelector);
extern LONG NEWGRID_SelectNextMode(void);

LONG NEWGRID_MapSelectionToMode(LONG selection, WORD gateSelector)
{
    LONG mapped;

    if ((ULONG)selection >= 13UL) {
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
        if (NEWGRID_IsGridReadyForInput((LONG)gateSelector) != 0) {
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
