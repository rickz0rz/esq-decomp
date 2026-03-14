#include <exec/types.h>
extern WORD ESQDISP_SecondaryLinePromotePendingFlag;
extern char *ESQIFF_SecondaryLineHeadPtr;
extern char *ESQIFF_PrimaryLineHeadPtr;
extern char *ESQIFF_SecondaryLineTailPtr;
extern char *ESQIFF_PrimaryLineTailPtr;

extern char *ESQIFF2_ClearLineHeadTailByMode(WORD mode);

void ESQDISP_PromoteSecondaryLineHeadTailIfMarked(void)
{
    if (ESQDISP_SecondaryLinePromotePendingFlag != 0) {
        ESQIFF2_ClearLineHeadTailByMode(1);
        ESQIFF_PrimaryLineHeadPtr = ESQIFF_SecondaryLineHeadPtr;
        ESQIFF_PrimaryLineTailPtr = ESQIFF_SecondaryLineTailPtr;
        ESQIFF_SecondaryLineHeadPtr = (char *)0;
        ESQIFF_SecondaryLineTailPtr = (char *)0;
    }

    ESQDISP_SecondaryLinePromotePendingFlag = 0;
}
