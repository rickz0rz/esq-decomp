#include <exec/types.h>
extern WORD SCRIPT_CtrlLineAssertedFlag;

LONG SCRIPT_GetCtrlLineFlag(void)
{
    return (LONG)SCRIPT_CtrlLineAssertedFlag;
}
