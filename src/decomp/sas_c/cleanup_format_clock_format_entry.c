typedef unsigned char UBYTE;
typedef long LONG;

extern UBYTE CLOCK_FormatVariantCode;
extern UBYTE **Global_REF_STR_CLOCK_FORMAT;

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);

void CLEANUP_FormatClockFormatEntry(LONG slot_index, UBYTE *out)
{
    LONG variant;
    UBYTE *src;

    while (slot_index > 48) {
        slot_index -= 48;
    }

    GROUP_AG_JMPTBL_MATH_DivS32((LONG)CLOCK_FormatVariantCode, 30);
    variant = GROUP_AG_JMPTBL_MATH_DivS32((LONG)CLOCK_FormatVariantCode, 30);

    src = Global_REF_STR_CLOCK_FORMAT[slot_index];
    while ((*out++ = *src++) != 0) {
    }

    if (variant > 0) {
        LONG d;

        d = (LONG)(out[-2] - '0');
        variant += GROUP_AG_JMPTBL_MATH_Mulu32(d, 10);

        d = GROUP_AG_JMPTBL_MATH_DivS32(variant, 10);
        out[-2] = (UBYTE)(d + '0');

        d = GROUP_AG_JMPTBL_MATH_DivS32(variant, 10);
        out[-1] = (UBYTE)(d + '0');
    }
}
