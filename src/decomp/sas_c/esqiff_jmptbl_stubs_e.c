typedef signed long LONG;

extern void *BRUSH_PopBrushHead(void *head);
extern void *BRUSH_AllocBrushNode(const char *brushLabel, void *prevTail);
extern void ESQ_NoOp_006A(void);
extern void NEWGRID_ValidateSelectionCode(char *gridCtx, LONG code);

void *ESQIFF_JMPTBL_BRUSH_PopBrushHead(void *head){return BRUSH_PopBrushHead(head);}
void *ESQIFF_JMPTBL_BRUSH_AllocBrushNode(const char *brushLabel, void *prevTail){return BRUSH_AllocBrushNode(brushLabel, prevTail);}
void ESQIFF_JMPTBL_ESQ_NoOp_006A(void){ESQ_NoOp_006A();}
void ESQIFF_JMPTBL_NEWGRID_ValidateSelectionCode(char *gridCtx, LONG code){NEWGRID_ValidateSelectionCode(gridCtx, code);}
