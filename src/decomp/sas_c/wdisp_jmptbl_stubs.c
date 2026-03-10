extern void ESQIFF_RestoreBasePaletteTriples(void);
extern void ESQFUNC_TrimTextToPixelWidthWordBoundary(void);
extern void GCOMMAND_ExpandPresetBlock(void);
extern void ESQIFF_QueueIffBrushLoad(void);
extern void ESQIFF_RunCopperDropTransition(void);
extern void *BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr);
extern void BRUSH_FreeBrushList(void);
extern unsigned long BRUSH_PlaneMaskForIndex(long planeIndex);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void ESQIFF_RenderWeatherStatusBrushSlice(void);
extern void BRUSH_SelectBrushSlot(void);
extern char *NEWGRID_DrawWrappedText(char *rastport, long x, long y, long max_width, char *text, long draw_enable);
extern void NEWGRID_ResetRowTable(void);

void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void){ESQIFF_RestoreBasePaletteTriples();}
void WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary(void){ESQFUNC_TrimTextToPixelWidthWordBoundary();}
void WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock(void){GCOMMAND_ExpandPresetBlock();}
void WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad(void){ESQIFF_QueueIffBrushLoad();}
void WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void){ESQIFF_RunCopperDropTransition();}
void *WDISP_JMPTBL_BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr){return BRUSH_FindBrushByPredicate(searchKey, listHeadPtr);}
void WDISP_JMPTBL_BRUSH_FreeBrushList(void){BRUSH_FreeBrushList();}
unsigned long WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(long planeIndex){return BRUSH_PlaneMaskForIndex(planeIndex);}
void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void){ESQ_SetCopperEffect_OnEnableHighlight();}
void WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(void){ESQIFF_RenderWeatherStatusBrushSlice();}
void WDISP_JMPTBL_BRUSH_SelectBrushSlot(void){BRUSH_SelectBrushSlot();}
char *WDISP_JMPTBL_NEWGRID_DrawWrappedText(char *rastport, long x, long y, long max_width, char *text, long draw_enable){return NEWGRID_DrawWrappedText(rastport, x, y, max_width, text, draw_enable);}
void WDISP_JMPTBL_NEWGRID_ResetRowTable(void){NEWGRID_ResetRowTable();}
