typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void DST_BuildBannerTimeWord(void);
extern void ESQ_ReverseBitsIn6Bytes(void);
extern void ESQ_SetBit1Based(void);
extern void ESQ_AdjustBracketedHourInString(void);
extern void COI_EnsureAnimObjectAllocated(void);
extern unsigned char ESQ_WildcardMatch(char *str, char *pattern);
extern char *STR_SkipClass3Chars(char *s);
extern LONG ESQ_TestBit1Based(UBYTE *base, ULONG bitIndex);

void ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(void){DST_BuildBannerTimeWord();}
void ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(void){ESQ_ReverseBitsIn6Bytes();}
void ESQSHARED_JMPTBL_ESQ_SetBit1Based(void){ESQ_SetBit1Based();}
void ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(void){ESQ_AdjustBracketedHourInString();}
void ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(void){COI_EnsureAnimObjectAllocated();}
unsigned char ESQSHARED_JMPTBL_ESQ_WildcardMatch(const char *str, const char *pattern){return ESQ_WildcardMatch((char *)str, (char *)pattern);}
char *ESQSHARED_JMPTBL_STR_SkipClass3Chars(char *s){return STR_SkipClass3Chars(s);}
LONG ESQSHARED_JMPTBL_ESQ_TestBit1Based(UBYTE *base, ULONG bitIndex){return ESQ_TestBit1Based(base, bitIndex);}
