typedef signed long LONG;

extern void ESQIFF_RestoreBasePaletteTriples(void);
extern long ESQFUNC_TrimTextToPixelWidthWordBoundary(char *rastport, long max_width, char *text);
extern void GCOMMAND_ExpandPresetBlock(unsigned char *packed);
extern void ESQIFF_QueueIffBrushLoad(void);
extern void ESQIFF_RunCopperDropTransition(void);
extern void *BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr);
extern void BRUSH_FreeBrushList(void **headPtr, LONG freeAll);
extern unsigned long BRUSH_PlaneMaskForIndex(long planeIndex);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void ESQIFF_RenderWeatherStatusBrushSlice(void);
extern long BRUSH_SelectBrushSlot(unsigned char *brush, long srcX0, long srcY0, long srcX1, long srcY1, char *dstRp, long forcedDstY);
extern char *NEWGRID_DrawWrappedText(char *rastport, long x, long y, long max_width, const char *text, long draw_enable);
extern void NEWGRID_ResetRowTable(void);

void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void){ESQIFF_RestoreBasePaletteTriples();}
long WDISP_JMPTBL_ESQFUNC_TrimTextToPixelWidthWordBoundary(char *rastport, long max_width, char *text){return ESQFUNC_TrimTextToPixelWidthWordBoundary(rastport, max_width, text);}
void WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock(unsigned char *packed){GCOMMAND_ExpandPresetBlock(packed);}
void WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad(void){ESQIFF_QueueIffBrushLoad();}
void WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void){ESQIFF_RunCopperDropTransition();}
void *WDISP_JMPTBL_BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr){return BRUSH_FindBrushByPredicate(searchKey, listHeadPtr);}
void WDISP_JMPTBL_BRUSH_FreeBrushList(void **headPtr, LONG freeAll){BRUSH_FreeBrushList(headPtr, freeAll);}
unsigned long WDISP_JMPTBL_BRUSH_PlaneMaskForIndex(long planeIndex){return BRUSH_PlaneMaskForIndex(planeIndex);}
void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void){ESQ_SetCopperEffect_OnEnableHighlight();}
void WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(void){ESQIFF_RenderWeatherStatusBrushSlice();}
long WDISP_JMPTBL_BRUSH_SelectBrushSlot(unsigned char *brush, long srcX0, long srcY0, long srcX1, long srcY1, char *dstRp, long forcedDstY){return BRUSH_SelectBrushSlot(brush, srcX0, srcY0, srcX1, srcY1, dstRp, forcedDstY);}
char *WDISP_JMPTBL_NEWGRID_DrawWrappedText(char *rastport, long x, long y, long max_width, const char *text, long draw_enable){return NEWGRID_DrawWrappedText(rastport, x, y, max_width, text, draw_enable);}
void WDISP_JMPTBL_NEWGRID_ResetRowTable(void){NEWGRID_ResetRowTable();}
