#include <exec/types.h>
extern ULONG ESQPARS2_BannerRowCopySpanBytes;
extern ULONG ESQPARS2_BannerRowCopyStrideBytes;
extern ULONG ESQPARS2_ActiveCopperListSelectFlag;
extern ULONG ESQPARS2_BannerCopyTailOffset;
extern ULONG ESQPARS2_BannerCopySourceOffset;

extern UBYTE ESQ_CopperListBannerA;
extern UBYTE ESQ_CopperListBannerB;

extern UBYTE *ESQSHARED_BannerRowScratchRasterBase0;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase1;
extern UBYTE *ESQSHARED_BannerRowScratchRasterBase2;

void ESQSHARED4_CopyInterleavedRowWordsFromOffset(UBYTE *base);
void ESQSHARED4_CopyBannerRowsWithByteOffset(UBYTE *base);

void ESQSHARED4_BlitBannerRowsForActiveField(void)
{
    ULONG span;
    ULONG stride;
    UBYTE *base;

    span = ESQPARS2_BannerRowCopySpanBytes;
    stride = ESQPARS2_BannerRowCopyStrideBytes;

    if (ESQPARS2_ActiveCopperListSelectFlag == 0) {
        stride += 0x58UL;
        base = &ESQ_CopperListBannerA;
    } else {
        base = &ESQ_CopperListBannerB;
    }

    ESQPARS2_BannerCopyTailOffset = stride;
    ESQPARS2_BannerCopySourceOffset = span + stride;
    ESQSHARED4_CopyInterleavedRowWordsFromOffset(base);

    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase0);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase1);
    ESQSHARED4_CopyBannerRowsWithByteOffset(ESQSHARED_BannerRowScratchRasterBase2);
}
