#include "esq_types.h"

extern u32 ESQPARS2_BannerRowCount;
extern u32 ESQPARS2_BannerRowCopySpanBytes;
extern u16 ESQPARS2_BannerRowWidthBytes;
extern u32 ESQPARS2_BannerRowCopyStrideBytes;
extern u32 ESQSHARED_BlitAddressOffset;
extern u16 ESQPARS2_BannerCopyBlockSpanBytes;
extern u16 ESQPARS2_BannerRowCopyWordCount;
extern u16 ESQPARS2_BannerCopyBlockWordLimit;

void ESQSHARED4_ComputeBannerRowBlitGeometry(void) __attribute__((noinline, used));

void ESQSHARED4_ComputeBannerRowBlitGeometry(void)
{
    u32 value;

    value = ESQPARS2_BannerRowCount;
    value *= 0x58U;
    ESQPARS2_BannerRowCopySpanBytes = value;

    value = (u16)ESQPARS2_BannerRowWidthBytes;
    value >>= 3;
    ESQPARS2_BannerRowCopyStrideBytes = value;
    ESQSHARED_BlitAddressOffset = value + 0x58U;

    value = (u16)ESQPARS2_BannerCopyBlockSpanBytes;
    value >>= 5;
    value -= 1U;
    ESQPARS2_BannerRowCopyWordCount = (u16)value;

    value = 0x22U;
    value >>= 1;
    value -= 1U;
    ESQPARS2_BannerCopyBlockWordLimit = (u16)value;
}
