#include <exec/types.h>
extern void ED1_WaitForFlagAndClearBit0(void);
extern LONG DOS_SystemTagList(LONG arg1, LONG arg2);

void GROUP_AT_JMPTBL_ED1_WaitForFlagAndClearBit0(void)
{
    ED1_WaitForFlagAndClearBit0();
}

LONG GROUP_AT_JMPTBL_DOS_SystemTagList(LONG arg1, LONG arg2)
{
    return DOS_SystemTagList(arg1, arg2);
}
