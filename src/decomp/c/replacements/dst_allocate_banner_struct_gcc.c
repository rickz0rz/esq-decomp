#include "esq_types.h"

/*
 * Target 616 GCC trial function.
 * Recreate banner struct allocation with two child buffers and rollback on failure.
 */
extern u8 Global_STR_DST_C_4[];
extern u8 Global_STR_DST_C_5[];
extern u8 Global_STR_DST_C_6[];

void DST_FreeBannerStruct(void *banner) __attribute__((noinline));
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, s32 line, s32 bytes, u32 flags) __attribute__((noinline));

void *DST_AllocateBannerStruct(void *banner) __attribute__((noinline, used));

void *DST_AllocateBannerStruct(void *banner)
{
    u8 *p = (u8 *)banner;
    s32 ok = 0;

    DST_FreeBannerStruct(p);

    p = (u8 *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_4, 798, 18, 0x10001);
    if (p != (u8 *)0) {
        *(void **)(p + 0) = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_5, 803, 22, 0x10001);
        if (*(void **)(p + 0) != (void *)0) {
            *(void **)(p + 4) = GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_DST_C_6, 807, 22, 0x10001);
            if (*(void **)(p + 4) != (void *)0) {
                ok = 1;
                *(u16 *)(p + 16) = 0;
            }
        }
    }

    if (ok == 0) {
        DST_FreeBannerStruct(p);
    }

    return p;
}
