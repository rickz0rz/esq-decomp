typedef signed long LONG;
typedef unsigned char UBYTE;

LONG PARSE_ReadSignedLong(const UBYTE *in, LONG *out_value)
{
    const UBYTE *parseStart = in;
    LONG parsedValue = 0;

    if (*in == (UBYTE)'+' || *in == (UBYTE)'-') {
        in++;
    }

    for (;;) {
        LONG digitValue = (LONG)(*in++) - (LONG)(UBYTE)'0';
        if (digitValue < 0 || digitValue > 9) {
            break;
        }
        parsedValue = parsedValue * 10 + digitValue;
    }

    if (*parseStart == (UBYTE)'-') {
        parsedValue = -parsedValue;
    }

    *out_value = parsedValue;
    return (LONG)((in - 1) - parseStart);
}
