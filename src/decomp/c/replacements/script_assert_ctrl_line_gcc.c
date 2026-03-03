#include "esq_types.h"

extern s16 SCRIPT_CtrlLineAssertedFlag;
extern u16 SCRIPT_SerialShadowWord;

void SCRIPT_WriteCtrlShadowToSerdat(s32 data_word) __attribute__((noinline));

void SCRIPT_AssertCtrlLine(void) __attribute__((noinline, used));

void SCRIPT_AssertCtrlLine(void)
{
    u16 v;

    SCRIPT_CtrlLineAssertedFlag = 1;
    v = SCRIPT_SerialShadowWord;
    v = (u16)(v | 0x0020u);
    SCRIPT_SerialShadowWord = v;
    SCRIPT_WriteCtrlShadowToSerdat((s32)v);
}
