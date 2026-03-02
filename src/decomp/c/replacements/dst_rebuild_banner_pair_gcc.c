#include "esq_types.h"

/*
 * Target 617 GCC trial function.
 * Rebuild pair by freeing then re-allocating both banner struct slots.
 */
void DST_FreeBannerPair(void *pair) __attribute__((noinline));
void *DST_AllocateBannerStruct(void *banner) __attribute__((noinline));

s32 DST_RebuildBannerPair(void *pair) __attribute__((noinline, used));

s32 DST_RebuildBannerPair(void *pair)
{
    u8 *p = (u8 *)pair;
    s32 ok = 0;

    DST_FreeBannerPair(p);

    *(void **)(p + 0) = DST_AllocateBannerStruct(*(void **)(p + 0));
    if (*(void **)(p + 0) != (void *)0) {
        *(void **)(p + 4) = DST_AllocateBannerStruct(*(void **)(p + 4));
        if (*(void **)(p + 0) != (void *)0) {
            ok = 1;
        }
    }

    if (ok == 0) {
        DST_FreeBannerPair(p);
    }

    return ok;
}
