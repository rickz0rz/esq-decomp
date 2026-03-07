typedef unsigned char UBYTE;

#define ATTRFLAG_HILITE_SRC_MASK 0x02
#define ATTRFLAG_SUMMARY_SRC_MASK 0x04
#define ATTRFLAG_VIDEO_TAG_DISABLE_MASK 0x08
#define ATTRFLAG_PPV_SRC_MASK 0x10
#define ATTRFLAG_DITTO_MASK 0x20
#define ATTRFLAG_ALT_HILITE_SRC_MASK 0x40
#define ATTRFLAG_BIT7_MASK 0x80

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *text);

extern void DISKIO1_AppendAttrFlagSummarySrc(void);
extern void DISKIO1_AppendAttrFlagVideoTagDisable(void);
extern void DISKIO1_AppendAttrFlagPpvSrc(void);
extern void DISKIO1_AppendAttrFlagDitto(void);
extern void DISKIO1_AppendAttrFlagAltHiliteSrc(void);
extern void DISKIO1_AppendAttrFlagBit7(void);
extern void DISKIO1_FormatTimeSlotMaskFlags(void);

extern const char DISKIO_STR_HILITE_SRC_CompactSourceAttrFlags[];
extern const char DISKIO_STR_SUM_SRC_CompactSourceAttrFlags[];
extern const char DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags[];
extern const char DISKIO_STR_PPV_SRC_CompactSourceAttrFlags[];
extern const char DISKIO_STR_DITTO_CompactSourceAttrFlags[];
extern const char DISKIO_STR_ALTHILITESRC_CompactSourceAttrFlags[];
extern const char DISKIO_STR_0X80[];

volatile UBYTE gDiskio1AttrFlags;

void DISKIO1_AppendAttrFlagHiliteSrc(void)
{
    if (gDiskio1AttrFlags & ATTRFLAG_HILITE_SRC_MASK) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_HILITE_SRC_CompactSourceAttrFlags);
    }
    DISKIO1_AppendAttrFlagSummarySrc();
}

void DISKIO1_AppendAttrFlagSummarySrc(void)
{
    if (gDiskio1AttrFlags & ATTRFLAG_SUMMARY_SRC_MASK) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_SUM_SRC_CompactSourceAttrFlags);
    }
    DISKIO1_AppendAttrFlagVideoTagDisable();
}

void DISKIO1_AppendAttrFlagVideoTagDisable(void)
{
    if (gDiskio1AttrFlags & ATTRFLAG_VIDEO_TAG_DISABLE_MASK) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags);
    }
    DISKIO1_AppendAttrFlagPpvSrc();
}

void DISKIO1_AppendAttrFlagPpvSrc(void)
{
    if (gDiskio1AttrFlags & ATTRFLAG_PPV_SRC_MASK) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_PPV_SRC_CompactSourceAttrFlags);
    }
    DISKIO1_AppendAttrFlagDitto();
}

void DISKIO1_AppendAttrFlagDitto(void)
{
    if (gDiskio1AttrFlags & ATTRFLAG_DITTO_MASK) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_DITTO_CompactSourceAttrFlags);
    }
    DISKIO1_AppendAttrFlagAltHiliteSrc();
}

void DISKIO1_AppendAttrFlagAltHiliteSrc(void)
{
    if (gDiskio1AttrFlags & ATTRFLAG_ALT_HILITE_SRC_MASK) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_ALTHILITESRC_CompactSourceAttrFlags);
    }
    DISKIO1_AppendAttrFlagBit7();
}

void DISKIO1_AppendAttrFlagBit7(void)
{
    if (gDiskio1AttrFlags & ATTRFLAG_BIT7_MASK) {
        GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_0X80);
    }
    DISKIO1_FormatTimeSlotMaskFlags();
}
