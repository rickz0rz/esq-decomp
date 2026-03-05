typedef signed long LONG;
typedef unsigned char UBYTE;

extern void DST_FreeBannerPair(void *pair);
extern void *DST_AllocateBannerStruct(void *banner);

LONG DST_RebuildBannerPair(void *pair)
{
    UBYTE *p = (UBYTE *)pair;
    LONG ok = 0;

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
