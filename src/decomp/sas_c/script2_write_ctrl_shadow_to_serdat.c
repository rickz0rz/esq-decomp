#include <exec/types.h>
extern WORD SERDAT;
extern WORD SCRIPT_SerialShadowWord;

void SCRIPT_WriteCtrlShadowToSerdat(LONG dataWord)
{
    WORD w = (WORD)dataWord;
    w = (WORD)(w & 0x00ff);
    w = (WORD)(w | (1u << 8));
    SERDAT = w;
    SCRIPT_SerialShadowWord = w;
}
