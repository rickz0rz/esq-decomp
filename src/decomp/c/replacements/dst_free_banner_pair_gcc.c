#include "esq_types.h"

/*
 * Target 615 GCC trial function.
 * Free both banner struct slots and clear pair pointers.
 */
void DST_FreeBannerStruct(void *banner) __attribute__((noinline));

void DST_FreeBannerPair(void *pair) __attribute__((noinline, used));

void DST_FreeBannerPair(void *pair)
{
    u8 *p = (u8 *)pair;

    DST_FreeBannerStruct(*(void **)(p + 0));
    *(void **)(p + 0) = (void *)0;

    DST_FreeBannerStruct(*(void **)(p + 4));
    *(void **)(p + 4) = (void *)0;
}
