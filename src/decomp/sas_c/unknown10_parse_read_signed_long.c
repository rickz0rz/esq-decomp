typedef signed long LONG;
typedef unsigned char UBYTE;

LONG PARSE_ReadSignedLong(const UBYTE *in, LONG *out_value)
{
    const UBYTE kPlusSign = (UBYTE)'+';
    const UBYTE kMinusSign = (UBYTE)'-';
    const UBYTE kDigitZero = (UBYTE)'0';
    const UBYTE *parseStart = in;
    LONG parsedValue = 0;

    if (*in == kPlusSign || *in == kMinusSign) {
        in++;
    }

    for (;;) {
        LONG digitValue = (LONG)(*in++) - (LONG)kDigitZero;
        if (digitValue < 0 || digitValue > 9) {
            break;
        }
        parsedValue = parsedValue * 10 + digitValue;
    }

    if (*parseStart == kMinusSign) {
        parsedValue = -parsedValue;
    }

    *out_value = parsedValue;
    return (LONG)((in - 1) - parseStart);
}
