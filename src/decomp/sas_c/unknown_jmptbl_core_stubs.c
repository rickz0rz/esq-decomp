extern void ESQIFF2_ReadSerialRecordIntoBuffer(void);
extern void DISPLIB_DisplayTextAtPosition(void);
extern void ESQ_WildcardMatch(void);
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

void UNKNOWN_JMPTBL_ESQ_WildcardMatch(void)
{
    ESQ_WildcardMatch();
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
