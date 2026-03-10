extern void ESQ_MoveCopperEntryTowardEnd(void);
extern void *BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr);
extern void BRUSH_FreeBrushList(void);
extern void BRUSH_FindType3Brush(void);

void ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(void){ESQ_MoveCopperEntryTowardEnd();}
void *ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(void *searchKey, void *listHeadPtr){return BRUSH_FindBrushByPredicate(searchKey, listHeadPtr);}
void ESQIFF_JMPTBL_BRUSH_FreeBrushList(void){BRUSH_FreeBrushList();}
void ESQIFF_JMPTBL_BRUSH_FindType3Brush(void){BRUSH_FindType3Brush();}
