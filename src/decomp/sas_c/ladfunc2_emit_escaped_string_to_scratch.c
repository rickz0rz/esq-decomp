typedef unsigned char UBYTE;
typedef signed long LONG;

extern void LADFUNC2_EmitEscapedCharToScratch(LONG ch);

void LADFUNC2_EmitEscapedStringToScratch(const char *src)
{
    if (src == (const char *)0) {
        return;
    }

    while (*src != 0) {
        LADFUNC2_EmitEscapedCharToScratch((LONG)(*src++));
    }
}
