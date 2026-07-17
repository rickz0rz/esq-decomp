#include <exec/types.h>

extern char *STRING_FindSubstring(const char *haystack, const char *needle);
extern long FORMAT_RawDoFmtWithScratchBuffer(char *fmt, long a, long b, long c, long d, long e, long f);
extern ULONG MATH_DivU32(ULONG dividend, ULONG divisor);
extern void PARSEINI_WriteRtcFromGlobals(void);
extern LONG MATH_Mulu32(LONG a, LONG b);

char *GROUP_AJ_JMPTBL_STRING_FindSubstring(const char *haystack, const char *needle){return STRING_FindSubstring(haystack, needle);}
long GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(char *fmt, long a, long b, long c, long d, long e, long f){return FORMAT_RawDoFmtWithScratchBuffer(fmt, a, b, c, d, e, f);}
ULONG GROUP_AJ_JMPTBL_MATH_DivU32(ULONG dividend, ULONG divisor){return MATH_DivU32(dividend, divisor);}
void GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(void){PARSEINI_WriteRtcFromGlobals();}
LONG GROUP_AJ_JMPTBL_MATH_Mulu32(LONG a, LONG b){return MATH_Mulu32(a, b);}
