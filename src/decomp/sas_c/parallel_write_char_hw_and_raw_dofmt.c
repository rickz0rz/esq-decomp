#include <exec/types.h>

extern volatile UBYTE CIAB_PRA;
extern volatile UBYTE CIAA_DDRB;
extern volatile UBYTE CIAA_PRB;

extern void *AbsExecBase;
/* base-first _LVO ABI. RawDoFmt(execBase; A0=fmt, A1=dataStream, A2=putChProc,
   A3=putChData). PARALLEL_WriteCharHw ignores PutChData, so it is passed NULL
   (the original leaves A3 undefined; the callback never reads it). */
extern void _LVORawDoFmt(void *execBase, char *fmt, void *args, void (*putc)(LONG), void *putChData);

void PARALLEL_WriteCharHw(LONG ch)
{
    UBYTE b = (UBYTE)ch;

    if (b == 0x0A) {
        for (;;) {
            UBYTE status = CIAB_PRA;
            if ((status & 1) == 0) {
                CIAA_DDRB = 0xFF;
                CIAA_PRB = 13;
                break;
            }
        }
    }

    for (;;) {
        UBYTE status = CIAB_PRA;
        if ((status & 1) == 0) {
            CIAA_DDRB = 0xFF;
            CIAA_PRB = b;
            break;
        }
    }
}

void PARALLEL_RawDoFmt(char *fmt, void *args)
{
    _LVORawDoFmt(AbsExecBase, fmt, args, PARALLEL_WriteCharHw, 0);
}
