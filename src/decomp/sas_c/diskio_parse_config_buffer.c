typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern UBYTE CONFIG_RefreshIntervalMinutes;
extern LONG CONFIG_RefreshIntervalSeconds;

extern LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *text);
extern LONG GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(LONG minutes, LONG mode);
extern LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);

void DISKIO_ParseConfigBuffer(char *buffer, ULONG size)
{
    char modeText[3];
    LONG minutes;

    if (buffer == 0 || size == 0) {
        return;
    }

    minutes = (LONG)((signed char)(buffer[0] - '0'));
    CONFIG_RefreshIntervalMinutes = (UBYTE)minutes;

    if (size > 6) {
        modeText[0] = (char)buffer[4];
        modeText[1] = (char)buffer[5];
        modeText[2] = '\0';
        (void)GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(modeText);
    }

    GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState((LONG)CONFIG_RefreshIntervalMinutes, 0);
    CONFIG_RefreshIntervalSeconds = GROUP_AG_JMPTBL_MATH_Mulu32((LONG)CONFIG_RefreshIntervalMinutes, 60);
}
