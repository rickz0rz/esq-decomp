extern long PARSEINI_WriteErrorLogEntry(void);
extern char *STRING_AppendAtNull(char *dst, const char *src);

long GROUP_AR_JMPTBL_PARSEINI_WriteErrorLogEntry(void)
{
    return PARSEINI_WriteErrorLogEntry();
}

char *GROUP_AR_JMPTBL_STRING_AppendAtNull(char *dst, const char *src)
{
    return STRING_AppendAtNull(dst, src);
}
