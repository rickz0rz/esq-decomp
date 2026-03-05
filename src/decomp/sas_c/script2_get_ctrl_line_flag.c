typedef signed long LONG;
typedef short WORD;

extern WORD SCRIPT_CtrlLineAssertedFlag;

LONG SCRIPT_GetCtrlLineFlag(void)
{
    return (LONG)SCRIPT_CtrlLineAssertedFlag;
}
