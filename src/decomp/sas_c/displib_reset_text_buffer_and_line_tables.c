extern char *DISPTEXT_TextBufferPtr;
extern char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);
extern void DISPLIB_ResetLineTables(void);

void DISPLIB_ResetTextBufferAndLineTables(void)
{
    const char *EMPTY_TEXT_PTR = (const char *)0;

    DISPTEXT_TextBufferPtr =
        GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(EMPTY_TEXT_PTR, DISPTEXT_TextBufferPtr);
    DISPLIB_ResetLineTables();
}
