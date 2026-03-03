#include "esq_types.h"

extern u32 *ESQSHARED_LivePlaneBase0;
extern u32 *ESQSHARED_LivePlaneBase1;
extern u32 *ESQSHARED_LivePlaneBase2;

extern u32 *ESQPARS2_BannerSnapshotPlane0DstPtr;
extern u32 *ESQPARS2_BannerSnapshotPlane1DstPtr;
extern u32 *ESQPARS2_BannerSnapshotPlane2DstPtr;

void ESQSHARED4_CopyLivePlanesToSnapshot(void) __attribute__((noinline, used));

void ESQSHARED4_CopyLivePlanesToSnapshot(void)
{
    u32 *src;
    u32 *dst;
    u16 i;

    src = ESQSHARED_LivePlaneBase0;
    dst = ESQPARS2_BannerSnapshotPlane0DstPtr;
    for (i = 0; i <= 0x2B; ++i) {
        *dst++ = *src++;
    }

    src = ESQSHARED_LivePlaneBase1;
    dst = ESQPARS2_BannerSnapshotPlane1DstPtr;
    for (i = 0; i <= 0x2B; ++i) {
        *dst++ = *src++;
    }

    src = ESQSHARED_LivePlaneBase2;
    dst = ESQPARS2_BannerSnapshotPlane2DstPtr;
    for (i = 0; i <= 0x2B; ++i) {
        *dst++ = *src++;
    }
}
