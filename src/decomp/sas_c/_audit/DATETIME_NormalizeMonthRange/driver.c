#include <exec/types.h>
#include <stdio.h>
extern LONG __stdargs TESTFN(void *);
int main(void) {
    static ULONG a0[] = { 0x00000000UL, 0x00000001UL, 0x00000002UL, 0x00000003UL, 0x00000004UL, 0x00000007UL, 0x00000008UL, 0x0000000fUL, 0x00000010UL, 0x00000011UL, 0x00000018UL, 0x0000001fUL, 0x00000020UL, 0x00000021UL, 0x00000028UL, 0x0000002fUL, 0x00000030UL, 0x0000003fUL };
    static UBYTE buf0[64];
    int i, j, n = 18;
    for (i = 0; i < n; i++) {
        LONG r;
        ULONG d0 = 0;
        for (j = 0; j < 64; j++) buf0[j] = 0;
        for (j = 0; j < 39; j++) buf0[j] = (UBYTE)(a0[i] + j * 37 + 1);
        r = TESTFN((void *)buf0);
        for (j = 0; j < 48; j++) d0 = d0 * 33 + buf0[j];
        printf("%08lx -> %08lx\n", (ULONG)d0, (ULONG)r);
    }
    return 0;
}
