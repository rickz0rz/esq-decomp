#include <exec/types.h>
#include <stdio.h>
extern UWORD __stdargs TESTFN(UBYTE *src);
static UBYTE buf[8];
int main(void) {
    static UBYTE vecs[6][3] = {{0,0,0},{0x1a,0x2b,0x3c},{0xff,0xff,0xff},{0x0f,0x00,0x0f},{0x12,0x34,0x56},{0xa5,0x5a,0xc3}};
    int i;
    for (i = 0; i < 6; i++) {
        buf[0]=vecs[i][0]; buf[1]=vecs[i][1]; buf[2]=vecs[i][2];
        printf("in=%02x%02x%02x ret=%08lx\n", vecs[i][0],vecs[i][1],vecs[i][2], (ULONG)TESTFN(buf));
    }
    return 0;
}
