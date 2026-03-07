typedef unsigned char UBYTE;
typedef long LONG;

enum {
    CLOCK_FORMAT_SLOTS_PER_BANK = 48,
    CLOCK_VARIANT_DIVISOR = 30,
    DECIMAL_BASE = 10
};

extern UBYTE CLOCK_FormatVariantCode;
extern UBYTE **Global_REF_STR_CLOCK_FORMAT;

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);

void CLEANUP_FormatClockFormatEntry(LONG slotIndex, UBYTE *out)
{
    LONG variant;
    UBYTE *src;

    while (slotIndex > CLOCK_FORMAT_SLOTS_PER_BANK) {
        slotIndex -= CLOCK_FORMAT_SLOTS_PER_BANK;
    }

    GROUP_AG_JMPTBL_MATH_DivS32((LONG)CLOCK_FormatVariantCode, CLOCK_VARIANT_DIVISOR);
    variant = GROUP_AG_JMPTBL_MATH_DivS32((LONG)CLOCK_FormatVariantCode, CLOCK_VARIANT_DIVISOR);

    src = Global_REF_STR_CLOCK_FORMAT[slotIndex];
    while ((*out++ = *src++) != 0) {
    }

    if (variant > 0) {
        LONG d;

        d = (LONG)(out[-2] - '0');
        variant += GROUP_AG_JMPTBL_MATH_Mulu32(d, DECIMAL_BASE);

        d = GROUP_AG_JMPTBL_MATH_DivS32(variant, DECIMAL_BASE);
        out[-2] = (UBYTE)(d + '0');

        d = GROUP_AG_JMPTBL_MATH_DivS32(variant, DECIMAL_BASE);
        out[-1] = (UBYTE)(d + '0');
    }
}
