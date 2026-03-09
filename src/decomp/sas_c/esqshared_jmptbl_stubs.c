extern void DST_BuildBannerTimeWord(void);
extern void ESQ_ReverseBitsIn6Bytes(void);
extern void ESQ_SetBit1Based(void);
extern void ESQ_AdjustBracketedHourInString(void);
extern void COI_EnsureAnimObjectAllocated(void);
extern unsigned char ESQ_WildcardMatch(char *str, char *pattern);
extern char *STR_SkipClass3Chars(char *s);
extern void ESQ_TestBit1Based(void);

void ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(void){DST_BuildBannerTimeWord();}
void ESQSHARED_JMPTBL_ESQ_ReverseBitsIn6Bytes(void){ESQ_ReverseBitsIn6Bytes();}
void ESQSHARED_JMPTBL_ESQ_SetBit1Based(void){ESQ_SetBit1Based();}
void ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(void){ESQ_AdjustBracketedHourInString();}
void ESQSHARED_JMPTBL_COI_EnsureAnimObjectAllocated(void){COI_EnsureAnimObjectAllocated();}
unsigned char ESQSHARED_JMPTBL_ESQ_WildcardMatch(char *str, char *pattern){return ESQ_WildcardMatch(str, pattern);}
char *ESQSHARED_JMPTBL_STR_SkipClass3Chars(char *s){return STR_SkipClass3Chars(s);}
void ESQSHARED_JMPTBL_ESQ_TestBit1Based(void){ESQ_TestBit1Based();}
