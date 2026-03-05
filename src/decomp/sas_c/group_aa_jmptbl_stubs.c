extern void STRING_CompareNoCase(void);
extern void STRING_CompareN(void);
extern void GCOMMAND_FindPathSeparator(void);
extern void GRAPHICS_AllocRaster(void);

void GROUP_AA_JMPTBL_STRING_CompareNoCase(void)
{
    STRING_CompareNoCase();
}

void GROUP_AA_JMPTBL_STRING_CompareN(void)
{
    STRING_CompareN();
}

void GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(void)
{
    GCOMMAND_FindPathSeparator();
}

void GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(void)
{
    GRAPHICS_AllocRaster();
}
