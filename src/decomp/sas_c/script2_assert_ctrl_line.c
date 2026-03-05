typedef signed long LONG;
typedef short WORD;

extern WORD SCRIPT_CtrlLineAssertedFlag;
extern WORD SCRIPT_SerialShadowWord;

extern void SCRIPT_WriteCtrlShadowToSerdat(LONG dataWord);

void SCRIPT_AssertCtrlLine(void)
{
    WORD w;

    SCRIPT_CtrlLineAssertedFlag = 1;
    w = SCRIPT_SerialShadowWord;
    w = (WORD)(w | 0x0020);
    SCRIPT_SerialShadowWord = w;
    SCRIPT_WriteCtrlShadowToSerdat((LONG)w);
}
