extern void NEWGRID_ShouldOpenEditor(void);
extern void ESQDISP_TestEntryGridEligibility(void);
extern void ESQIFF_RunCopperRiseTransition(void);
extern void CLEANUP_BuildAlignedStatusLine(void);
extern void CLEANUP_DrawInsetRectFrame(void);

void TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor(void){NEWGRID_ShouldOpenEditor();}
void TEXTDISP_JMPTBL_ESQDISP_TestEntryGridEligibility(void){ESQDISP_TestEntryGridEligibility();}
void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void){ESQIFF_RunCopperRiseTransition();}
void TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(void){CLEANUP_BuildAlignedStatusLine();}
void TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(void){CLEANUP_DrawInsetRectFrame();}
