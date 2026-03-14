#include <exec/types.h>
extern WORD CTRL_HPreviousSample;
extern UBYTE CTRL_BUFFER[];

LONG ESQ_CaptureCtrlBit4StreamBufferByte(void)
{
    WORD idx;
    LONG value;

    idx = CTRL_HPreviousSample;
    value = (LONG)CTRL_BUFFER[(UWORD)idx];

    idx = (WORD)(idx + 1);
    if (idx == (WORD)0x01F4) {
        idx = 0;
    }
    CTRL_HPreviousSample = idx;

    return value;
}
