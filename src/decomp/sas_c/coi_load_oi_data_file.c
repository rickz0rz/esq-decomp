typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

enum {
    COI_DISK_SPLIT_DIVISOR = 2,
    COI_LOAD_FAIL = -1,
    COI_TOKEN_MAX = 11,
    COI_DELIM_COUNT = 1,
    COI_TOKEN_MAXLEN = 26,
    COI_STOP_ON_EMPTY = 1,
    COI_DEALLOC_LINE = 1198,
    COI_SUCCESS = 0
};

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern UBYTE *Global_PTR_WORK_BUFFER;
extern UBYTE Global_STR_DF0_OI_PERCENT_2_LX_DAT_2[];
extern UBYTE COI_STR_LINEFEED_CR_1[];
extern UBYTE COI_STR_LINEFEED_CR_2[];
extern UBYTE Global_STR_COI_C_6[];

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(UBYTE *out, const UBYTE *fmt, LONG a, LONG b, LONG c);
LONG DISKIO_LoadFileToWorkBuffer(const UBYTE *path);
LONG GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
UBYTE *GROUP_AI_JMPTBL_STR_FindCharPtr(const UBYTE *s, LONG c);
LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const UBYTE *s);
LONG GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(const UBYTE *s, void *map, LONG max_tokens, const UBYTE *delims, LONG n_delims, LONG max_len, LONG stop_on_empty);
LONG ESQ_WildcardMatch(const UBYTE *a, const UBYTE *b);
LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(void *old_ptr, const void *new_ptr);
void CLEANUP_FormatEntryStringTokens(void *entry);
void COI_AllocSubEntryTable(void *entry);

LONG COI_LoadOiDataFile(UBYTE disk_id)
{
    UBYTE path_buf[566];
    UBYTE line_buf[486];
    LONG file_size;
    LONG offs;
    LONG line_len;
    LONG parsed;

    (void)disk_id;

    GROUP_AG_JMPTBL_MATH_DivS32((LONG)disk_id, COI_DISK_SPLIT_DIVISOR);
    GROUP_AE_JMPTBL_WDISP_SPrintf(path_buf, Global_STR_DF0_OI_PERCENT_2_LX_DAT_2, 0, 0, 0);

    if (DISKIO_LoadFileToWorkBuffer(path_buf) == COI_LOAD_FAIL) {
        return COI_LOAD_FAIL;
    }

    file_size = Global_REF_LONG_FILE_SCRATCH;
    offs = 0;
    line_len = 0;

    while (Global_PTR_WORK_BUFFER != (UBYTE *)0 && offs < file_size) {
        UBYTE *p;

        p = Global_PTR_WORK_BUFFER + offs;
        if (GROUP_AI_JMPTBL_STR_FindCharPtr(p, (LONG)COI_STR_LINEFEED_CR_1[0]) == (UBYTE *)0) {
            line_buf[line_len++] = *p;
            offs += 1;
            continue;
        }

        line_buf[line_len] = 0;
        parsed = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(line_buf);
        (void)parsed;
        GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
            line_buf,
            line_buf,
            COI_TOKEN_MAX,
            COI_STR_LINEFEED_CR_2,
            COI_DELIM_COUNT,
            COI_TOKEN_MAXLEN,
            COI_STOP_ON_EMPTY);
        break;
    }

    if (Global_PTR_WORK_BUFFER != (UBYTE *)0) {
        void *entry;

        entry = (void *)Global_PTR_WORK_BUFFER;
        ESQ_WildcardMatch((const UBYTE *)entry, (const UBYTE *)entry);
        GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString((void *)0, entry);
        CLEANUP_FormatEntryStringTokens(entry);
        COI_AllocSubEntryTable(entry);
    }

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_COI_C_6,
        COI_DEALLOC_LINE,
        Global_PTR_WORK_BUFFER,
        file_size + 1);
    return COI_SUCCESS;
}
