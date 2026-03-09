typedef signed long LONG;
typedef unsigned long ULONG;

extern LONG Global_REF_DOS_LIBRARY_2;

extern const char Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK[];
extern const char PARSEINI_STR_RB_LogoListPrimary[];
extern const char PARSEINI_STR_RB_LogoListSecondary[];
extern const char PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST[];
extern const char PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT[];
extern char Global_STR_PARSEINI_C_4[];
extern char Global_STR_PARSEINI_C_5[];

extern LONG _LVOExecute(const char *cmd, LONG input, LONG output);
extern LONG PARSEINI_JMPTBL_HANDLE_OpenWithMode(const char *path, const char *modeStr);
extern LONG PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(char *dst, LONG maxLen, LONG handle);
extern char *PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(char *path);
extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const char *fileName, LONG lineNumber, LONG byteSize, LONG flags);
extern void PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(LONG handle);

static LONG PARSEINI_StrLen(const char *s)
{
    LONG n;
    n = 0;
    while (s[n] != 0) {
        ++n;
    }
    return n;
}

void PARSEINI_ScanLogoDirectory(void)
{
    char lineBuf[100];
    char *primaryEntries[100];
    char *secondaryEntries[100];
    LONG primaryHandle;
    LONG secondaryHandle;
    LONG i;
    LONG j;
    char *lineStart;
    char *dst;
    char *src;
    LONG len;

    for (i = 0; i < 100; ++i) {
        primaryEntries[i] = (char *)0;
        secondaryEntries[i] = (char *)0;
    }

    _LVOExecute(Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, 0, 0);

    primaryHandle = PARSEINI_JMPTBL_HANDLE_OpenWithMode(PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST, PARSEINI_STR_RB_LogoListPrimary);
    secondaryHandle = PARSEINI_JMPTBL_HANDLE_OpenWithMode(PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT, PARSEINI_STR_RB_LogoListSecondary);

    i = 0;
    while (primaryHandle != 0 && i < 100) {
        if (PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(lineBuf, 99, primaryHandle) == 0) {
            break;
        }
        for (j = 0; lineBuf[j] != 0; ++j) {
            if (lineBuf[j] == '\n' || lineBuf[j] == '\r' || lineBuf[j] == ',') {
                lineBuf[j] = 0;
            }
        }
        lineStart = PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(lineBuf);
        len = PARSEINI_StrLen(lineStart) + 1;
        primaryEntries[i] = (char *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(Global_STR_PARSEINI_C_4, 1263, len, 65537);
        if (primaryEntries[i] != (char *)0) {
            dst = primaryEntries[i];
            src = lineStart;
            do {
                *dst++ = *src++;
            } while (dst[-1] != 0);
        }
        ++i;
    }

    i = 0;
    while (secondaryHandle != 0 && i < 100) {
        if (PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(lineBuf, 99, secondaryHandle) == 0) {
            break;
        }
        for (j = 0; lineBuf[j] != 0; ++j) {
            if (lineBuf[j] == '\n' || lineBuf[j] == '\r') {
                lineBuf[j] = 0;
            }
        }
        len = PARSEINI_StrLen(lineBuf) + 1;
        secondaryEntries[i] = (char *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(Global_STR_PARSEINI_C_5, 1287, len, 65537);
        if (secondaryEntries[i] != (char *)0) {
            dst = secondaryEntries[i];
            src = lineBuf;
            do {
                *dst++ = *src++;
            } while (dst[-1] != 0);
        }
        ++i;
    }

    if (primaryHandle != 0) {
        PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(primaryHandle);
    }
    if (secondaryHandle != 0) {
        PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(secondaryHandle);
    }
}
