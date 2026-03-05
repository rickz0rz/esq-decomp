typedef unsigned char UBYTE;
typedef unsigned long ULONG;

struct DiskioProgramSourceRecord {
    UBYTE etid;
    char channelNumber[11];
    char source[7];
    char callLetters[8];
    UBYTE attrFlags;
    UBYTE timeSlotMask[6];
    UBYTE blackoutMask[6];
    UBYTE flag1;
    UBYTE bg0;
    UBYTE bg1;
    char bgText[3];
    unsigned short flag2;
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

    if (rec->attrFlags == 1) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_NONE_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & 0x02) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_HILITE_SRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & 0x04) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_SUM_SRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & 0x08) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_VIDEO_TAG_DISABLE_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & 0x10) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_PPV_SRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & 0x20) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_DITTO_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & 0x40) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(
            DISKIO_STR_ALTHILITESRC_VerboseSourceAttrFlags);
    }
    if (rec->attrFlags & 0x80) {
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
        (ULONG)rec->flag1,
        (ULONG)rec->flag2,
        (ULONG)rec->bg0,
        (ULONG)rec->bg1,
        rec->bgText);
}
