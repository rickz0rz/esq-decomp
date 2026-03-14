#include <exec/types.h>
enum {
    PROGRAM_NULL = 0,
    PROGRAM_SLOT_FIRST = 1,
    PROGRAM_SLOT_PAST_LAST = 49,
    PROGRAM_ATTR_TABLE_OFFSET = 7,
    PROGRAM_LINE_TABLE_OFFSET = 56,
    PROGRAM_ATTR_NONE = 0x01,
    PROGRAM_ATTR_MOVIE = 0x02,
    PROGRAM_ATTR_ALT_HILITE = 0x04,
    PROGRAM_ATTR_TAG = 0x08,
    PROGRAM_ATTR_0X10 = 0x10,
    PROGRAM_ATTR_0X20 = 0x20,
    PROGRAM_ATTR_0X40 = 0x40,
    PROGRAM_ATTR_PREV_DAYS_DATA = 0x80
};

extern void FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

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

    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROGRAM_INFO_PCT_LD,
        programInfoId);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_PROG_SRCE_PCT_S_VerboseProgramInfo,
        rec);

    if (rec == (const UBYTE *)PROGRAM_NULL) {
        FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_A);
        return;
    }

    for (i = PROGRAM_SLOT_FIRST; i < PROGRAM_SLOT_PAST_LAST; i++) {
        ULONG attr = (ULONG)rec[PROGRAM_ATTR_TABLE_OFFSET + i];
        const char *line = ((const char *const *)(rec + PROGRAM_LINE_TABLE_OFFSET))[i];

        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_FMT_PCT_02LD_PCT_S_COLON_ATTR_PCT_02LX,
            i,
            Global_REF_STR_CLOCK_FORMAT[i],
            attr);

        if (attr == PROGRAM_ATTR_NONE) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NONE_VerboseProgramAttrFlags);
        }
        if (attr & PROGRAM_ATTR_MOVIE) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_MOVIE_VerboseProgramAttrFlags);
        }
        if (attr & PROGRAM_ATTR_ALT_HILITE) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_ALTHILITE_PROG_VerboseProgramAttrFlags);
        }
        if (attr & PROGRAM_ATTR_TAG) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_TAG_PROG_VerboseProgramAttrFlags);
        }
        if (attr & PROGRAM_ATTR_0X10) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X10);
        }
        if (attr & PROGRAM_ATTR_0X20) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X20_VerboseProgramAttrFlags);
        }
        if (attr & PROGRAM_ATTR_0X40) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_0X40);
        }
        if (attr & PROGRAM_ATTR_PREV_DAYS_DATA) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_PREV_DAYS_DATA_VerboseProgramAttrFlags);
        }

        FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ProgramAttrCloseAndProgPrefix);

        if (line != (const char *)PROGRAM_NULL) {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_FMT_PCT_S_VerboseProgramStringLine,
                line);
        } else {
            FORMAT_RawDoFmtWithScratchBuffer(
                DISKIO_STR_NullLine);
        }
    }

    FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NewlineOnly_B);
}
