#include <exec/types.h>

extern LONG TLIBA_FindFirstWildcardMatchIndex(const char *wildcardPattern);
extern LONG SCRIPT_BuildTokenIndexMap(char *inputBytes, short *outIndexByToken, short tokenCount, const char *tokenTable, short maxScanCount, char terminatorByte, short fillMissingFlag);
extern const char *ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode);
extern LONG LADFUNC_ParseHexDigit(BYTE ch);
extern void SCRIPT_DeallocateBufferArray(void **outPtrs, WORD byteSize, WORD count);
extern long WDISP_SPrintf(char *out, const char *fmt, long a, long b, long c, long d, long e, long f);
extern void SCRIPT_AllocateBufferArray(void **outPtrs, WORD byteSize, WORD count);
extern LONG TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG index);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);

LONG GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(const char *wildcardPattern){return TLIBA_FindFirstWildcardMatchIndex(wildcardPattern);}
LONG GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(char *inputBytes, short *outIndexByToken, short tokenCount, const char *tokenTable, short maxScanCount, char terminatorByte, short fillMissingFlag){return SCRIPT_BuildTokenIndexMap(inputBytes, outIndexByToken, tokenCount, tokenTable, maxScanCount, terminatorByte, fillMissingFlag);}
const char *GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(LONG index, LONG mode){return ESQDISP_GetEntryAuxPointerByMode(index, mode);}
LONG GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(BYTE ch){return LADFUNC_ParseHexDigit(ch);}
void GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(void **outPtrs, WORD byteSize, WORD count){SCRIPT_DeallocateBufferArray(outPtrs, byteSize, count);}
/* WDISP_SPrintf is varargs (K&R, reads &fmt+1); forward a generous fixed set of
   args so the callee can pick up whatever the format string consumes. */
long GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, long a, long b, long c, long d, long e, long f){return WDISP_SPrintf(out, fmt, a, b, c, d, e, f);}
void GROUP_AE_JMPTBL_SCRIPT_AllocateBufferArray(void **outPtrs, WORD byteSize, WORD count){SCRIPT_AllocateBufferArray(outPtrs, byteSize, count);}
LONG GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG index){return TEXTDISP_ComputeTimeOffset(groupCode, title, index);}
char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText){return ESQPARS_ReplaceOwnedString(newText, oldText);}
