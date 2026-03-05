typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern UBYTE Global_STR_DST_C_4[];
extern UBYTE Global_STR_DST_C_5[];
extern UBYTE Global_STR_DST_C_6[];

extern void DST_FreeBannerStruct(void *banner);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);

void *DST_AllocateBannerStruct(void *banner)
{
    UBYTE *p = (UBYTE *)banner;
    LONG ok = 0;

    DST_FreeBannerStruct(p);

    p = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_4, 798, 18, 0x10001);
    if (p != (UBYTE *)0) {
        *(void **)(p + 0) = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_5, 803, 22, 0x10001);
        if (*(void **)(p + 0) != (void *)0) {
            *(void **)(p + 4) = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_6, 807, 22, 0x10001);
            if (*(void **)(p + 4) != (void *)0) {
                ok = 1;
                *(WORD *)(p + 16) = 0;
            }
        }
    }

    if (ok == 0) {
        DST_FreeBannerStruct(p);
    }

    return p;
}
