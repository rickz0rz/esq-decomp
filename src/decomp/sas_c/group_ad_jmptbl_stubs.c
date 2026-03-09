extern void DATETIME_AdjustMonthIndex(void);
extern void DATETIME_NormalizeMonthRange(void);
extern void DST_ComputeBannerIndex(void);
extern void ESQFUNC_SelectAndApplyBrushForCurrentEntry(void);
extern void ESQIFF_RunCopperDropTransition(void);
extern void GRAPHICS_BltBitMapRastPort(void);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(void);
extern void TEXTDISP_BuildChannelLabel(void);
extern void TEXTDISP_BuildEntryShortName(void);
extern void TEXTDISP_DrawChannelBanner(void);
extern void TEXTDISP_DrawInsetRectFrame(void);
extern void TEXTDISP_FormatEntryTime(void);
extern void TEXTDISP_TrimTextToPixelWidth(void);
extern void TLIBA1_BuildClockFormatEntryIfVisible(void);
extern long TLIBA3_BuildDisplayContextForViewMode(long viewMode, long a1, long a2);
extern long TLIBA3_GetViewModeHeight(long viewModeIndex);

void GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex(void){DATETIME_AdjustMonthIndex();}
void GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange(void){DATETIME_NormalizeMonthRange();}
void GROUP_AD_JMPTBL_DST_ComputeBannerIndex(void){DST_ComputeBannerIndex();}
void GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry(void){ESQFUNC_SelectAndApplyBrushForCurrentEntry();}
void GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition(void){ESQIFF_RunCopperDropTransition();}
void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void){GRAPHICS_BltBitMapRastPort();}
void GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(void){SCRIPT_UpdateSerialShadowFromCtrlByte();}
void GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel(void){TEXTDISP_BuildChannelLabel();}
void GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName(void){TEXTDISP_BuildEntryShortName();}
void GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner(void){TEXTDISP_DrawChannelBanner();}
void GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame(void){TEXTDISP_DrawInsetRectFrame();}
void GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime(void){TEXTDISP_FormatEntryTime();}
void GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth(void){TEXTDISP_TrimTextToPixelWidth();}
void GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(void){TLIBA1_BuildClockFormatEntryIfVisible();}
long GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(long viewMode, long a1, long a2){return TLIBA3_BuildDisplayContextForViewMode(viewMode, a1, a2);}
long GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight(long viewModeIndex){return TLIBA3_GetViewModeHeight(viewModeIndex);}
