#ifndef DST_BANNER_TYPES_H
#define DST_BANNER_TYPES_H

#include <exec/types.h>

typedef struct DST_BannerStruct {
    UBYTE pad0[16];
    WORD countdown16;
} DST_BannerStruct;

typedef struct DST_BannerPair {
    DST_BannerStruct *primaryBanner;
    DST_BannerStruct *secondaryBanner;
} DST_BannerPair;

#endif
