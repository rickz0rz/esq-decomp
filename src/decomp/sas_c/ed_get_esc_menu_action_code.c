typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastMenuInputChar;
extern UBYTE ED_LastKeyCode;
extern LONG ED_EditCursorOffset;

LONG ED_GetEscMenuActionCode(void)
{
    const LONG RING_STRIDE = 2;
    const LONG RING_EXTRA = 1;
    const LONG KEY_OFFSET_3 = 3;
    const LONG KEY_OFFSET_10 = 10;
    const LONG KEY_OFFSET_14 = 14;
    const LONG KEY_OFFSET_80 = 0x80;
    const LONG CURSOR_MAX_MENU = 6;
    const LONG ACTION_NONE = 0;
    const LONG ACTION_FALLBACK = 8;
    const LONG ACTION_MENU_A = 9;
    const LONG ACTION_MENU_B = 10;
    LONG d0;
    LONG idx;

    idx = ED_StateRingIndex;
    ED_LastMenuInputChar = ED_StateRingTable[(idx << RING_STRIDE) + idx + RING_EXTRA];

    d0 = (LONG)ED_LastKeyCode;
    d0 -= KEY_OFFSET_3;
    if (d0 == 0) {
        return ACTION_FALLBACK;
    }

    d0 -= KEY_OFFSET_10;
    if (d0 == 0) {
        LONG sel = ED_EditCursorOffset;

        if (sel >= CURSOR_MAX_MENU) {
            return ACTION_FALLBACK;
        }

        switch (sel) {
        case 0: return 1;
        case 1: return 2;
        case 2: return 3;
        case 3: return 4;
        case 4: return 5;
        case 5: return 6;
        }

        return ACTION_FALLBACK;
    }

    d0 -= KEY_OFFSET_14;
    if (d0 == 0) {
        return ACTION_NONE;
    }

    d0 -= KEY_OFFSET_80;
    if (d0 == 0) {
        if (ED_LastMenuInputChar == 'A') {
            return ACTION_MENU_A;
        }
    }

    return ACTION_MENU_B;
}
