typedef unsigned char UBYTE;
typedef signed long LONG;

extern void LADFUNC2_EmitEscapedCharToScratch(LONG ch);

void LADFUNC2_EmitEscapedStringWithLimit(const UBYTE *src, LONG *cursor, LONG limit)
{
    while (*src != 0) {
        LONG cur = *cursor;
        *cursor = cur + 1;
        if (cur >= limit) {
            return;
        }
        LADFUNC2_EmitEscapedCharToScratch((LONG)(*src++));
    }
}
