#include <exec/types.h>
extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastMenuInputChar;
extern UBYTE ED_LastKeyCode;
extern LONG ED_EditCursorOffset;

LONG ED_GetEscMenuActionCode(void)
{
    LONG d0;

    ED_LastMenuInputChar =
        ED_StateRingTable[(ED_StateRingIndex << 2) + ED_StateRingIndex + 1];

    d0 = (LONG)ED_LastKeyCode;
    d0 -= 3;
    if (d0 == 0) {
        return 8;
    }

    d0 -= 10;
    if (d0 == 0) {
        d0 = ED_EditCursorOffset;
        if (d0 >= 6) {
            return 8;
        }

        switch (d0) {
        case 0: return 1;
        case 1: return 2;
        case 2: return 3;
        case 3: return 4;
        case 4: return 5;
        case 5: return 6;
        }

        return 8;
    }

    d0 -= 14;
    if (d0 == 0) {
        return 0;
    }

    d0 -= 0x80;
    if (d0 == 0) {
        if (ED_LastMenuInputChar == 'A') {
            return 9;
        }
    }

    return 10;
}
