typedef unsigned char UBYTE;

UBYTE *TEXTDISP_FindControlToken(UBYTE *textPtr)
{
    while (*textPtr != 0) {
        UBYTE ch;

        if ((textPtr[0] & 0x80) == 0) {
            textPtr += 1;
            continue;
        }

        ch = textPtr[0];
        if (ch == 0x84 || ch == 0x85 || ch == 0x86 || ch == 0x87 ||
            ch == 0x8C || ch == 0x8D || ch == 0x8F || ch == 0x90 ||
            ch == 0x93 || ch == 0x99 || ch == 0x9A || ch == 0x9B ||
            ch == 0xA3) {
            return textPtr;
        }

        textPtr += 1;
    }

    return (UBYTE *)0;
}
