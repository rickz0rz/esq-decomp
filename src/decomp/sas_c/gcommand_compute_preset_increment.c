typedef signed long LONG;
typedef unsigned short UWORD;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG a, LONG b);
extern UWORD GCOMMAND_DefaultPresetTable[];

LONG GCOMMAND_ComputePresetIncrement(LONG presetIndex, LONG span)
{
    LONG result = 0;

    if (presetIndex < 0 || presetIndex >= 16) {
        return result;
    }
    if (span <= 4) {
        return result;
    }

    {
        LONG baseValue = (LONG)GCOMMAND_DefaultPresetTable[presetIndex];
        LONG numerator = baseValue - 1;
        LONG denominator = span - 5;

        if (denominator <= 0) {
            return 0;
        }

        result = NEWGRID_JMPTBL_MATH_Mulu32(numerator, 1000);
        result = NEWGRID_JMPTBL_MATH_DivS32(result, denominator);
    }

    return result;
}
