#include <exec/types.h>
extern ULONG *ESQPARS2_BannerSnapshotPlane0DstPtr;
extern ULONG *ESQPARS2_BannerSnapshotPlane1DstPtr;
extern ULONG *ESQPARS2_BannerSnapshotPlane2DstPtr;

void ESQSHARED4_CopyPlanesFromContextToSnapshot(ULONG **context)
{
    ULONG *src;
    ULONG *dst;
    UWORD i;

    context = (ULONG **)((unsigned char *)context + 20);

    src = context[0];
    dst = ESQPARS2_BannerSnapshotPlane0DstPtr;
    for (i = 0; i <= 0x2B; i++) {
        *dst++ = *src++;
    }
    context[0] = src;

    src = context[1];
    dst = ESQPARS2_BannerSnapshotPlane1DstPtr;
    for (i = 0; i <= 0x2B; i++) {
        *dst++ = *src++;
    }
    context[1] = src;

    src = context[2];
    dst = ESQPARS2_BannerSnapshotPlane2DstPtr;
    for (i = 0; i <= 0x2B; i++) {
        *dst++ = *src++;
    }
    context[2] = src;
}
