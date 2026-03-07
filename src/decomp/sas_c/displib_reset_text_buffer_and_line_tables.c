extern char *DISPTEXT_TextBufferPtr;
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(char *oldText, const char *newText);
extern void DISPLIB_ResetLineTables(void);

void DISPLIB_ResetTextBufferAndLineTables(void)
{
    const char *EMPTY_TEXT_PTR = (const char *)0;

    DISPTEXT_TextBufferPtr =
        GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(DISPTEXT_TextBufferPtr, EMPTY_TEXT_PTR);
    DISPLIB_ResetLineTables();
}
