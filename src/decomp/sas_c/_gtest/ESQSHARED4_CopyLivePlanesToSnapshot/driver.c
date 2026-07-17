#include <exec/types.h>
#include <stdio.h>
extern void __stdargs TESTFN(void);
extern ULONG ESQSHARED_LivePlaneBase0, ESQSHARED_LivePlaneBase1, ESQSHARED_LivePlaneBase2;
extern ULONG *ESQPARS2_BannerSnapshotPlane0DstPtr, *ESQPARS2_BannerSnapshotPlane1DstPtr, *ESQPARS2_BannerSnapshotPlane2DstPtr;
static ULONG src0[44], src1[44], src2[44];
static ULONG dst0[44], dst1[44], dst2[44];
int main(void) {
    int i; ULONG d0=0, d1=0, d2=0;
    for (i = 0; i < 44; i++) { src0[i] = 0x1000u + i*7u; src1[i] = 0x2000u + i*13u; src2[i] = 0x3000u + i*17u; }
    for (i = 0; i < 44; i++) { dst0[i] = 0; dst1[i] = 0; dst2[i] = 0; }
    ESQSHARED_LivePlaneBase0 = (ULONG)src0; ESQSHARED_LivePlaneBase1 = (ULONG)src1; ESQSHARED_LivePlaneBase2 = (ULONG)src2;
    ESQPARS2_BannerSnapshotPlane0DstPtr = dst0; ESQPARS2_BannerSnapshotPlane1DstPtr = dst1; ESQPARS2_BannerSnapshotPlane2DstPtr = dst2;
    TESTFN();
    for (i = 0; i < 44; i++) { d0 = d0*33 + dst0[i]; d1 = d1*33 + dst1[i]; d2 = d2*33 + dst2[i]; }
    printf("dst0=%08lx dst1=%08lx dst2=%08lx last=%08lx,%08lx,%08lx\n",
           (ULONG)d0, (ULONG)d1, (ULONG)d2, (ULONG)dst0[43], (ULONG)dst1[43], (ULONG)dst2[43]);
    return 0;
}
