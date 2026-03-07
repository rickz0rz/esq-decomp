typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE ED_CustomPaletteTriplesDefaultTemplate24B[];
extern LONG ED_StateRingIndex;
extern UBYTE ED_StateRingTable[];
extern UBYTE ED_LastKeyCode;
extern UBYTE WDISP_CharClassTable[];
extern LONG ED_CustomPaletteCapturePhaseMod4;
extern LONG ED_CustomPaletteCaptureIndexOrSentinel;
extern UBYTE KYBD_CustomPaletteCaptureScratchBase[];
extern UBYTE KYBD_CustomPaletteTriplesRBase[];
extern UBYTE ED_MenuStateId;

extern LONG ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit(LONG keyCode);

void ED_CaptureKeySequence(void)
{
    UBYTE template24[24];
    LONG i;
    LONG ringOff;
    UBYTE key;
    LONG parsed;

    for (i = 0; i < 24; ++i) {
        template24[i] = ED_CustomPaletteTriplesDefaultTemplate24B[i];
    }

    ringOff = (ED_StateRingIndex << 2) + ED_StateRingIndex;
    key = ED_StateRingTable[ringOff];
    ED_LastKeyCode = key;

    if ((WDISP_CharClassTable[(LONG)key] & 0x80) != 0) {
        parsed = ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit((LONG)key);

        if (ED_CustomPaletteCapturePhaseMod4 == 0) {
            ED_CustomPaletteCaptureIndexOrSentinel = (LONG)(UBYTE)parsed;
        } else {
            LONG index = ED_CustomPaletteCaptureIndexOrSentinel;
            if (index >= 0 && index < 8 && parsed < 13) {
                LONG pos = (index << 2) - index + ED_CustomPaletteCapturePhaseMod4;
                KYBD_CustomPaletteCaptureScratchBase[pos] = (UBYTE)parsed;
            } else {
                ED_CustomPaletteCaptureIndexOrSentinel = -1;
            }
        }
    } else {
        ED_CustomPaletteCaptureIndexOrSentinel = -1;
    }

    ED_CustomPaletteCapturePhaseMod4 = (ED_CustomPaletteCapturePhaseMod4 + 1) % 4;
    if (ED_CustomPaletteCapturePhaseMod4 != 0) {
        return;
    }

    if (ED_CustomPaletteCaptureIndexOrSentinel < 0) {
        ED_CustomPaletteCaptureIndexOrSentinel = 0;
        for (i = 0; i < 24; ++i) {
            KYBD_CustomPaletteTriplesRBase[i] = template24[i];
            ED_CustomPaletteCaptureIndexOrSentinel = i + 1;
        }
    }

    ED_MenuStateId = 0;
}
