#include <exec/types.h>
extern UBYTE ED_LastKeyCode;
extern LONG ED_TempCopyOffset;
extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastMenuInputChar;

extern UBYTE GCOMMAND_PresetFallbackValue0[];
extern UBYTE GCOMMAND_PresetFallbackValue1[];
extern UBYTE GCOMMAND_PresetFallbackValue2[];

extern void ED_DrawESCMenuBottomHelp(void);
extern void ESQSHARED4_LoadDefaultPaletteToCopper_NoOp(void);
extern void ED_DrawDiagnosticRegisterValues(void);

static void ED_IncNibble(UBYTE *base)
{
    UBYTE prev = *base;
    *base = (UBYTE)(*base + 1);
    if (prev >= 15) {
        *base = 0;
    }
}

static void ED_DecNibble(UBYTE *base)
{
    *base = (UBYTE)(*base - 1);
    if (*base > 15) {
        *base = 15;
    }
}

static LONG ED_DiagIndex3(void)
{
    LONG idx = ED_TempCopyOffset;
    return (idx << 2) - idx;
}

void ED_HandleDiagnosticNibbleEdit(void)
{
    LONG idx3;

    switch ((LONG)ED_LastKeyCode) {
        case 13:
        case 27:
            ED_DrawESCMenuBottomHelp();
            return;

        case 66:
            idx3 = ED_DiagIndex3();
            ED_IncNibble(&GCOMMAND_PresetFallbackValue2[idx3]);
            break;

        case 71:
            idx3 = ED_DiagIndex3();
            ED_IncNibble(&GCOMMAND_PresetFallbackValue1[idx3]);
            break;

        case 82:
            idx3 = ED_DiagIndex3();
            ED_IncNibble(&GCOMMAND_PresetFallbackValue0[idx3]);
            break;

        case 98:
            idx3 = ED_DiagIndex3();
            ED_DecNibble(&GCOMMAND_PresetFallbackValue2[idx3]);
            break;

        case 103:
            idx3 = ED_DiagIndex3();
            ED_DecNibble(&GCOMMAND_PresetFallbackValue1[idx3]);
            break;

        case 114:
            idx3 = ED_DiagIndex3();
            ED_DecNibble(&GCOMMAND_PresetFallbackValue0[idx3]);
            break;

        case 155: {
            LONG ringOff = (ED_StateRingIndex << 2) + ED_StateRingIndex;
            UBYTE menuChar = ED_StateRingTable[ringOff + 1];
            ED_LastMenuInputChar = menuChar;

            if (menuChar == 68) {
                --ED_TempCopyOffset;
                if (ED_TempCopyOffset < 0) {
                    ED_TempCopyOffset = 39;
                }
            } else {
                ++ED_TempCopyOffset;
                if (ED_TempCopyOffset == 40) {
                    ED_TempCopyOffset = 0;
                }
            }
            break;
        }

        default:
            ++ED_TempCopyOffset;
            if (ED_TempCopyOffset == 40) {
                ED_TempCopyOffset = 0;
            }
            break;
    }

    if (ED_TempCopyOffset >= 0 && ED_TempCopyOffset < 40) {
        ESQSHARED4_LoadDefaultPaletteToCopper_NoOp();
    }

    ED_DrawDiagnosticRegisterValues();
}
