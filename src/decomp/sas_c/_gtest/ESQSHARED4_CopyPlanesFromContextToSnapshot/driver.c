#include <exec/types.h>
#include <stdio.h>
extern void __stdargs TESTFN(ULONG **context);
extern ULONG *ESQPARS2_BannerSnapshotPlane0DstPtr, *ESQPARS2_BannerSnapshotPlane1DstPtr, *ESQPARS2_BannerSnapshotPlane2DstPtr;
static UBYTE ctx[64];
static ULONG s0[44], s1[44], s2[44], d0[44], d1[44], d2[44];
int main(void) {
    int i; ULONG h0=0,h1=0,h2=0; ULONG **cp;
    for (i=0;i<44;i++){ s0[i]=0x1000u+i*7u; s1[i]=0x2000u+i*13u; s2[i]=0x3000u+i*17u; d0[i]=0; d1[i]=0; d2[i]=0; }
    *(ULONG**)(ctx+20)=s0; *(ULONG**)(ctx+24)=s1; *(ULONG**)(ctx+28)=s2;
    ESQPARS2_BannerSnapshotPlane0DstPtr=d0; ESQPARS2_BannerSnapshotPlane1DstPtr=d1; ESQPARS2_BannerSnapshotPlane2DstPtr=d2;
    TESTFN((ULONG**)ctx);
    for (i=0;i<44;i++){ h0=h0*33+d0[i]; h1=h1*33+d1[i]; h2=h2*33+d2[i]; }
    cp=(ULONG**)(ctx+20);
    printf("d0=%08lx d1=%08lx d2=%08lx adv0=%ld adv1=%ld adv2=%ld\n",
           (ULONG)h0,(ULONG)h1,(ULONG)h2,
           (long)((ULONG*)cp[0]-s0),(long)((ULONG*)cp[1]-s1),(long)((ULONG*)cp[2]-s2));
    return 0;
}
