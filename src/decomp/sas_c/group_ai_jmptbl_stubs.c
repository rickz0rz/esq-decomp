typedef signed long LONG;

extern void NEWGRID_SetSelectionMarkers(LONG a, LONG b, char *m3, char *m2, char *m1, char *m0);
extern char *STR_FindCharPtr(char *s, long ch);
extern void TLIBA1_DrawTextWithInsetSegments(char *rp, LONG x, LONG y, LONG insetSecondary, LONG insetPrimary, char *text);
extern LONG FORMAT_FormatToBuffer2(char *dst, const char *fmt, void *argList);
extern char *STR_SkipClass3Chars(char *s);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern char *STR_CopyUntilAnyDelimN(char *src, char *dst, LONG maxLen, char *delims);

void GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(LONG a, LONG b, char *m3, char *m2, char *m1, char *m0){NEWGRID_SetSelectionMarkers(a, b, m3, m2, m1, m0);}
char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *s, long ch){return STR_FindCharPtr((char *)s, ch);}
void GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(char *rp, LONG x, LONG y, LONG insetSecondary, LONG insetPrimary, char *text){TLIBA1_DrawTextWithInsetSegments(rp, x, y, insetSecondary, insetPrimary, text);}
LONG GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(char *dst, const char *fmt, void *argList){return FORMAT_FormatToBuffer2(dst, fmt, argList);}
char *GROUP_AI_JMPTBL_STR_SkipClass3Chars(char *s){return STR_SkipClass3Chars(s);}
char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src){return STRING_AppendAtNull(dst, src);}
char *GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN(char *src, char *dst, LONG maxLen, char *delims){return STR_CopyUntilAnyDelimN(src, dst, maxLen, delims);}
