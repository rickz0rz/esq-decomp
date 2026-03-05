typedef signed long LONG;
typedef short WORD;

extern WORD SCRIPT_CtrlLineAssertedFlag;
extern WORD SCRIPT_SerialShadowWord;

extern void SCRIPT_WriteCtrlShadowToSerdat(LONG dataWord);

void SCRIPT_DeassertCtrlLine(void)
{
    WORD w;

    SCRIPT_CtrlLineAssertedFlag = 0;
    w = SCRIPT_SerialShadowWord;
    w = (WORD)(w & (WORD)0xffdf);
    SCRIPT_SerialShadowWord = w;
    SCRIPT_WriteCtrlShadowToSerdat((LONG)w);
}
