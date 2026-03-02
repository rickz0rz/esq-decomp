#include "esq_types.h"

extern void *Global_REF_DOS_LIBRARY_2;
extern const char Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK[];
extern const char PARSEINI_STR_RB_LogoListPrimary[];
extern const char PARSEINI_STR_RB_LogoListSecondary[];
extern const char PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST[];
extern const char PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT[];
extern const char Global_STR_PARSEINI_C_4[];
extern const char Global_STR_PARSEINI_C_5[];
extern const char Global_STR_PARSEINI_C_6[];
extern const char Global_STR_PARSEINI_C_7[];
extern const char Global_STR_DELETE_NIL_DH2_LOGOS[];

s32 _LVOExecute(const char *command, s32 in_fh, s32 out_fh) __attribute__((noinline));
void *PARSEINI_JMPTBL_HANDLE_OpenWithMode(const char *path, const char *mode) __attribute__((noinline));
s32 PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(char *dst, s32 limit, void *handle) __attribute__((noinline));
char *PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(char *path) __attribute__((noinline));
void *SCRIPT_JMPTBL_MEMORY_AllocateMemory(const char *owner, s32 line, s32 bytes, s32 flags) __attribute__((noinline));
void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(const char *owner, s32 line, void *mem, s32 bytes) __attribute__((noinline));
s32 PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b) __attribute__((noinline));
char *PARSEINI_JMPTBL_STRING_AppendAtNull(char *dst, const char *src) __attribute__((noinline));
void PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(void *h) __attribute__((noinline));

static s32 str_len(const char *s)
{
    s32 n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

static void copy_str(char *dst, const char *src)
{
    while ((*dst++ = *src++) != '\0') {
    }
}

static void sanitize_primary(char *s)
{
    s32 i = 0;
    while (s[i] != '\0') {
        if ((u8)s[i] == 10 || (u8)s[i] == 13 || (u8)s[i] == 44) {
            s[i] = '\0';
        }
        i++;
    }
}

static void sanitize_secondary(char *s)
{
    s32 i = 0;
    while (s[i] != '\0') {
        if ((u8)s[i] == 10 || (u8)s[i] == 13) {
            s[i] = '\0';
        }
        i++;
    }
}

s32 PARSEINI_ScanLogoDirectory(void) __attribute__((noinline, used));

s32 PARSEINI_ScanLogoDirectory(void)
{
    char line[100];
    char delete_cmd[44];
    char *primary[100];
    char *secondary[100];
    void *h_primary;
    void *h_secondary;
    s32 i;
    s32 j;
    s32 read_primary_active;
    s32 read_secondary_active;

    for (i = 0; i < 100; i++) {
        primary[i] = 0;
        secondary[i] = 0;
    }

    _LVOExecute(Global_STR_LIST_RAM_LOGODIR_TXT_DH2_LOGOS_NOHEAD_QUICK, 0, 0);

    h_primary = PARSEINI_JMPTBL_HANDLE_OpenWithMode(
        PARSEINI_PATH_DF0_COLON_LOGO_DOT_LST,
        PARSEINI_STR_RB_LogoListPrimary);
    read_primary_active = (h_primary != 0);

    h_secondary = PARSEINI_JMPTBL_HANDLE_OpenWithMode(
        PARSEINI_PATH_RAM_COLON_LOGODIR_DOT_TXT,
        PARSEINI_STR_RB_LogoListSecondary);
    read_secondary_active = (h_secondary != 0);

    i = 0;
    while (read_primary_active && i < 100) {
        read_primary_active = PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(line, 99, h_primary);
        sanitize_primary(line);

        {
            char *name = PARSEINI_JMPTBL_GCOMMAND_FindPathSeparator(line);
            s32 bytes = str_len(name) + 1;
            primary[i] = (char *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_PARSEINI_C_4, 1263, bytes, 0x10001);
            if (primary[i] != 0) {
                copy_str(primary[i], name);
            }
        }
        i++;
    }

    i = 0;
    while (read_secondary_active && i < 100) {
        read_secondary_active = PARSEINI_JMPTBL_STREAM_ReadLineWithLimit(line, 99, h_secondary);
        sanitize_secondary(line);

        {
            s32 bytes = str_len(line) + 1;
            secondary[i] = (char *)SCRIPT_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_PARSEINI_C_5, 1287, bytes, 0x10001);
            if (secondary[i] != 0) {
                copy_str(secondary[i], line);
            }
        }
        i++;
    }

    for (i = 0; i < 100 && secondary[i] != 0; i++) {
        s32 found = 0;

        for (j = 0; j < 100 && primary[j] != 0; j++) {
            if (PARSEINI_JMPTBL_STRING_CompareNoCase(secondary[i], primary[j]) == 0) {
                found = 1;
                break;
            }
        }

        if (!found) {
            copy_str(delete_cmd, Global_STR_DELETE_NIL_DH2_LOGOS);
            PARSEINI_JMPTBL_STRING_AppendAtNull(delete_cmd, secondary[i]);
            _LVOExecute(delete_cmd, 0, 0);
        }

        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_PARSEINI_C_6, 1323, secondary[i], str_len(secondary[i]) + 1);
    }

    for (i = 0; i < 100 && primary[i] != 0; i++) {
        SCRIPT_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_PARSEINI_C_7, 1329, primary[i], str_len(primary[i]) + 1);
    }

    if (h_primary != 0) {
        PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(h_primary);
    }
    if (h_secondary != 0) {
        PARSEINI_JMPTBL_UNKNOWN36_FinalizeRequest(h_secondary);
    }

    return 0;
}
