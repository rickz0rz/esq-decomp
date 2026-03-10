typedef unsigned char UBYTE;

char *TEXTDISP_FindControlToken(const char *textPtr)
{
    const UBYTE CH_NUL = 0;
    const UBYTE MASK_CONTROL = 0x80;
    const UBYTE TOKEN_84 = 0x84;
    const UBYTE TOKEN_85 = 0x85;
    const UBYTE TOKEN_86 = 0x86;
    const UBYTE TOKEN_87 = 0x87;
    const UBYTE TOKEN_8C = 0x8C;
    const UBYTE TOKEN_8D = 0x8D;
    const UBYTE TOKEN_8F = 0x8F;
    const UBYTE TOKEN_90 = 0x90;
    const UBYTE TOKEN_93 = 0x93;
    const UBYTE TOKEN_99 = 0x99;
    const UBYTE TOKEN_9A = 0x9A;
    const UBYTE TOKEN_9B = 0x9B;
    const UBYTE TOKEN_A3 = 0xA3;

    while (*textPtr != CH_NUL) {
        UBYTE ch;

        if ((textPtr[0] & MASK_CONTROL) == 0) {
            textPtr += 1;
            continue;
        }

        ch = textPtr[0];
        if (ch == TOKEN_84 || ch == TOKEN_85 || ch == TOKEN_86 || ch == TOKEN_87 ||
            ch == TOKEN_8C || ch == TOKEN_8D || ch == TOKEN_8F || ch == TOKEN_90 ||
            ch == TOKEN_93 || ch == TOKEN_99 || ch == TOKEN_9A || ch == TOKEN_9B ||
            ch == TOKEN_A3) {
            return (char *)textPtr;
        }

        textPtr += 1;
    }

    return (char *)0;
}
