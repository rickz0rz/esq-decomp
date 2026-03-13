typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern signed long SCRIPT_ReadNextRbfByte(void);

UBYTE *ESQIFF2_ReadRbfBytesToBuffer(UBYTE *dst, UWORD count)
{
    UWORD i = 0;

    while (i < count) {
        UBYTE *slot = dst;
        dst++;
        ESQFUNC_WaitForClockChangeAndServiceUi();
        *slot = (UBYTE)SCRIPT_ReadNextRbfByte();
        ++i;
    }

    return dst;
}
