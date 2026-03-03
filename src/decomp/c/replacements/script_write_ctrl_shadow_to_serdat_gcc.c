#include "esq_types.h"

extern volatile u16 SERDAT;
extern u16 SCRIPT_SerialShadowWord;

void SCRIPT_WriteCtrlShadowToSerdat(s32 data_word) __attribute__((noinline, used));

void SCRIPT_WriteCtrlShadowToSerdat(s32 data_word)
{
    u16 v = (u16)(data_word & 0x00FF);
    v |= (u16)(1u << 8);
    SERDAT = v;
    SCRIPT_SerialShadowWord = v;
}
