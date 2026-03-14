#include <exec/types.h>
extern const char Global_STR_DST_C_1[];
extern const char Global_STR_DST_C_2[];
extern const char Global_STR_DST_C_3[];

extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, ULONG size);

typedef struct DST_BannerStruct {
    void *primaryBanner;
    void *secondaryBanner;
} DST_BannerStruct;

void DST_FreeBannerStruct(void *banner)
{
    DST_BannerStruct *p = (DST_BannerStruct *)banner;

    if (p == 0) {
        return;
    }

    if (p->primaryBanner) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_1, 773, p->primaryBanner, 22);
    }

    if (p->secondaryBanner) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_2, 777, p->secondaryBanner, 22);
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_DST_C_3, 779, p, 18);
}
