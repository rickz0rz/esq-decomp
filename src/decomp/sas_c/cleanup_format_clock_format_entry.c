typedef unsigned char UBYTE;
typedef long LONG;

enum {
    CLOCK_FORMAT_SLOTS_PER_BANK = 48,
    CLOCK_VARIANT_DIVISOR = 30,
    DECIMAL_BASE = 10
};

extern UBYTE CLOCK_FormatVariantCode;
extern const char *Global_REF_STR_CLOCK_FORMAT[];

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);

void CLEANUP_FormatClockFormatEntry(LONG slotIndex, char *out)
{
    LONG variant;
    LONG quotient;
    const char *src;

    while (slotIndex > CLOCK_FORMAT_SLOTS_PER_BANK) {
        slotIndex -= CLOCK_FORMAT_SLOTS_PER_BANK;
    }

    quotient = GROUP_AG_JMPTBL_MATH_DivS32((LONG)CLOCK_FormatVariantCode, CLOCK_VARIANT_DIVISOR);
    variant = (LONG)CLOCK_FormatVariantCode -
        GROUP_AG_JMPTBL_MATH_Mulu32(quotient, CLOCK_VARIANT_DIVISOR);

    src = Global_REF_STR_CLOCK_FORMAT[slotIndex];
    while ((*out++ = *src++) != 0) {
    }

    if (variant > 0) {
        LONG decimalDigit;

        decimalDigit = (LONG)(out[-2] - '0');
        variant += GROUP_AG_JMPTBL_MATH_Mulu32(decimalDigit, DECIMAL_BASE);

        quotient = GROUP_AG_JMPTBL_MATH_DivS32(variant, DECIMAL_BASE);
        out[-2] = (char)(quotient + '0');

        decimalDigit = variant - GROUP_AG_JMPTBL_MATH_Mulu32(quotient, DECIMAL_BASE);
        out[-1] = (char)(decimalDigit + '0');
    }
}
