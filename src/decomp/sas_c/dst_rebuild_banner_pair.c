#include "dst_banner_types.h"

extern void DST_FreeBannerPair(void *pair);
extern void *DST_AllocateBannerStruct(void *banner);

LONG DST_RebuildBannerPair(void *pair)
{
    DST_BannerPair *p = (DST_BannerPair *)pair;
    LONG ok = 0;

    DST_FreeBannerPair(p);

    p->primaryBanner = DST_AllocateBannerStruct(p->primaryBanner);
    if (p->primaryBanner) {
        p->secondaryBanner = DST_AllocateBannerStruct(p->secondaryBanner);
        if (p->primaryBanner) {
            ok = 1;
        }
    }

    if (ok == 0) {
        DST_FreeBannerPair(p);
    }

    return ok;
}
