typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG DATETIME_AdjustMonthIndex(void *ctx);
extern LONG DATETIME_NormalizeMonthRange(void *ctx);
extern LONG DST_ComputeBannerIndex(void *ctx, WORD arg2, UBYTE arg3);
extern LONG ESQFUNC_SelectAndApplyBrushForCurrentEntry(WORD useSecondarySelection);
extern void ESQIFF_RunCopperDropTransition(void);
extern LONG GRAPHICS_BltBitMapRastPort(void *bitMap, LONG sx, LONG sy, char *rastPort, LONG dx, LONG dy, LONG width, LONG height, LONG minterm, LONG mask);
extern void SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte);
extern void TEXTDISP_BuildChannelLabel(WORD includeOnPrefix);
extern void TEXTDISP_BuildEntryShortName(const char *entry, char *out);
extern void TEXTDISP_DrawChannelBanner(WORD mode, WORD drawMode);
extern void TEXTDISP_DrawInsetRectFrame(const char *text, WORD mode);
extern void TEXTDISP_FormatEntryTime(char *out, WORD entryIndex);
extern void TEXTDISP_TrimTextToPixelWidth(char *text, LONG maxWidth);
extern WORD TLIBA1_BuildClockFormatEntryIfVisible(WORD groupIndex, WORD modeIndex, char *outText, WORD style);
extern long TLIBA3_BuildDisplayContextForViewMode(long viewMode, long a1, long a2);
extern long TLIBA3_GetViewModeHeight(long viewModeIndex);

LONG GROUP_AD_JMPTBL_DATETIME_AdjustMonthIndex(void *ctx){return DATETIME_AdjustMonthIndex(ctx);}
LONG GROUP_AD_JMPTBL_DATETIME_NormalizeMonthRange(void *ctx){return DATETIME_NormalizeMonthRange(ctx);}
LONG GROUP_AD_JMPTBL_DST_ComputeBannerIndex(void *ctx, WORD arg2, UBYTE arg3){return DST_ComputeBannerIndex(ctx, arg2, arg3);}
LONG GROUP_AD_JMPTBL_ESQFUNC_SelectAndApplyBrushForCurrentEntry(LONG useSecondarySelection){return ESQFUNC_SelectAndApplyBrushForCurrentEntry((WORD)useSecondarySelection);}
void GROUP_AD_JMPTBL_ESQIFF_RunCopperDropTransition(void){ESQIFF_RunCopperDropTransition();}
LONG GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void *bitMap, LONG sx, LONG sy, char *rastPort, LONG dx, LONG dy, LONG width, LONG height, LONG minterm, LONG mask){return GRAPHICS_BltBitMapRastPort(bitMap, sx, sy, rastPort, dx, dy, width, height, minterm, mask);}
void GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(UBYTE ctrlByte){SCRIPT_UpdateSerialShadowFromCtrlByte(ctrlByte);}
void GROUP_AD_JMPTBL_TEXTDISP_BuildChannelLabel(WORD includeOnPrefix){TEXTDISP_BuildChannelLabel(includeOnPrefix);}
void GROUP_AD_JMPTBL_TEXTDISP_BuildEntryShortName(const char *entry, char *out){TEXTDISP_BuildEntryShortName(entry, out);}
void GROUP_AD_JMPTBL_TEXTDISP_DrawChannelBanner(WORD mode, WORD drawMode){TEXTDISP_DrawChannelBanner(mode, drawMode);}
void GROUP_AD_JMPTBL_TEXTDISP_DrawInsetRectFrame(const char *text, WORD mode){TEXTDISP_DrawInsetRectFrame(text, mode);}
void GROUP_AD_JMPTBL_TEXTDISP_FormatEntryTime(char *out, WORD entryIndex){TEXTDISP_FormatEntryTime(out, entryIndex);}
void GROUP_AD_JMPTBL_TEXTDISP_TrimTextToPixelWidth(char *text, LONG maxWidth){TEXTDISP_TrimTextToPixelWidth(text, maxWidth);}
WORD GROUP_AD_JMPTBL_TLIBA1_BuildClockFormatEntryIfVisible(WORD groupIndex, WORD modeIndex, char *outText, WORD style){return TLIBA1_BuildClockFormatEntryIfVisible(groupIndex, modeIndex, outText, style);}
long GROUP_AD_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(long viewMode, long a1, long a2){return TLIBA3_BuildDisplayContextForViewMode(viewMode, a1, a2);}
long GROUP_AD_JMPTBL_TLIBA3_GetViewModeHeight(long viewModeIndex){return TLIBA3_GetViewModeHeight(viewModeIndex);}
