typedef signed long LONG;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern UBYTE Global_STR_DST_C_1[];
extern UBYTE Global_STR_DST_C_2[];
extern UBYTE Global_STR_DST_C_3[];

extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, ULONG size);

void DST_FreeBannerStruct(void *banner)
{
    UBYTE *p = (UBYTE *)banner;

    if (p == (UBYTE *)0) {
        return;
    }

    if (*(void **)(p + 0) != (void *)0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_1, 773, *(void **)(p + 0), 22);
    }

    if (*(void **)(p + 4) != (void *)0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_2, 777, *(void **)(p + 4), 22);
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_3, 779, p, 18);
}
