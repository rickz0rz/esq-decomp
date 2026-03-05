typedef unsigned char UBYTE;
typedef unsigned short UWORD;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern UBYTE ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(void);

UBYTE *ESQIFF2_ReadRbfBytesWithXor(UBYTE *dst, UWORD count, UBYTE *xor_accum)
{
    UWORD i = 0;

    while (i < count) {
        UBYTE v;

        ESQFUNC_WaitForClockChangeAndServiceUi();
        v = ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte();
        *dst++ = v;
        *xor_accum ^= v;
        ++i;
    }

    return dst;
}
