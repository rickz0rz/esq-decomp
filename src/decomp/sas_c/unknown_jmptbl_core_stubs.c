extern void ESQIFF2_ReadSerialRecordIntoBuffer(void);
extern void DISPLIB_DisplayTextAtPosition(void);
extern unsigned char ESQ_WildcardMatch(char *str, char *pattern);
extern void DST_NormalizeDayOfYear(void);
extern void ESQ_GenerateXorChecksumByte(void);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);

void UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(void)
{
    ESQIFF2_ReadSerialRecordIntoBuffer();
}

void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(void)
{
    DISPLIB_DisplayTextAtPosition();
}

unsigned char UNKNOWN_JMPTBL_ESQ_WildcardMatch(char *str, char *pattern)
{
    return ESQ_WildcardMatch(str, pattern);
}

void UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(void)
{
    DST_NormalizeDayOfYear();
}

void UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(void)
{
    ESQ_GenerateXorChecksumByte();
}

char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText)
{
    return ESQPARS_ReplaceOwnedString(newText, oldText);
}
