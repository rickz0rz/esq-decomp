#include <exec/types.h>
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2);
extern void DISPLIB_ApplyInlineAlignmentPadding(char *text, UBYTE alignCode);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);
extern LONG MEM_Move(UBYTE *src, UBYTE *dst, LONG length);
extern long WDISP_SPrintf(void);
extern void ESQ_SetCopperEffect_OffDisableHighlight(void);
extern char *STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);

LONG GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2)
{
    return TLIBA3_BuildDisplayContextForViewMode(viewMode, a1, a2);
}

void GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(char *text, UBYTE alignCode)
{
    DISPLIB_ApplyInlineAlignmentPadding(text, alignCode);
}

void GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition(void)
{
    ESQIFF_RunCopperRiseTransition();
}

void GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text)
{
    DISPLIB_DisplayTextAtPosition(rastPort, x, y, text);
}

LONG GROUP_AW_JMPTBL_MEM_Move(void *dst, const void *src, LONG n)
{
    return MEM_Move((UBYTE *)src, (UBYTE *)dst, n);
}

long GROUP_AW_JMPTBL_WDISP_SPrintf(void)
{
    return WDISP_SPrintf();
}

void GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(void)
{
    ESQ_SetCopperEffect_OffDisableHighlight();
}

char *GROUP_AW_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen)
{
    return STRING_CopyPadNul(dst, src, maxLen);
}
