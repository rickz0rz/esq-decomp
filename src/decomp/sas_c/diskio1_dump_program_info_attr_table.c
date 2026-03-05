typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);
extern void GROUP_AG_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen);
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
    char escaped[41];

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROGRAM_INFO_PCT_D,
        programInfoId);

    if (rec == 0) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_C);
        return;
    }

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROG_SRCE_PCT_S_ProgramInfoAttrTable,
        rec);

    for (i = 1; i < 49; i++) {
        ULONG attr = (ULONG)rec[7 + i];
        const char *programText = ((const char *const *)(rec + 56))[i];

        if (attr == 1 && programText == 0) {
            continue;
        }

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_PCT_02D_PCT_S_COLON_ATTR,
            i,
            Global_REF_STR_CLOCK_FORMAT[i]);

        if (attr == 1) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NONE_ProgramInfoAttrTable);
        }
        if (attr & 0x02) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_MOVIE_ProgramInfoAttrTable);
        }
        if (attr & 0x04) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_ALTHILITE_PROG_ProgramInfoAttrTable);
        }
        if (attr & 0x08) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_TAG_PROG_ProgramInfoAttrTable);
        }
        if (attr & 0x10) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_SPORTSPROG);
        }
        if (attr & 0x20) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X20_ProgramInfoAttrTable);
        }
        if (attr & 0x40) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_REPEATPROG);
        }
        if (attr & 0x80) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_PREV_DAYS_DATA_ProgramInfoAttrTable);
        }

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ProgramAttrCloseAndProgQuotedPrefix);

        if (programText != 0) {
            GROUP_AG_JMPTBL_STRING_CopyPadNul(escaped, programText, 40);
        } else {
            const char *src = DISKIO_TAG_NONE;
            char *dst = escaped;
            do {
                *dst = *src;
                dst++;
                src++;
            } while (dst[-1] != 0);
        }

        GROUP_AG_JMPTBL_LADFUNC2_EmitEscapedStringToScratch(escaped);
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_ProgramStringSuffixWithTypeFields,
            (ULONG)rec[0xfc + i],
            (ULONG)rec[0x12d + i],
            (ULONG)rec[0x15e + i]);
    }
}
