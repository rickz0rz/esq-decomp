typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

extern const char *Global_REF_STR_CLOCK_FORMAT[];
extern const char DISKIO_FMT_PROGRAM_INFO_PCT_LD[];
extern const char DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo[];
extern const char DISKIO_STR_NewlineOnly_A[];
extern const char DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX[];
extern const char DISKIO_STR_NONE_VerboseProgramAttrFlags[];
extern const char DISKIO_STR_MOVIE_VerboseProgramAttrFlags[];
extern const char DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags[];
extern const char DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags[];
extern const char DISKIO_STR_0X10[];
extern const char DISKIO_STR_0X20_VerboseProgramAttrFlags[];
extern const char DISKIO_STR_0X40[];
extern const char DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags[];
extern const char DISKIO_STR_ProgramAttrCloseAndProgPrefix[];
extern const char DISKIO_FMT_PCT_S_VerboseProgramStringLine[];
extern const char DISKIO_STR_NullLine[];
extern const char DISKIO_STR_NewlineOnly_B[];

void DISKIO1_DumpProgramInfoVerbose(const UBYTE *rec, ULONG programInfoId)
{
    ULONG i;

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROGRAM_INFO_PCT_LD,
        programInfoId);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo,
        rec);

    if (rec == 0) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_A);
        return;
    }

    for (i = 1; i < 49; i++) {
        ULONG attr = (ULONG)rec[7 + i];
        const char *line = ((const char *const *)(rec + 56))[i];

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX,
            i,
            Global_REF_STR_CLOCK_FORMAT[i],
            attr);

        if (attr == 1) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NONE_VerboseProgramAttrFlags);
        }
        if (attr & 0x02) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_MOVIE_VerboseProgramAttrFlags);
        }
        if (attr & 0x04) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags);
        }
        if (attr & 0x08) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags);
        }
        if (attr & 0x10) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X10);
        }
        if (attr & 0x20) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X20_VerboseProgramAttrFlags);
        }
        if (attr & 0x40) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X40);
        }
        if (attr & 0x80) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags);
        }

        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ProgramAttrCloseAndProgPrefix);

        if (line != 0) {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_FMT_PCT_S_VerboseProgramStringLine,
                line);
        } else {
            GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NullLine);
        }
    }

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_B);
}
