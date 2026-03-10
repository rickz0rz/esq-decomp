typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, LONG recordMode, LONG extensionCount);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);
extern unsigned char ESQ_WildcardMatch(char *str, char *pattern);
extern void DST_NormalizeDayOfYear(void);
extern LONG ESQ_GenerateXorChecksumByte(UBYTE seed, UBYTE *src, LONG length);
extern char *ESQPARS_ReplaceOwnedString(const char *newText, char *oldText);

LONG UNKNOWN_JMPTBL_ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, LONG recordMode, LONG extensionCount)
{
    return ESQIFF2_ReadSerialRecordIntoBuffer(dst, recordMode, extensionCount);
}

void UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text)
{
    DISPLIB_DisplayTextAtPosition(rastPort, x, y, text);
}

unsigned char UNKNOWN_JMPTBL_ESQ_WildcardMatch(const char *str, const char *pattern)
{
    return ESQ_WildcardMatch((char *)str, (char *)pattern);
}

void UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(void)
{
    DST_NormalizeDayOfYear();
}

LONG UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *buf, LONG len)
{
    return ESQ_GenerateXorChecksumByte(seed, (UBYTE *)buf, len);
}

char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText)
{
    return ESQPARS_ReplaceOwnedString(newText, oldText);
}
