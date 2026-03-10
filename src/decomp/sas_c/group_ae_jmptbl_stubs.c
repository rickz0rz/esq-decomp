typedef signed long LONG;
typedef signed char BYTE;

extern LONG TLIBA_FindFirstWildcardMatchIndex(const char *wildcardPattern);
extern LONG SCRIPT_BuildTokenIndexMap(char *inputBytes, short *outIndexByToken, short tokenCount, const char *tokenTable, short maxScanCount, char terminatorByte, short fillMissingFlag);
extern LONG LADFUNC_ParseHexDigit(BYTE ch);
extern void SCRIPT_DeallocateBufferArray(void);
extern LONG WDISP_SPrintf(void);
extern void SCRIPT_AllocateBufferArray(void);
extern LONG TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG index);
extern void ESQPARS_ReplaceOwnedString(void);

LONG GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(const char *wildcardPattern){return TLIBA_FindFirstWildcardMatchIndex(wildcardPattern);}
LONG GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(char *inputBytes, short *outIndexByToken, short tokenCount, const char *tokenTable, short maxScanCount, char terminatorByte, short fillMissingFlag){return SCRIPT_BuildTokenIndexMap(inputBytes, outIndexByToken, tokenCount, tokenTable, maxScanCount, terminatorByte, fillMissingFlag);}
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(BYTE ch){return LADFUNC_ParseHexDigit(ch);}
void GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void){SCRIPT_DeallocateBufferArray();}
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(void){return WDISP_SPrintf();}
void GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(void){SCRIPT_AllocateBufferArray();}
LONG GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG index){return TEXTDISP_ComputeTimeOffset(groupCode, title, index);}
void GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void){ESQPARS_ReplaceOwnedString();}
