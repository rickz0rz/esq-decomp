typedef unsigned char UBYTE;

extern void DST_FreeBannerStruct(void *banner);

void DST_FreeBannerPair(void *pair)
{
    UBYTE *p = (UBYTE *)pair;

    DST_FreeBannerStruct(*(void **)(p + 0));
    *(void **)(p + 0) = (void *)0;

    DST_FreeBannerStruct(*(void **)(p + 4));
    *(void **)(p + 4) = (void *)0;
}
