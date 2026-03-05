typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

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

    GROUP_AG_JMPTBL_MATH_DivS32((LONG)disk_id, 2);
    GROUP_AE_JMPTBL_WDISP_SPrintf(path_buf, Global_STR_DF0_OI_PERCENT_2_LX_DAT_2, 0, 0, 0);

    if (DISKIO_LoadFileToWorkBuffer(path_buf) == -1) {
        return -1;
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
        GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(line_buf, line_buf, 11, COI_STR_LINEFEED_CR_2, 1, 26, 1);
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

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_COI_C_6, 1198, Global_PTR_WORK_BUFFER, file_size + 1);
    return 0;
}
