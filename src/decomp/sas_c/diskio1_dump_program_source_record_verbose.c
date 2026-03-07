typedef unsigned char UBYTE;
typedef unsigned long ULONG;

enum {
    MASK_INDEX_0 = 0,
    MASK_INDEX_1 = 1,
    MASK_INDEX_2 = 2,
    MASK_INDEX_3 = 3,
    MASK_INDEX_4 = 4,
    MASK_BYTE_COUNT = 6,
    MASK_LAST_INDEX = MASK_BYTE_COUNT - 1,
    CHANNEL_NUMBER_LEN = 11,
    SOURCE_NAME_LEN = 7,
    CALL_LETTERS_LEN = 8,
    BACKGROUND_TEXT_LEN = 3,
    ATTR_FLAG_NONE = 0x01,
    ATTR_FLAG_HILITE_SRC = 0x02,
    ATTR_FLAG_SUM_SRC = 0x04,
    ATTR_FLAG_VIDEO_TAG_DISABLE = 0x08,
    ATTR_FLAG_PPV_SRC = 0x10,
    ATTR_FLAG_DITTO = 0x20,
    ATTR_FLAG_ALT_HILITE_SRC = 0x40,
    ATTR_FLAG_STEREO = 0x80
};

struct DiskioProgramSourceRecord {
    UBYTE etid;
    char channelNumber[CHANNEL_NUMBER_LEN];
    char source[SOURCE_NAME_LEN];
    char callLetters[CALL_LETTERS_LEN];
    UBYTE attrFlags;
    UBYTE timeSlotMask[MASK_BYTE_COUNT];
    UBYTE blackoutMask[MASK_BYTE_COUNT];
    UBYTE sourceFlagsByte;
    UBYTE backgroundColor0;
    UBYTE backgroundColor1;
    char backgroundText[BACKGROUND_TEXT_LEN];
    unsigned short sourceFlagsWord;
};

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);

extern const char *Global_REF_STR_CLOCK_FORMAT[];
extern const char DISKIO_FMT_CHANNEL_LINE_UP_PCT_D[];
extern const char DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT[];
extern const char DISKIO_STR_ATTR[];
extern const char DISKIO_STR_NONE_VerboseSourceAttrFlags[];
extern const char DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags[];
extern const char DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags[];
extern const char DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags[];
extern const char DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags[];
extern const char DISKIO_STR_DITTO_VerboseSourceAttrFlags[];
extern const char DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags[];
extern const char DISKIO_STR_STEREO[];
extern const char DISKIO_STR_ProgramAttrCloseParenNewline[];
extern const char DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC[];
extern const char DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_[];
extern const char DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord[];

void DISKIO1_DumpProgramSourceRecordVerbose(
    const struct DiskioProgramSourceRecord *rec,
    ULONG channelLineup)
{
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_CHANNEL_LINE_UP_PCT_D,
        channelLineup);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_ETID_PCT_D_CHAN_NUM_PCT_S_SOURCE_PCT,
        (ULONG)rec->etid,
        rec->channelNumber,
        rec->source,
        rec->callLetters);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_ATTR);

    if (rec->attrFlags == ATTR_FLAG_NONE) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_NONE_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & ATTR_FLAG_HILITE_SRC) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & ATTR_FLAG_SUM_SRC) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & ATTR_FLAG_VIDEO_TAG_DISABLE) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & ATTR_FLAG_PPV_SRC) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & ATTR_FLAG_DITTO) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_DITTO_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & ATTR_FLAG_ALT_HILITE_SRC) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & ATTR_FLAG_STEREO) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_STEREO);
    }

    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_ProgramAttrCloseParenNewline);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_TSLT_MASK_PCT_02X_PCT_02X_PCT_02X_PC,
        (ULONG)rec->timeSlotMask[MASK_INDEX_0],
        (ULONG)rec->timeSlotMask[MASK_INDEX_1],
        (ULONG)rec->timeSlotMask[MASK_INDEX_2],
        (ULONG)rec->timeSlotMask[MASK_INDEX_3],
        (ULONG)rec->timeSlotMask[MASK_INDEX_4],
        (ULONG)rec->timeSlotMask[MASK_LAST_INDEX]);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_,
        (ULONG)rec->blackoutMask[MASK_INDEX_0],
        (ULONG)rec->blackoutMask[MASK_INDEX_1],
        (ULONG)rec->blackoutMask[MASK_INDEX_2],
        (ULONG)rec->blackoutMask[MASK_INDEX_3],
        (ULONG)rec->blackoutMask[MASK_INDEX_4],
        (ULONG)rec->blackoutMask[MASK_LAST_INDEX]);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord,
        (ULONG)rec->sourceFlagsByte,
        (ULONG)rec->sourceFlagsWord,
        (ULONG)rec->backgroundColor0,
        (ULONG)rec->backgroundColor1,
        rec->backgroundText);
}
