#include <exec/types.h>
extern void LADFUNC2_EmitEscapedCharToScratch(LONG ch);

void LADFUNC2_EmitEscapedStringWithLimit(const char *src, LONG *cursor, LONG limit)
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
