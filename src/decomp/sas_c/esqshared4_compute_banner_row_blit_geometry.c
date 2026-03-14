#include <exec/types.h>
extern ULONG ESQPARS2_BannerRowCount;
extern UWORD ESQPARS2_BannerRowWidthBytes;
extern UWORD ESQPARS2_BannerCopyBlockSpanBytes;
extern ULONG ESQPARS2_BannerRowCopySpanBytes;
extern ULONG ESQPARS2_BannerRowCopyStrideBytes;
extern ULONG ESQSHARED_BlitAddressOffset;
extern UWORD ESQPARS2_BannerRowCopyWordCount;
extern UWORD ESQPARS2_BannerCopyBlockWordLimit;

void ESQSHARED4_ComputeBannerRowBlitGeometry(void)
{
    ULONG d0;

    d0 = (ULONG)((UWORD)ESQPARS2_BannerRowCount) * 0x58UL;
    ESQPARS2_BannerRowCopySpanBytes = d0;

    d0 = (ULONG)((UWORD)ESQPARS2_BannerRowWidthBytes >> 3);
    ESQPARS2_BannerRowCopyStrideBytes = d0;
    d0 += 0x58UL;
    ESQSHARED_BlitAddressOffset = d0;

    d0 = (ULONG)(((UWORD)ESQPARS2_BannerCopyBlockSpanBytes >> 5) - 1U);
    ESQPARS2_BannerRowCopyWordCount = (UWORD)d0;

    d0 = ((ULONG)0x22U >> 1) - 1U;
    ESQPARS2_BannerCopyBlockWordLimit = (UWORD)d0;
}
