#include <exec/types.h>
#include <stdio.h>
extern LONG __stdargs TESTFN(LONG ch);
extern LONG Global_PrintfByteCount;
extern UBYTE *Global_PrintfBufferPtr;
static UBYTE testbuf[64];
int main(void) {
    static LONG inputs[] = { 0x41, 0x42, 0x30, 0x39, 0x7a, 0xff, 0x00, 0x2a };
    int i, n = 8; ULONG dig;
    Global_PrintfBufferPtr = testbuf; Global_PrintfByteCount = 0;
    for (i = 0; i < 64; i++) testbuf[i] = 0;
    for (i = 0; i < n; i++) {
        LONG r = TESTFN(inputs[i]);
        printf("in=%08lx ret=%08lx count=%08lx off=%08lx\n",
               (ULONG)inputs[i], (ULONG)r, (ULONG)Global_PrintfByteCount,
               (ULONG)(Global_PrintfBufferPtr - testbuf));
    }
    dig = 0; for (i = 0; i < 16; i++) dig = dig * 33 + testbuf[i];
    printf("bufdigest=%08lx\n", dig);
    return 0;
}
