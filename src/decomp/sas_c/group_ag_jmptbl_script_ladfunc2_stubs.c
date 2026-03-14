#include <exec/types.h>
extern WORD SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs);
extern void LADFUNC2_EmitEscapedStringToScratch(const char *src);

WORD GROUP_AG_JMPTBL_SCRIPT_BeginBannerCharTransition(LONG targetChar, LONG speedMs)
{
    return SCRIPT_BeginBannerCharTransition(targetChar, speedMs);
}

void GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(const char *src)
{
    LADFUNC2_EmitEscapedStringToScratch(src);
}
