typedef unsigned char UBYTE;
typedef unsigned long ULONG;

enum {
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
    char channelNumber[11];
    char source[7];
    char callLetters[8];
    UBYTE attrFlags;
    UBYTE timeSlotMask[6];
    UBYTE blackoutMask[6];
    UBYTE sourceFlagsByte;
    UBYTE backgroundColor0;
    UBYTE backgroundColor1;
    char backgroundText[3];
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
        (ULONG)rec->timeSlotMask[0],
        (ULONG)rec->timeSlotMask[1],
        (ULONG)rec->timeSlotMask[2],
        (ULONG)rec->timeSlotMask[3],
        (ULONG)rec->timeSlotMask[4],
        (ULONG)rec->timeSlotMask[5]);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_BLKOUT_MASK_PCT_02X_PCT_02X_PCT_02X_,
        (ULONG)rec->blackoutMask[0],
        (ULONG)rec->blackoutMask[1],
        (ULONG)rec->blackoutMask[2],
        (ULONG)rec->blackoutMask[3],
        (ULONG)rec->blackoutMask[4],
        (ULONG)rec->blackoutMask[5]);
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_FLAG1_0X_PCT_02X_FLAG2_0X_PCT_04X_BG_VerboseSourceRecord,
        (ULONG)rec->sourceFlagsByte,
        (ULONG)rec->sourceFlagsWord,
        (ULONG)rec->backgroundColor0,
        (ULONG)rec->backgroundColor1,
        rec->backgroundText);
}
