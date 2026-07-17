#include <exec/types.h>
extern ULONG ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, ESQSHARED_LivePlaneBase2;
extern ULONG *ESQPARS2_BannerSnapshotPlane0DstPtr, *ESQPARS2_BannerSnapshotPlane1DstPtr, *ESQPARS2_BannerSnapshotPlane2DstPtr;
void __stdargs TESTFN(void)
{
    ULONG *src; ULONG *dst; UWORD i;
    src = (ULONG *)ESQSHARED_LivePlaneBase0; dst = ESQPARS2_BannerSnapshotPlane0DstPtr;
    for (i = 0; i <= 0x2B; i++) { *dst++ = *src++; }
    src = (ULONG *)ESQSHARED_LivePlaneBase1; dst = ESQPARS2_BannerSnapshotPlane1DstPtr;
    for (i = 0; i <= 0x2B; i++) { *dst++ = *src++; }
    src = (ULONG *)ESQSHARED_LivePlaneBase2; dst = ESQPARS2_BannerSnapshotPlane2DstPtr;
    for (i = 0; i <= 0x2B; i++) { *dst++ = *src++; }
}
