extern void BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr);
extern void ESQ_NoOp_0074(void);
extern long STRING_CompareNoCaseN(const char *a, const char *b, long n);
extern void SCRIPT_AssertCtrlLineIfEnabled(void);

void ESQIFF_JMPTBL_BRUSH_PopulateBrushList(void *descriptorList, void **outHeadPtr){BRUSH_PopulateBrushList(descriptorList, outHeadPtr);}
void ESQIFF_JMPTBL_ESQ_NoOp_0074(void){ESQ_NoOp_0074();}
long ESQIFF_JMPTBL_STRING_CompareNoCaseN(const char *a, const char *b, long n){return STRING_CompareNoCaseN(a, b, n);}
void ESQIFF_JMPTBL_SCRIPT_AssertCtrlLineIfEnabled(void){SCRIPT_AssertCtrlLineIfEnabled();}
