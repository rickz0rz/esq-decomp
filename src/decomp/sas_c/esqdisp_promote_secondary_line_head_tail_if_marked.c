typedef signed short WORD;

extern WORD ESQDISP_SecondaryLinePromotePendingFlag;
extern void *ESQIFF_SecondaryLineHeadPtr;
extern void *ESQIFF_PrimaryLineHeadPtr;
extern void *ESQIFF_SecondaryLineTailPtr;
extern void *ESQIFF_PrimaryLineTailPtr;

extern void ESQIFF2_ClearLineHeadTailByMode(WORD mode);

void ESQDISP_PromoteSecondaryLineHeadTailIfMarked(void)
{
    if (ESQDISP_SecondaryLinePromotePendingFlag != 0) {
        ESQIFF2_ClearLineHeadTailByMode(1);
        ESQIFF_PrimaryLineHeadPtr = ESQIFF_SecondaryLineHeadPtr;
        ESQIFF_PrimaryLineTailPtr = ESQIFF_SecondaryLineTailPtr;
        ESQIFF_SecondaryLineHeadPtr = 0;
        ESQIFF_SecondaryLineTailPtr = 0;
    }

    ESQDISP_SecondaryLinePromotePendingFlag = 0;
}
