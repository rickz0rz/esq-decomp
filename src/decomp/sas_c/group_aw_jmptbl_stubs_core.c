typedef signed long LONG;

extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2);
extern void DISPLIB_ApplyInlineAlignmentPadding(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);
extern void MEM_Move(void);
extern void WDISP_SPrintf(void);
extern void ESQ_SetCopperEffect_OffDisableHighlight(void);
extern void STRING_CopyPadNul(void);

LONG GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2)
{
    return TLIBA3_BuildDisplayContextForViewMode(viewMode, a1, a2);
}

void GROUP_AW_JMPTBL_DISPLIB_ApplyInlineAlignmentPadding(void)
{
    DISPLIB_ApplyInlineAlignmentPadding();
}

void GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition(void)
{
    ESQIFF_RunCopperRiseTransition();
}

void GROUP_AW_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text)
{
    DISPLIB_DisplayTextAtPosition(rastPort, x, y, text);
}

void GROUP_AW_JMPTBL_MEM_Move(void)
{
    MEM_Move();
}

void GROUP_AW_JMPTBL_WDISP_SPrintf(void)
{
    WDISP_SPrintf();
}

void GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(void)
{
    ESQ_SetCopperEffect_OffDisableHighlight();
}

void GROUP_AW_JMPTBL_STRING_CopyPadNul(void)
{
    STRING_CopyPadNul();
}
