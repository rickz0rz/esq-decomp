#include <exec/types.h>
void ESQSHARED4_CopyLongwordBlockDbfLoop(ULONG *src, ULONG *dst, UWORD count)
{
    do {
        *dst++ = *src++;
        count--;
    } while (count != 0xFFFF);
}
