#include <exec/types.h>
typedef struct DST_BannerStruct {
    void *first;
    void *second;
    UBYTE pad8[8];
    WORD state16;
} DST_BannerStruct;

extern const char Global_STR_DST_C_4[];
extern const char Global_STR_DST_C_5[];
extern const char Global_STR_DST_C_6[];

extern void DST_FreeBannerStruct(void *banner);
extern void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);

void *DST_AllocateBannerStruct(void *banner)
{
    DST_BannerStruct *p = (DST_BannerStruct *)banner;
    LONG ok = 0;

    DST_FreeBannerStruct(p);

    p = (DST_BannerStruct *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_4, 798, 18, 0x10001);
    if (p) {
        p->first = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_5, 803, 22, 0x10001);
        if (p->first) {
            p->second = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_6, 807, 22, 0x10001);
            if (p->second) {
                ok = 1;
                p->state16 = 0;
            }
        }
    }

    if (ok == 0) {
        DST_FreeBannerStruct(p);
    }

    return p;
}
