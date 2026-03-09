typedef signed long LONG;
typedef unsigned char UBYTE;

extern void DST_FreeBannerPair(void *pair);
extern void *DST_AllocateBannerStruct(void *banner);

typedef struct DST_BannerPair {
    void *primaryBanner;
    void *secondaryBanner;
} DST_BannerPair;

LONG DST_RebuildBannerPair(void *pair)
{
    DST_BannerPair *p = (DST_BannerPair *)pair;
    LONG ok = 0;

    DST_FreeBannerPair(p);

    p->primaryBanner = DST_AllocateBannerStruct(p->primaryBanner);
    if (p->primaryBanner != (void *)0) {
        p->secondaryBanner = DST_AllocateBannerStruct(p->secondaryBanner);
        if (p->primaryBanner != (void *)0) {
            ok = 1;
        }
    }

    if (ok == 0) {
        DST_FreeBannerPair(p);
    }

    return ok;
}
