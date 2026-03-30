#include <exec/types.h>

extern LONG Global_REF_DOS_LIBRARY_2;

extern const char Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK[];
extern const char Global_STR_DELETE_NIL_DH2_LOGOS[];
extern const char PARSEINI_STR_RB_LogoListPrimary[];
extern const char PARSEINI_STR_RB_LogoListSecondary[];
extern const char PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST[];
extern const char PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT[];
extern const char Global_STR_PARSEINI_C_4[];
extern const char Global_STR_PARSEINI_C_5[];
extern const char Global_STR_PARSEINI_C_6[];
extern const char Global_STR_PARSEINI_C_7[];

extern LONG _LVOExecute(const char *cmd, LONG input, LONG output);
extern void *HANDLE_OpenWithMode(const char *path, const char *modeStr, char *unused);
extern char *STREAM_ReadLineWithLimit(char *dst, LONG maxLen, void *handle);
extern char *GCOMMAND_FindPathSeparator(const char *path);
extern void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const char *fileName, LONG lineNumber, LONG byteSize, LONG flags);
extern void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const char *fileName, LONG lineNumber, void *mem, LONG byteSize);
extern LONG STRING_CompareNoCase(const char *a, const char *b);
extern char *STRING_AppendAtNull(char *dst, const char *src);
extern LONG UNKNOWN36_FinalizeRequest(void *req);

static LONG PARSEINI_StrLen(const char *s)
{
    LONG n;
    n = 0;
    while (s[n] != 0) {
        ++n;
    }
    return n;
}

static void PARSEINI_CopyString(char *dst, const char *src)
{
    do {
        *dst++ = *src++;
    } while (dst[-1] != 0);
}

LONG PARSEINI_ScanLogoDirectory(void)
{
    char lineBuf[100];
    char deleteCmd[44];
    char *primaryEntries[100];
    char *secondaryEntries[100];
    LONG primaryHandle;
    LONG secondaryHandle;
    LONG i;
    LONG j;
    LONG foundMatch;
    LONG readPrimaryActive;
    LONG readSecondaryActive;
    char *lineStart;
    LONG len;

    for (i = 0; i < 100; ++i) {
        primaryEntries[i] = (char *)0;
        secondaryEntries[i] = (char *)0;
    }

    _LVOExecute(Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, 0, 0);

    primaryHandle = (LONG)HANDLE_OpenWithMode(PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST, PARSEINI_STR_RB_LogoListPrimary, (char *)0);
    readPrimaryActive = (primaryHandle != 0);

    secondaryHandle = (LONG)HANDLE_OpenWithMode(PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT, PARSEINI_STR_RB_LogoListSecondary, (char *)0);
    readSecondaryActive = (secondaryHandle != 0);

    i = 0;
    while (readPrimaryActive != 0 && i < 100) {
        readPrimaryActive = (STREAM_ReadLineWithLimit(lineBuf, 99, (void *)primaryHandle) != 0);
        for (j = 0; lineBuf[j] != 0; ++j) {
            if (lineBuf[j] == '\n' || lineBuf[j] == '\r' || lineBuf[j] == ',') {
                lineBuf[j] = 0;
            }
        }
        lineStart = GCOMMAND_FindPathSeparator(lineBuf);
        len = PARSEINI_StrLen(lineStart) + 1;
        primaryEntries[i] = (char *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(Global_STR_PARSEINI_C_4, 1263, len, 65537);
        PARSEINI_CopyString(primaryEntries[i], lineStart);
        ++i;
    }

    i = 0;
    while (readSecondaryActive != 0 && i < 100) {
        readSecondaryActive = (STREAM_ReadLineWithLimit(lineBuf, 99, (void *)secondaryHandle) != 0);
        for (j = 0; lineBuf[j] != 0; ++j) {
            if (lineBuf[j] == '\n' || lineBuf[j] == '\r') {
                lineBuf[j] = 0;
            }
        }
        len = PARSEINI_StrLen(lineBuf) + 1;
        secondaryEntries[i] = (char *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(Global_STR_PARSEINI_C_5, 1287, len, 65537);
        PARSEINI_CopyString(secondaryEntries[i], lineBuf);
        ++i;
    }

    i = 0;
    while (i < 100 && secondaryEntries[i] != (char *)0) {
        foundMatch = 0;

        j = 0;
        while (j < 100 && primaryEntries[j] != (char *)0) {
            if (STRING_CompareNoCase(secondaryEntries[i], primaryEntries[j]) == 0) {
                foundMatch = 1;
            }
            ++j;
        }

        if (foundMatch == 0) {
            PARSEINI_CopyString(deleteCmd, Global_STR_DELETE_NIL_DH2_LOGOS);
            STRING_AppendAtNull(deleteCmd, secondaryEntries[i]);
            _LVOExecute(deleteCmd, 0, 0);
        }

        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_PARSEINI_C_6,
            1323,
            secondaryEntries[i],
            PARSEINI_StrLen(secondaryEntries[i]) + 1);
        ++i;
    }

    i = 0;
    while (i < 100 && primaryEntries[i] != (char *)0) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_PARSEINI_C_7,
            1329,
            primaryEntries[i],
            PARSEINI_StrLen(primaryEntries[i]) + 1);
        ++i;
    }

    if (primaryHandle != 0) {
        (void)UNKNOWN36_FinalizeRequest((void *)primaryHandle);
    }
    if (secondaryHandle != 0) {
        (void)UNKNOWN36_FinalizeRequest((void *)secondaryHandle);
    }

    return 0;
}
