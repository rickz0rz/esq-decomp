#include <exec/types.h>
#include <stdio.h>
extern ULONG __stdargs TESTFN(long);
int main(void) {
    static ULONG a0[] = { 0x00000000UL, 0x00000001UL, 0x00000002UL, 0x0000000aUL, 0x0000001fUL, 0x00000020UL, 0x0000002fUL, 0x00000039UL, 0x00000041UL, 0x00000060UL, 0x00000061UL, 0x0000007aUL, 0x0000007fUL, 0x00000080UL, 0x000000ffUL, 0x00000100UL, 0x00007fffUL, 0x00008000UL, 0x0000ffffUL, 0x11223344UL, 0x7fffffffUL, 0x80000000UL, 0xdeadbeefUL, 0xffffffffUL };
    int i, n = 24;
    for (i = 0; i < n; i++) {
        ULONG r = TESTFN((long)a0[i]);
        printf("%08lx -> %08lx\n", (ULONG)a0[i], (ULONG)r);
    }
    return 0;
}
