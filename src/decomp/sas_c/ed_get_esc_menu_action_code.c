typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastMenuInputChar;
extern UBYTE ED_LastKeyCode;
extern LONG ED_EditCursorOffset;

LONG ED_GetEscMenuActionCode(void)
{
    LONG d0;
    LONG idx;

    idx = ED_StateRingIndex;
    ED_LastMenuInputChar = ED_StateRingTable[(idx << 2) + idx + 1];

    d0 = (LONG)ED_LastKeyCode;
    d0 -= 3;
    if (d0 == 0) {
        return 8;
    }

    d0 -= 10;
    if (d0 == 0) {
        LONG sel = ED_EditCursorOffset;

        if (sel >= 6) {
            return 8;
        }

        switch (sel) {
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
