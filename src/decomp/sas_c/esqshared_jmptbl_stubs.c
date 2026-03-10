typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern void DST_BuildBannerTimeWord(void);
extern void ESQ_ReverseBitsIn6Bytes(UBYTE *dst, UBYTE *src);
extern void ESQ_SetBit1Based(UBYTE *base, ULONG bitIndex);
extern void ESQ_AdjustBracketedHourInString(char *text_ptr, LONG hour_offset);
extern void COI_EnsureAnimObjectAllocated(void *entry);
extern unsigned char ESQ_WildcardMatch(char *str, char *pattern);
extern char *STR_SkipClass3Chars(const char *s);
extern LONG ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex);

void ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(void){DST_BuildBannerTimeWord();}
void ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(UBYTE *dst, UBYTE *src){ESQ_ReverseBitsIn6Bytes(dst, src);}
void ESQSHARED_JMPTBL_ESQ_SetBit1Based(UBYTE *base, ULONG bitIndex){ESQ_SetBit1Based(base, bitIndex);}
void ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(char *text_ptr, LONG hour_offset){ESQ_AdjustBracketedHourInString(text_ptr, hour_offset);}
void ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(void *entry){COI_EnsureAnimObjectAllocated(entry);}
unsigned char ESQSHARED_JMPTBL_ESQ_WildcardMatch(const char *str, const char *pattern){return ESQ_WildcardMatch((char *)str, (char *)pattern);}
char *ESQSHARED_JMPTBL_STR_SkipClass3Chars(const char *s){return STR_SkipClass3Chars(s);}
LONG ESQSHARED_JMPTBL_ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex){return ESQ_TestBit1Based(base, bitIndex);}
