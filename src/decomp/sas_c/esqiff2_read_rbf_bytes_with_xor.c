typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef signed long LONG;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern LONG SCRIPT_ReadNextRbfByte(void);

UBYTE *ESQIFF2_ReadRbfBytesWithXor(UBYTE *dst, UWORD count, UBYTE *xor_accum)
{
    UWORD i = 0;

    while (i < count) {
        UBYTE v;

        ESQFUNC_WaitForClockChangeAndServiceUi();
        v = (UBYTE)SCRIPT_ReadNextRbfByte();
        *dst++ = v;
        *xor_accum ^= v;
        ++i;
    }

    return dst;
}
