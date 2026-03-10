typedef signed long LONG;
typedef unsigned long ULONG;

extern char *STRING_FindSubstring(const char *haystack, const char *needle);
extern void FORMAT_RawDoFmtWithScratchBuffer(void);
extern ULONG MATH_DivU32(ULONG dividend, ULONG divisor);
extern void PARSEINI_WriteRtcFromGlobals(void);
extern LONG MATH_Mulu32(LONG a, LONG b);

char *GROUP_AJ_JMPTBL_STRING_FindSubstring(const char *haystack, const char *needle){return STRING_FindSubstring(haystack, needle);}
void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(void){FORMAT_RawDoFmtWithScratchBuffer();}
ULONG GROUP_AJ_JMPTBL_MATH_DivU32(ULONG dividend, ULONG divisor){return MATH_DivU32(dividend, divisor);}
void GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(void){PARSEINI_WriteRtcFromGlobals();}
LONG GROUP_AJ_JMPTBL_MATH_Mulu32(LONG a, LONG b){return MATH_Mulu32(a, b);}
