typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG ESQIFF2_ReadSerialRecordIntoBuffer(UBYTE *dst, LONG recordMode, LONG extensionCount);
extern void DISPLIB_DisplayTextAtPosition(char *rastPort, LONG x, LONG y, const char *text);
extern unsigned char ESQ_WildcardMatch(const char *str, const char *pattern);
extern LONG DST_NormalizeDayOfYear(WORD day_of_year, WORD year);
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
    return ESQ_WildcardMatch(str, pattern);
}

LONG UNKNOWN_JMPTBL_DST_NormalizeDayOfYear(LONG day, LONG year)
{
    return DST_NormalizeDayOfYear((WORD)day, (WORD)year);
}

LONG UNKNOWN_JMPTBL_ESQ_GenerateXorChecksumByte(UBYTE seed, const UBYTE *buf, LONG len)
{
    return ESQ_GenerateXorChecksumByte(seed, (UBYTE *)buf, len);
}

char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(const char *newText, char *oldText)
{
    return ESQPARS_ReplaceOwnedString(newText, oldText);
}
