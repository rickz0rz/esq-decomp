#include <exec/types.h>
typedef struct DST_BannerPair {
    void *first;
    void *second;
} DST_BannerPair;

extern void DST_FreeBannerStruct(void *banner);

void DST_FreeBannerPair(void *pair)
{
    DST_BannerPair *pairView = (DST_BannerPair *)pair;

    DST_FreeBannerStruct(pairView->first);
    pairView->first = 0;

    DST_FreeBannerStruct(pairView->second);
    pairView->second = 0;
}
