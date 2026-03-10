typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE ED_CustomPaletteTriplesDefaultTemplate24B[];
extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;
extern const UBYTE WDISP_CharClassTable[];
extern LONG ED_CustomPaletteCapturePhaseMod4;
extern LONG ED_CustomPaletteCaptureIndexOrSentinel;
extern UBYTE KYBD_CustomPaletteCaptureScratchBase[];
extern UBYTE KYBD_CustomPaletteTriplesRBase[];
extern UBYTE ED_MenuStateId;

extern LONG ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(LONG keyCode);

void ED_CaptureKeySequence(void)
{
    const LONG TEMPLATE_SIZE = 24;
    const LONG RING_STRIDE_SHIFT = 2;
    const LONG HEX_CLASS_MASK = 0x80;
    const LONG CAPTURE_PHASE_WRAP = 4;
    const LONG CAPTURE_INDEX_MAX = 8;
    const LONG HEX_VALUE_LIMIT = 13;
    const LONG INDEX_INVALID = -1;
    const LONG MENU_STATE_DEFAULT = 0;
    UBYTE template24[24];
    LONG i;
    LONG ringOff;
    UBYTE key;
    LONG parsed;

    for (i = 0; i < TEMPLATE_SIZE; ++i) {
        template24[i] = ED_CustomPaletteTriplesDefaultTemplate24B[i];
    }

    ringOff = (ED_StateRingIndex << RING_STRIDE_SHIFT) + ED_StateRingIndex;
    key = ED_StateRingTable[ringOff];
    ED_LastKeyCode = key;

    if ((WDISP_CharClassTable[(LONG)key] & HEX_CLASS_MASK) != 0) {
        parsed = ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit((LONG)key);

        if (ED_CustomPaletteCapturePhaseMod4 == 0) {
            ED_CustomPaletteCaptureIndexOrSentinel = (LONG)(UBYTE)parsed;
        } else {
            LONG index = ED_CustomPaletteCaptureIndexOrSentinel;
            if (index >= MENU_STATE_DEFAULT && index < CAPTURE_INDEX_MAX && parsed < HEX_VALUE_LIMIT) {
                LONG pos = (index << RING_STRIDE_SHIFT) - index + ED_CustomPaletteCapturePhaseMod4;
                KYBD_CustomPaletteCaptureScratchBase[pos] = (UBYTE)parsed;
            } else {
                ED_CustomPaletteCaptureIndexOrSentinel = INDEX_INVALID;
            }
        }
    } else {
        ED_CustomPaletteCaptureIndexOrSentinel = INDEX_INVALID;
    }

    ED_CustomPaletteCapturePhaseMod4 = (ED_CustomPaletteCapturePhaseMod4 + 1) % CAPTURE_PHASE_WRAP;
    if (ED_CustomPaletteCapturePhaseMod4 != MENU_STATE_DEFAULT) {
        return;
    }

    if (ED_CustomPaletteCaptureIndexOrSentinel < MENU_STATE_DEFAULT) {
        ED_CustomPaletteCaptureIndexOrSentinel = MENU_STATE_DEFAULT;
        for (i = 0; i < TEMPLATE_SIZE; ++i) {
            KYBD_CustomPaletteTriplesRBase[i] = template24[i];
            ED_CustomPaletteCaptureIndexOrSentinel = i + 1;
        }
    }

    ED_MenuStateId = MENU_STATE_DEFAULT;
}
