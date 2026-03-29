#include <exec/types.h>

enum {
    COI_DISK_SPLIT_DIVISOR = 2,
    COI_LOAD_FAIL = -1,
    COI_RECORD_TOKEN_COUNT = 11,
    COI_SUBENTRY_TOKEN_COUNT = 8,
    COI_TOKEN_SCAN_MAX = 26,
    COI_LINE_BUFFER_SIZE = 486,
    COI_PATH_BUFFER_SIZE = 566,
    COI_SEEN_FLAGS_COUNT = 0x12e,
    COI_RECORD_DEALLOC_LINE = 1443,
    COI_HEADER_FAIL_DEALLOC_LINE = 1198,
    COI_WORK_BUFFER_TRAILING_NUL_BYTES = 1,
    COI_SUCCESS = 0,
    COI_DEFAULT_DELIM = 9,
    COI_CR = 13,
    COI_LF = 10,
    COI_INVALID_DELTA = -1
};

#define COI_TOKEN_STOP_ON_EMPTY 1
#define COI_HEADER_FORMAT_EXTENDED 2

typedef struct COI_SubEntry {
    WORD key0;
    char *field2;
    char *field6;
    char *field10;
    char *field14;
    char *field18;
    char *field22;
    LONG field26;
} COI_SubEntry;

typedef struct COI_AnimObject {
    UBYTE mode0;
    UBYTE mode1;
    UBYTE mode2;
    UBYTE mode3;
    char *field4;
    char *field8;
    char *field12;
    char *field16;
    char *field20;
    char *field24;
    char *field28;
    LONG field32;
    WORD subEntryCount;
    COI_SubEntry **subEntryTable;
} COI_AnimObject;

typedef struct COI_EntryTableEntry {
    UBYTE pad0[12];
    char titleText[36];
    COI_AnimObject *anim;
} COI_EntryTableEntry;

extern LONG Global_REF_LONG_FILE_SCRATCH;
extern char *Global_PTR_WORK_BUFFER;
extern UBYTE TEXTDISP_SecondaryGroupCode;
extern UBYTE TEXTDISP_SecondaryGroupPresentFlag;
extern UWORD TEXTDISP_SecondaryGroupEntryCount;
extern UBYTE TEXTDISP_PrimaryGroupCode;
extern UWORD TEXTDISP_PrimaryGroupEntryCount;
extern COI_EntryTableEntry *TEXTDISP_PrimaryEntryPtrTable[];
extern COI_EntryTableEntry *TEXTDISP_SecondaryEntryPtrTable[];
extern const char Global_STR_DF0_OI_PERCENT_2_LX_DAT_2[];
extern const char COI_STR_LINEFEED_CR_1[];
extern const char COI_STR_LINEFEED_CR_2[];
extern const char COI_STR_DEFAULT_TOKEN_TEMPLATE_A[];
extern const char Global_STR_PERCENT_S_1[];
extern const char Global_STR_COI_C_1[];
extern const char Global_STR_COI_C_6[];

LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG a, LONG b);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *out, const char *fmt, LONG a, LONG b, LONG c);
LONG DISKIO_LoadFileToWorkBuffer(const char *path);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
char *GROUP_AI_JMPTBL_STR_FindCharPtr(const char *s, LONG c);
LONG GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *s);
LONG GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(char *inputBytes, WORD *outIndexByToken, WORD tokenCount, const char *tokenTable, WORD maxScanCount, char terminatorByte, WORD fillMissingFlag);
LONG ESQ_WildcardMatch(const char *a, const char *b);
char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);
void CLEANUP_FormatEntryStringTokens(void **field_a, void **field_b, char *input);
void COI_AllocSubEntryTable(void *entry);

static void COI_InitTokenTables(char *recordTokenTable, char *subTokenTable)
{
    WORD i;

    for (i = 0; i < 9; i += 1) {
        recordTokenTable[(LONG)i] = COI_DEFAULT_DELIM;
    }
    recordTokenTable[9] = COI_CR;
    recordTokenTable[10] = COI_LF;

    for (i = 0; i < 6; i += 1) {
        subTokenTable[(LONG)i] = COI_DEFAULT_DELIM;
    }
    subTokenTable[6] = COI_CR;
    subTokenTable[7] = COI_LF;
}

static void COI_ClearWordArray(WORD *values, WORD count)
{
    WORD i;

    for (i = 0; i < count; i += 1) {
        values[(LONG)i] = 0;
    }
}

static void COI_ReplaceFormattedPair(char **field_a, char **field_b, char *input)
{
    CLEANUP_FormatEntryStringTokens((void **)field_a, (void **)field_b, input);
}

LONG COI_LoadOiDataFile(UBYTE disk_id)
{
    char path_buf[COI_PATH_BUFFER_SIZE];
    char line_buf[COI_LINE_BUFFER_SIZE];
    WORD record_tokens[COI_RECORD_TOKEN_COUNT];
    WORD subentry_tokens[COI_SUBENTRY_TOKEN_COUNT];
    UBYTE seen_flags[COI_SEEN_FLAGS_COUNT];
    char record_token_table[COI_RECORD_TOKEN_COUNT];
    char subentry_token_table[COI_SUBENTRY_TOKEN_COUNT];
    LONG file_size;
    LONG file_offset;
    LONG line_advance;
    LONG header_format;
    WORD disk_path_index;
    WORD entry_count;
    WORD record_index;
    char *original_buffer;

    COI_InitTokenTables(record_token_table, subentry_token_table);

    (void)GROUP_AG_JMPTBL_MATH_DivS32((LONG)disk_id, COI_DISK_SPLIT_DIVISOR);
    disk_path_index = (WORD)((LONG)disk_id % COI_DISK_SPLIT_DIVISOR);
    GROUP_AE_JMPTBL_WDISP_SPrintf(path_buf,
                                  Global_STR_DF0_OI_PERCENT_2_LX_DAT_2,
                                  (LONG)disk_path_index,
                                  0,
                                  0);

    if (DISKIO_LoadFileToWorkBuffer(path_buf) == COI_LOAD_FAIL) {
        return COI_LOAD_FAIL;
    }

    file_size = Global_REF_LONG_FILE_SCRATCH;
    original_buffer = Global_PTR_WORK_BUFFER;

    if (disk_id == TEXTDISP_SecondaryGroupCode &&
        (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
        entry_count = TEXTDISP_SecondaryGroupEntryCount;
    } else if (disk_id == TEXTDISP_PrimaryGroupCode) {
        entry_count = TEXTDISP_PrimaryGroupEntryCount;
    } else {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_COI_C_6,
            COI_HEADER_FAIL_DEALLOC_LINE,
            original_buffer,
            file_size + COI_WORK_BUFFER_TRAILING_NUL_BYTES);
        return COI_LOAD_FAIL;
    }

    file_offset = 0;
    line_advance = 0;
    header_format = 0;

    while (Global_PTR_WORK_BUFFER != (char *)0 && file_offset < file_size) {
        char *cursor;
        char *tab_ptr;
        LONG parsed_group;

        cursor = Global_PTR_WORK_BUFFER + file_offset + line_advance;
        if (GROUP_AI_JMPTBL_STR_FindCharPtr(COI_STR_LINEFEED_CR_1, (LONG)(UBYTE)*cursor) == (char *)0) {
            line_buf[line_advance] = *cursor;
            line_advance += 1;
            continue;
        }

        line_buf[line_advance] = 0;
        tab_ptr = GROUP_AI_JMPTBL_STR_FindCharPtr(line_buf, COI_DEFAULT_DELIM);
        if (tab_ptr != (char *)0) {
            *tab_ptr = 0;
            tab_ptr += 1;
            header_format = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(tab_ptr);
        } else {
            header_format = 0;
        }

        parsed_group = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(line_buf);
        if ((LONG)(UBYTE)disk_id != parsed_group) {
            return COI_LOAD_FAIL;
        }

        while (GROUP_AI_JMPTBL_STR_FindCharPtr(
                   COI_STR_LINEFEED_CR_2,
                   (LONG)(UBYTE)Global_PTR_WORK_BUFFER[file_offset + line_advance]) != (char *)0) {
            Global_PTR_WORK_BUFFER[file_offset + line_advance] = 0;
            line_advance += 1;
        }
        break;
    }

    {
        WORD i;

        i = (WORD)(COI_SEEN_FLAGS_COUNT - 1);
        do {
            seen_flags[(LONG)((COI_SEEN_FLAGS_COUNT - 1) - i)] = 0;
            i -= 1;
        } while (i >= 0);
    }

    record_index = 0;
    while (record_index < entry_count) {
        char *record_base;
        WORD entry_index;
        COI_EntryTableEntry *source_entry;
        COI_AnimObject *source_anim;

        file_offset += line_advance;
        record_base = Global_PTR_WORK_BUFFER + file_offset;

        if (header_format == COI_HEADER_FORMAT_EXTENDED) {
            (void)GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
                record_base,
                record_tokens,
                COI_RECORD_TOKEN_COUNT,
                record_token_table,
                (WORD)file_size,
                COI_STR_LINEFEED_CR_2[0],
                COI_TOKEN_STOP_ON_EMPTY);
        } else {
            COI_ClearWordArray(record_tokens, COI_RECORD_TOKEN_COUNT);
            (void)GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
                record_base,
                record_tokens,
                COI_RECORD_TOKEN_COUNT,
                record_token_table + 2,
                (WORD)file_size,
                COI_STR_LINEFEED_CR_2[0],
                COI_TOKEN_STOP_ON_EMPTY);
        }

        line_advance = (LONG)record_tokens[COI_RECORD_TOKEN_COUNT - 1];
        entry_index = 0;
        source_entry = (COI_EntryTableEntry *)0;
        source_anim = (COI_AnimObject *)0;

        while (entry_index < entry_count) {
            COI_EntryTableEntry *entry;
            COI_AnimObject *anim;

            if (disk_id == TEXTDISP_SecondaryGroupCode &&
                (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
                entry = TEXTDISP_SecondaryEntryPtrTable[(LONG)entry_index];
            } else {
                entry = TEXTDISP_PrimaryEntryPtrTable[(LONG)entry_index];
            }
            if (ESQ_WildcardMatch(entry->titleText, record_base) != 0) {
                entry_index += 1;
                continue;
            }

            if (seen_flags[(LONG)entry_index] == 0) {
                anim = entry->anim;
                source_entry = entry;
                source_anim = anim;

                anim->field4 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                    record_base + record_tokens[2],
                    anim->field4);
                anim->mode0 = (UBYTE)record_base[record_tokens[3]];
                anim->mode1 = (UBYTE)record_base[record_tokens[3] + 1];
                anim->mode2 = (UBYTE)record_base[record_tokens[3] + 2];
                anim->mode3 = 0;
                anim->field12 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                    record_base + record_tokens[4],
                    anim->field12);
                anim->field16 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                    record_base + record_tokens[5],
                    anim->field16);
                anim->field20 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                    record_base + record_tokens[6],
                    anim->field20);
                anim->field8 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                    record_base + record_tokens[7],
                    anim->field8);

                if (record_tokens[0] > 0) {
                    COI_ReplaceFormattedPair(
                        &anim->field24,
                        &anim->field28,
                        record_base + record_tokens[0]);
                } else {
                    anim->field24 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        (const char *)0,
                        anim->field24);
                    anim->field28 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        COI_STR_DEFAULT_TOKEN_TEMPLATE_A,
                        anim->field28);
                }

                if (record_tokens[1] != 0) {
                    anim->field32 = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(
                        record_base + record_tokens[1]);
                } else {
                    anim->field32 = COI_INVALID_DELTA;
                }

                GROUP_AE_JMPTBL_WDISP_SPrintf(
                    line_buf,
                    Global_STR_PERCENT_S_1,
                    (LONG)(record_base + record_tokens[8]),
                    0,
                    0);
                anim->subEntryCount = (WORD)GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(line_buf);
                COI_AllocSubEntryTable(entry);

                {
                    WORD subentry_index;

                    subentry_index = 0;
                    while (subentry_index < anim->subEntryCount) {
                        COI_SubEntry *subentry;
                        char *subentry_base;

                        subentry = anim->subEntryTable[(LONG)subentry_index];
                        file_offset += line_advance;
                        subentry_base = Global_PTR_WORK_BUFFER + file_offset;

                        if (header_format == COI_HEADER_FORMAT_EXTENDED) {
                            (void)GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
                                subentry_base,
                                subentry_tokens,
                                COI_SUBENTRY_TOKEN_COUNT,
                                subentry_token_table,
                                (WORD)file_size,
                                COI_STR_LINEFEED_CR_2[0],
                                COI_TOKEN_STOP_ON_EMPTY);
                        } else {
                            COI_ClearWordArray(subentry_tokens, COI_SUBENTRY_TOKEN_COUNT);
                            (void)GROUP_AE_JMPTBL_SCRIPT_BuildTokenIndexMap(
                                subentry_base,
                                subentry_tokens,
                                COI_SUBENTRY_TOKEN_COUNT,
                                subentry_token_table + 2,
                                (WORD)file_size,
                                COI_STR_LINEFEED_CR_2[0],
                                COI_TOKEN_STOP_ON_EMPTY);
                        }

                        line_advance = (LONG)subentry_tokens[COI_SUBENTRY_TOKEN_COUNT - 1];

                        if (seen_flags[(LONG)entry_index] == 0) {
                            subentry->key0 = (WORD)GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(subentry_base);
                            subentry->field6 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                                subentry_base + subentry_tokens[2],
                                subentry->field6);
                            subentry->field10 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                                subentry_base + subentry_tokens[3],
                                subentry->field10);
                            subentry->field14 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                                subentry_base + subentry_tokens[4],
                                subentry->field14);
                            subentry->field2 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                                subentry_base + subentry_tokens[5],
                                subentry->field2);

                            if (subentry_tokens[0] > 0) {
                                COI_ReplaceFormattedPair(
                                    &subentry->field18,
                                    &subentry->field22,
                                    subentry_base + subentry_tokens[0]);
                            } else {
                                subentry->field18 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                                    anim->field24,
                                    subentry->field18);
                                subentry->field22 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                                    anim->field28,
                                    subentry->field22);
                            }

                            if (subentry_tokens[1] > 0) {
                                subentry->field26 = GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(
                                    subentry_base + subentry_tokens[1]);
                            } else {
                                subentry->field26 = anim->field32;
                            }
                        }

                        subentry_index += 1;
                    }
                }

                if (seen_flags[(LONG)entry_index] == 0) {
                    seen_flags[(LONG)entry_index] = 1;
                }
            }

            entry_index += 1;
            while (entry_index < entry_count) {
                COI_EntryTableEntry *dup_entry;
                COI_AnimObject *dup_anim;

                if (disk_id == TEXTDISP_SecondaryGroupCode &&
                    (UBYTE)(TEXTDISP_SecondaryGroupPresentFlag - 1) == 0) {
                    dup_entry = TEXTDISP_SecondaryEntryPtrTable[(LONG)entry_index];
                } else {
                    dup_entry = TEXTDISP_PrimaryEntryPtrTable[(LONG)entry_index];
                }
                if (ESQ_WildcardMatch(source_entry->titleText, dup_entry->titleText) == 0 &&
                    seen_flags[(LONG)entry_index] == 0) {
                    WORD subentry_index;

                    seen_flags[(LONG)entry_index] = 1;
                    dup_anim = dup_entry->anim;
                    dup_anim->field4 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        source_anim->field4,
                        dup_anim->field4);
                    dup_anim->mode0 = source_anim->mode0;
                    dup_anim->mode1 = source_anim->mode1;
                    dup_anim->mode2 = source_anim->mode2;
                    dup_anim->mode3 = source_anim->mode3;
                    dup_anim->field12 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        source_anim->field12,
                        dup_anim->field12);
                    dup_anim->field16 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        source_anim->field16,
                        dup_anim->field16);
                    dup_anim->field20 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        source_anim->field20,
                        dup_anim->field20);
                    dup_anim->field8 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        source_anim->field8,
                        dup_anim->field8);
                    dup_anim->field24 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        source_anim->field24,
                        dup_anim->field24);
                    dup_anim->field28 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                        source_anim->field28,
                        dup_anim->field28);
                    dup_anim->field32 = source_anim->field32;
                    dup_anim->subEntryCount = source_anim->subEntryCount;
                    COI_AllocSubEntryTable(dup_entry);

                    subentry_index = 0;
                    while (subentry_index < dup_anim->subEntryCount) {
                        COI_SubEntry *dst_subentry;
                        COI_SubEntry *src_subentry;

                        dst_subentry = dup_anim->subEntryTable[(LONG)subentry_index];
                        src_subentry = source_anim->subEntryTable[(LONG)subentry_index];
                        dst_subentry->key0 = src_subentry->key0;
                        dst_subentry->field6 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                            src_subentry->field6,
                            dst_subentry->field6);
                        dst_subentry->field10 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                            src_subentry->field10,
                            dst_subentry->field10);
                        dst_subentry->field14 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                            src_subentry->field14,
                            dst_subentry->field14);
                        dst_subentry->field2 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                            src_subentry->field2,
                            dst_subentry->field2);
                        dst_subentry->field18 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                            src_subentry->field18,
                            dst_subentry->field18);
                        dst_subentry->field22 = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(
                            src_subentry->field22,
                            dst_subentry->field22);
                        dst_subentry->field26 = src_subentry->field26;
                        subentry_index += 1;
                    }
                }

                entry_index += 1;
            }
        }

        record_index += 1;
    }

    if (Global_PTR_WORK_BUFFER != (char *)0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_COI_C_1,
            COI_RECORD_DEALLOC_LINE,
            original_buffer,
            file_size + COI_WORK_BUFFER_TRAILING_NUL_BYTES);
    }

    return COI_SUCCESS;
}
