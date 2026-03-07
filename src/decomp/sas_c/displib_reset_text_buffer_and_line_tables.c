extern char *DISPTEXT_TextBufferPtr;
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *oldText, const char *newText);
extern void DISPLIB_ResetLineTables(void);

void DISPLIB_ResetTextBufferAndLineTables(void)
{
    DISPTEXT_TextBufferPtr =
        GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(DISPTEXT_TextBufferPtr, (const char *)0);
    DISPLIB_ResetLineTables();
}
