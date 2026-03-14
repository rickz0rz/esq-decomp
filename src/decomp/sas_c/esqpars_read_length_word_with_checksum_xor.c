#include <exec/types.h>
extern UWORD ESQIFF_RecordLength;

extern void ESQFUNC_WaitForClockChangeAndServiceUi(void);
extern LONG SCRIPT_ReadNextRbfByte(void);

UBYTE ESQPARS_ReadLengthWordWithChecksumXor(UBYTE xor_seed)
{
    LONG i;
    UBYTE accum = xor_seed;
    UWORD length = 0;

    ESQIFF_RecordLength = 0;

    for (i = 0; i < 2; ++i) {
        UBYTE b;
        ESQFUNC_WaitForClockChangeAndServiceUi();
        b = (UBYTE)SCRIPT_ReadNextRbfByte();
        accum ^= b;
        length = (UWORD)((length << 8) | (UWORD)b);
        ESQIFF_RecordLength = length;
    }

    return accum;
}
