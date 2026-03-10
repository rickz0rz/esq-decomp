extern void NEWGRID_SetSelectionMarkers(void);
extern char *STR_FindCharPtr(char *s, long ch);
extern void TLIBA1_DrawTextWithInsetSegments(void);
extern void FORMAT_FormatToBuffer2(void);
extern char *STR_SkipClass3Chars(char *s);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern void STR_CopyUntilAnyDelimN(void);

void GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(void){NEWGRID_SetSelectionMarkers();}
char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *s, long ch){return STR_FindCharPtr((char *)s, ch);}
void GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(void){TLIBA1_DrawTextWithInsetSegments();}
void GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(void){FORMAT_FormatToBuffer2();}
char *GROUP_AI_JMPTBL_STR_SkipClass3Chars(char *s){return STR_SkipClass3Chars(s);}
char *GROUP_AI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src){return STRING_AppendAtNull(dst, src);}
void GROUP_AI_JMPTBL_STR_CopyUntilAnyDelimN(void){STR_CopyUntilAnyDelimN();}
