#include "dst_banner_types.h"

extern void DST_FreeBannerStruct(void *banner);

void DST_FreeBannerPair(void *pair)
{
    DST_BannerPair *pairView = (DST_BannerPair *)pair;

    DST_FreeBannerStruct(pairView->primaryBanner);
    pairView->primaryBanner = 0;

    DST_FreeBannerStruct(pairView->secondaryBanner);
    pairView->secondaryBanner = 0;
}
