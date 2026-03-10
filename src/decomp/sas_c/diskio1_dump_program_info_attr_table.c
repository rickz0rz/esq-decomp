typedef unsigned char UBYTE;
typedef unsigned long ULONG;

#define PROGRAM_NULL 0
#define PROGRAM_SLOT_FIRST 1
#define PROGRAM_SLOT_END 49
#define PROGRAM_ATTR_TABLE_OFFSET 7
#define PROGRAM_TEXT_PTR_TABLE_OFFSET 56
#define PROGRAM_TYPE0_TABLE_OFFSET 0xfc
#define PROGRAM_TYPE1_TABLE_OFFSET 0x12d
#define PROGRAM_TYPE2_TABLE_OFFSET 0x15e
#define PROGRAM_TEXT_COPY_MAX 40
#define PROGRAM_TEXT_BUFFER_SIZE (PROGRAM_TEXT_COPY_MAX + 1)
#define ATTR_FLAG_NONE 0x01
#define ATTR_FLAG_MOVIE 0x02
#define ATTR_FLAG_ALT_HILITE 0x04
#define ATTR_FLAG_TAG 0x08
#define ATTR_FLAG_SPORTS 0x10
#define ATTR_FLAG_BIT20 0x20
#define ATTR_FLAG_REPEAT 0x40
#define ATTR_FLAG_PREV_DAYS 0x80

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);
extern char *GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);
extern void GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(const char *text);

extern const char *Global_REF_STR_CLOCK_FORMAT[];
extern const char DISKIO_FMT_PROGRAM_INFO_PCT_D[];
extern const char DISKIO_STR_NewlineOnly_C[];
extern const char DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable[];
extern const char DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR[];
extern const char DISKIO_STR_NONE_ProgramInfoAttrTable[];
extern const char DISKIO_STR_MOVIE_ProgramInfoAttrTable[];
extern const char DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable[];
extern const char DISKIO_STR_TAG_PROG_ProgramInfoAttrTable[];
extern const char DISKIO_STR_SPORTSPROG[];
extern const char DISKIO_STR_0X20_ProgramInfoAttrTable[];
extern const char DISKIO_STR_REPEATPROG[];
extern const char DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable[];
extern const char DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix[];
extern const char DISKIO_TAG_NONE[];
extern const char DISKIO_FMT_ProgramStringSuffixWithTypeFields[];

void DISKIO1_DumpProgramInfoAttrTable(const UBYTE *rec, ULONG programInfoId)
{
    ULONG i;
    char escaped[PROGRAM_TEXT_BUFFER_SIZE];

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROGRAM_INFO_PCT_D,
        programInfoId);

    if (rec == (const UBYTE *)PROGRAM_NULL) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_C);
        return;
    }

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable,
        rec);

    for (i = PROGRAM_SLOT_FIRST; i < PROGRAM_SLOT_END; i++) {
        ULONG attr = (ULONG)rec[PROGRAM_ATTR_TABLE_OFFSET + i];
        const char *programText = ((const char *const *)(rec + PROGRAM_TEXT_PTR_TABLE_OFFSET))[i];

        if (attr == ATTR_FLAG_NONE && programText == (const char *)PROGRAM_NULL) {
            continue;
        }

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR,
            i,
            Global_REF_STR_CLOCK_FORMAT[i]);

        if (attr == ATTR_FLAG_NONE) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NONE_ProgramInfoAttrTable);
        }
        if (attr & ATTR_FLAG_MOVIE) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_MOVIE_ProgramInfoAttrTable);
        }
        if (attr & ATTR_FLAG_ALT_HILITE) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable);
        }
        if (attr & ATTR_FLAG_TAG) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_TAG_PROG_ProgramInfoAttrTable);
        }
        if (attr & ATTR_FLAG_SPORTS) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_SPORTSPROG);
        }
        if (attr & ATTR_FLAG_BIT20) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X20_ProgramInfoAttrTable);
        }
        if (attr & ATTR_FLAG_REPEAT) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_REPEATPROG);
        }
        if (attr & ATTR_FLAG_PREV_DAYS) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable);
        }

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix);

        if (programText != (const char *)PROGRAM_NULL) {
            GROUP_AG_JMPTBL_STRING_CopyPadNul(escaped, programText, PROGRAM_TEXT_COPY_MAX);
        } else {
            const char *src = DISKIO_TAG_NONE;
            char *dst = escaped;
            do {
                *dst = *src;
                dst++;
                src++;
            } while (dst[-1] != PROGRAM_NULL);
        }

        GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(escaped);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_ProgramStringSuffixWithTypeFields,
            (ULONG)rec[PROGRAM_TYPE0_TABLE_OFFSET + i],
            (ULONG)rec[PROGRAM_TYPE1_TABLE_OFFSET + i],
            (ULONG)rec[PROGRAM_TYPE2_TABLE_OFFSET + i]);
    }
}
