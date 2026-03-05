typedef unsigned long ULONG;
typedef unsigned short UWORD;

extern ULONG ESQSHARED_LivePlaneBase0;
extern ULONG ESQSHARED_LivePlaneBase1;
extern ULONG ESQSHARED_LivePlaneBase2;

extern ULONG *ESQPARS2_BannerSnapshotPlane0DstPtr;
extern ULONG *ESQPARS2_BannerSnapshotPlane1DstPtr;
extern ULONG *ESQPARS2_BannerSnapshotPlane2DstPtr;

void ESQSHARED4_CopyLivePlanesToSnapshot(void)
{
    ULONG *src;
    ULONG *dst;
    UWORD i;

    src = (ULONG *)ESQSHARED_LivePlaneBase0;
    dst = ESQPARS2_BannerSnapshotPlane0DstPtr;
    for (i = 0; i <= 0x2B; i++) {
        *dst++ = *src++;
    }

    src = (ULONG *)ESQSHARED_LivePlaneBase1;
    dst = ESQPARS2_BannerSnapshotPlane1DstPtr;
    for (i = 0; i <= 0x2B; i++) {
        *dst++ = *src++;
    }

    src = (ULONG *)ESQSHARED_LivePlaneBase2;
    dst = ESQPARS2_BannerSnapshotPlane2DstPtr;
    for (i = 0; i <= 0x2B; i++) {
        *dst++ = *src++;
    }
}
