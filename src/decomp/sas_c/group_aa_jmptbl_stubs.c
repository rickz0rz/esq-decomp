extern long STRING_CompareNoCase(const char *a, const char *b);
extern long STRING_CompareN(const char *a, const char *b, long maxLen);
extern char *GCOMMAND_FindPathSeparator(char *path);
extern void GRAPHICS_AllocRaster(void);

long GROUP_AA_JMPTBL_STRING_CompareNoCase(const char *a, const char *b)
{
    return STRING_CompareNoCase(a, b);
}

long GROUP_AA_JMPTBL_STRING_CompareN(const char *a, const char *b, long maxLen)
{
    return STRING_CompareN(a, b, maxLen);
}

char *GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(char *path)
{
    return GCOMMAND_FindPathSeparator(path);
}

void GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(void)
{
    GRAPHICS_AllocRaster();
}
