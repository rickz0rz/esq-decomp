#include <exec/types.h>
extern ULONG ESQPARS2_BannerCopySourceOffset;
extern ULONG ESQPARS2_BannerCopyTailOffset;
extern ULONG ESQSHARED_BlitAddressOffset;
extern ULONG GCOMMAND_BannerRowByteOffsetCurrent;

static void copy_row_chunk(UBYTE *dst, UBYTE *src)
{
    int i;

    *((UWORD *)dst) = *((UWORD *)src);
    dst += 2;
    src += 2;

    for (i = 0; i < 18; i++) {
        *((ULONG *)dst) = *((ULONG *)src);
        dst += 4;
        src += 4;
    }
}

void ESQSHARED4_CopyBannerRowsWithByteOffset(UBYTE *base)
{
    UBYTE *dst;
    UBYTE *src;
    ULONG tail;
    int i;

    dst = base + ESQPARS2_BannerCopySourceOffset;
    src = dst + 0xB0;

    for (i = 0; i < 16; i++) {
        copy_row_chunk(dst, src);
        dst += ESQSHARED_BlitAddressOffset;
        src += ESQSHARED_BlitAddressOffset;
    }

    tail = GCOMMAND_BannerRowByteOffsetCurrent + ESQPARS2_BannerCopyTailOffset;
    src = base + tail;
    copy_row_chunk(dst, src);
}
