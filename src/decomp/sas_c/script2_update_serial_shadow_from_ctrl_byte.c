#include <exec/types.h>
extern WORD SCRIPT_SerialInputLatch;
extern WORD SCRIPT_SerialShadowWord;

extern void SCRIPT_WriteCtrlShadowToSerdat(LONG dataWord);

void SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte)
{
    UBYTE b;
    WORD w;

    SCRIPT_SerialInputLatch = (WORD)ctrlByte;
    b = (UBYTE)(ctrlByte & 0x03);
    w = SCRIPT_SerialShadowWord;
    w = (WORD)(w & 0x00fc);
    b = (UBYTE)(b | (UBYTE)w);
    SCRIPT_SerialShadowWord = (WORD)b;
    SCRIPT_WriteCtrlShadowToSerdat((LONG)(WORD)b);
}
