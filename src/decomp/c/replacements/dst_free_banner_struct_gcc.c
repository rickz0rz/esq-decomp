#include "esq_types.h"

/*
 * Target 614 GCC trial function.
 * Free banner struct child buffers (if present) then free container.
 */
extern u8 Global_STR_DST_C_1[];
extern u8 Global_STR_DST_C_2[];
extern u8 Global_STR_DST_C_3[];

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, s32 line, void *ptr, u32 size) __attribute__((noinline));

void DST_FreeBannerStruct(void *banner) __attribute__((noinline, used));

void DST_FreeBannerStruct(void *banner)
{
    u8 *p = (u8 *)banner;

    if (p == (u8 *)0) {
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
