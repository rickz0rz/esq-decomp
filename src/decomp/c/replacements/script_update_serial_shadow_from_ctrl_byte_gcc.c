#include "esq_types.h"

extern u16 SCRIPT_SerialInputLatch;
extern u16 SCRIPT_SerialShadowWord;

void SCRIPT_WriteCtrlShadowToSerdat(s32 data_word) __attribute__((noinline));

void SCRIPT_UpdateSerialShadowFromCtrlByte(u8 ctrl_byte) __attribute__((noinline, used));

void SCRIPT_UpdateSerialShadowFromCtrlByte(u8 ctrl_byte)
{
    u8 low2;
    u16 shadow;

    SCRIPT_SerialInputLatch = (u16)ctrl_byte;
    low2 = (u8)(ctrl_byte & 0x03u);

    shadow = SCRIPT_SerialShadowWord;
    shadow = (u16)(shadow & 0x00FCu);
    shadow = (u16)(shadow | (u16)low2);
    SCRIPT_SerialShadowWord = shadow;

    SCRIPT_WriteCtrlShadowToSerdat((s32)shadow);
}
