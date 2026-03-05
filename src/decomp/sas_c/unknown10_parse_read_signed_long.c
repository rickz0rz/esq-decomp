typedef signed long LONG;
typedef unsigned char UBYTE;

LONG PARSE_ReadSignedLong(const UBYTE *in, LONG *out_value)
{
    const UBYTE *start = in;
    LONG value = 0;

    if (*in == (UBYTE)'+' || *in == (UBYTE)'-') {
        in++;
    }

    for (;;) {
        LONG digit = (LONG)(*in++) - (LONG)(UBYTE)'0';
        if (digit < 0 || digit > 9) {
            break;
        }
        value = value * 10 + digit;
    }

    if (*start == (UBYTE)'-') {
        value = -value;
    }

    *out_value = value;
    return (LONG)((in - 1) - start);
}
