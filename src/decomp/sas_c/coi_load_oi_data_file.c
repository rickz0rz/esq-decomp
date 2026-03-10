typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

enum {
    COI_DISK_SPLIT_DIVISOR = 2,
    COI_LOAD_FAIL = -1,
    COI_TOKEN_MAX = 11,
    COI_TOKEN_MAXLEN = 26,
    COI_DEALLOC_LINE = 1198,
    COI_PATH_PRINTF_ARG_ZERO = 0
};

#define COI_DELIM_COUNT 1
#define COI_STOP_ON_EMPTY 1
#define COI_WORK_BUFFER_TRAILING_NUL_BYTES 1
#define COI_SUCCESS 0

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern const char Global_STR_DF0_OI_PERCENT_2_LX_DAT_2[];
extern const char COI_STR_LINEFEED_CR_1[];
extern const char COI_STR_LINEFEED_CR_2[];
extern const char Global_STR_COI_C_6[];

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG a, LONG b, LONG c);
LONG DISKIO_LoadFileToWorkBuffer(const char *path);
LONG GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *s, LONG c);
LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *s);
LONG GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(char *inputBytes, WORD *outIndexByToken, WORD tokenCount, const char *tokenTable, WORD maxScanCount, char terminatorByte, WORD fillMissingFlag);
LONG ESQ_WildcardMatch(const char *a, const char *b);
char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);
void CLEANUP_FormatEntryStringTokens(void *entry);
void COI_AllocSubEntryTable(void *entry);

LONG COI_LoadOiDataFile(UBYTE disk_id)
{
    char path_buf[566];
    char line_buf[486];
    WORD token_index_by_token[COI_TOKEN_MAX];
    LONG file_size;
    LONG offs;
    LONG line_len;
    LONG parsed;

    (void)disk_id;

    GROUP_AG_JMPTBL_MATH_DivS32((LONG)disk_id, COI_DISK_SPLIT_DIVISOR);
    GROUP_AE_JMPTBL_WDISP_SPrintf(path_buf,
                                  Global_STR_DF0_OI_PERCENT_2_LX_DAT_2,
                                  COI_PATH_PRINTF_ARG_ZERO,
                                  COI_PATH_PRINTF_ARG_ZERO,
                                  COI_PATH_PRINTF_ARG_ZERO);

    if (DISKIO_LoadFileToWorkBuffer(path_buf) == COI_LOAD_FAIL) {
        return COI_LOAD_FAIL;
    }

    file_size = Global_REF_LONG_FILE_SCRATCH;
    offs = 0;
    line_len = 0;

    while (Global_PTR_WORK_BUFFER != (char *)0 && offs < file_size) {
        const char *p;

        p = Global_PTR_WORK_BUFFER + offs;
        if (GROUP_AI_JMPTBL_STR_FindCharPtr(p, (LONG)COI_STR_LINEFEED_CR_1[0]) == (char *)0) {
            line_buf[line_len++] = *p;
            offs += 1;
            continue;
        }

        line_buf[line_len] = 0;
        parsed = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(line_buf);
        (void)parsed;
        GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
            line_buf,
            token_index_by_token,
            (WORD)COI_TOKEN_MAX,
            COI_STR_LINEFEED_CR_2,
            (WORD)COI_TOKEN_MAXLEN,
            COI_STR_LINEFEED_CR_2[0],
            (WORD)COI_STOP_ON_EMPTY);
        break;
    }

    if (Global_PTR_WORK_BUFFER != (char *)0) {
        char *entry;

        entry = Global_PTR_WORK_BUFFER;
        ESQ_WildcardMatch(entry, entry);
        GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(entry, (char *)0);
        CLEANUP_FormatEntryStringTokens(entry);
        COI_AllocSubEntryTable(entry);
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_COI_C_6,
        COI_DEALLOC_LINE,
        Global_PTR_WORK_BUFFER,
        file_size + COI_WORK_BUFFER_TRAILING_NUL_BYTES);
    return COI_SUCCESS;
}
