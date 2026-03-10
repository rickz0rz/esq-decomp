typedef signed long LONG;
typedef signed char BYTE;

extern LONG TLIBA_FindFirstWildcardMatchIndex(char *wildcardPattern);
extern void SCRIPT_BuildTokenIndexMap(void);
extern char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG LADFUNC_ParseHexDigit(BYTE ch);
extern void SCRIPT_DeallocateBufferArray(void);
extern void WDISP_SPrintf(void);
extern void SCRIPT_AllocateBufferArray(void);
extern void TEXTDISP_ComputeTimeOffset(void);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);

LONG GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(char *wildcardPattern){return TLIBA_FindFirstWildcardMatchIndex(wildcardPattern);}
void GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(void){SCRIPT_BuildTokenIndexMap();}
char *GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryAuxPointerByMode(index, mode);}
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(BYTE ch){return LADFUNC_ParseHexDigit(ch);}
void GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void){SCRIPT_DeallocateBufferArray();}
void GROUP_AE_JMPTBL_WDISP_SPrintf(void){WDISP_SPrintf();}
void GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(void){SCRIPT_AllocateBufferArray();}
void GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(void){TEXTDISP_ComputeTimeOffset();}
char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText){return ESQPARS_ReplaceOwnedString(newText, oldText);}
