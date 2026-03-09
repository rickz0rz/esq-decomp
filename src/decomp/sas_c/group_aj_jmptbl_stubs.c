typedef signed long LONG;
typedef unsigned long ULONG;

extern void STRING_FindSubstring(void);
extern void FORMAT_RawDoFmtWithScratchBuffer(void);
extern ULONG MATH_DivU32(ULONG dividend, ULONG divisor);
extern void PARSEINI_WriteRtcFromGlobals(void);
extern LONG MATH_Mulu32(LONG a, LONG b);

void GROUP_AJ_JMPTBL_STRING_FindSubstring(void){STRING_FindSubstring();}
void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(void){FORMAT_RawDoFmtWithScratchBuffer();}
ULONG GROUP_AJ_JMPTBL_MATH_DivU32(ULONG dividend, ULONG divisor){return MATH_DivU32(dividend, divisor);}
void GROUP_AJ_JMPTBL_PARSEINI_WriteRtcFromGlobals(void){PARSEINI_WriteRtcFromGlobals();}
LONG GROUP_AJ_JMPTBL_MATH_Mulu32(LONG a, LONG b){return MATH_Mulu32(a, b);}
