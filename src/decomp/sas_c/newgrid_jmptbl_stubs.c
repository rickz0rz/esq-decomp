typedef signed long LONG;

extern LONG MATH_DivS32(LONG a, LONG b);
extern void *DATETIME_SecondsToStruct(LONG seconds, void *dt);
extern void GENERATE_GRID_DATE_STRING(char *outText);
extern void MEMORY_DeallocateMemory(void);
extern void DISPTEXT_FreeBuffers(void);
extern void MEMORY_AllocateMemory(void);
extern void DISPTEXT_InitBuffers(void);
extern void DATETIME_NormalizeStructToSeconds(void);
extern char *STR_CopyUntilAnyDelimN(char *src, char *dst, LONG maxLen, char *delims);
extern void WDISP_UpdateSelectionPreviewPanel(void);
extern LONG MATH_Mulu32(LONG a, LONG b);

LONG NEWGRID_JMPTBL_MATH_DivS32(LONG a, LONG b){return MATH_DivS32(a, b);}
void *NEWGRID_JMPTBL_DATETIME_SecondsToStruct(LONG seconds, void *dt){return DATETIME_SecondsToStruct(seconds, dt);}
void NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(char *outText){GENERATE_GRID_DATE_STRING(outText);}
void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(void){MEMORY_DeallocateMemory();}
void NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(void){DISPTEXT_FreeBuffers();}
void NEWGRID_JMPTBL_MEMORY_AllocateMemory(void){MEMORY_AllocateMemory();}
void NEWGRID_JMPTBL_DISPTEXT_InitBuffers(void){DISPTEXT_InitBuffers();}
void NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(void){DATETIME_NormalizeStructToSeconds();}
char *NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(char *src, char *dst, LONG maxLen, char *delims){return STR_CopyUntilAnyDelimN(src, dst, maxLen, delims);}
void NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel(void){WDISP_UpdateSelectionPreviewPanel();}
LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b){return MATH_Mulu32(a, b);}
