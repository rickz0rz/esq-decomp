typedef unsigned short UWORD;
typedef unsigned long ULONG;

void ESQSHARED4_CopyLongwordBlockDbfLoop(ULONG *src, ULONG *dst, UWORD count)
{
    do {
        *dst++ = *src++;
        count--;
    } while (count != 0xFFFF);
}
