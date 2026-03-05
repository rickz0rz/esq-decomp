extern void MATH_DivS32(void);
extern void DATETIME_SecondsToStruct(void);
extern void GENERATE_GRID_DATE_STRING(void);
extern void MEMORY_DeallocateMemory(void);
extern void DISPTEXT_FreeBuffers(void);
extern void MEMORY_AllocateMemory(void);
extern void DISPTEXT_InitBuffers(void);
extern void DATETIME_NormalizeStructToSeconds(void);
extern void STR_CopyUntilAnyDelimN(void);
extern void WDISP_UpdateSelectionPreviewPanel(void);
extern void MATH_Mulu32(void);

void NEWGRID_JMPTBL_MATH_DivS32(void){MATH_DivS32();}
void NEWGRID_JMPTBL_DATETIME_SecondsToStruct(void){DATETIME_SecondsToStruct();}
void NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(void){GENERATE_GRID_DATE_STRING();}
void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(void){MEMORY_DeallocateMemory();}
void NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(void){DISPTEXT_FreeBuffers();}
void NEWGRID_JMPTBL_MEMORY_AllocateMemory(void){MEMORY_AllocateMemory();}
void NEWGRID_JMPTBL_DISPTEXT_InitBuffers(void){DISPTEXT_InitBuffers();}
void NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(void){DATETIME_NormalizeStructToSeconds();}
void NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(void){STR_CopyUntilAnyDelimN();}
void NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel(void){WDISP_UpdateSelectionPreviewPanel();}
void NEWGRID_JMPTBL_MATH_Mulu32(void){MATH_Mulu32();}
