extern short TEXTDISP_FindEntryIndexByWildcard(char *path);
extern long STRING_CompareN(const char *a, const char *b, long maxLen);
extern void ESQ_NoOp(void);
extern void TEXTDISP_DrawChannelBanner(void);

short ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(char *path){return TEXTDISP_FindEntryIndexByWildcard(path);}
long ESQIFF_JMPTBL_STRING_CompareN(const char *a, const char *b, long maxLen){return STRING_CompareN(a, b, maxLen);}
void ESQIFF_JMPTBL_ESQ_NoOp(void){ESQ_NoOp();}
void ESQIFF_JMPTBL_TEXTDISP_DrawChannelBanner(void){TEXTDISP_DrawChannelBanner();}
