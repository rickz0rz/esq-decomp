#include <exec/types.h>
extern LONG MATH_Mulu32(LONG a, LONG b);
extern LONG MATH_DivS32(LONG a, LONG b);
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

        result = MATH_Mulu32(numerator, 1000);
        result = MATH_DivS32(result, denominator);
    }

    return result;
}
