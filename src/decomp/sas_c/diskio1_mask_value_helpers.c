typedef unsigned char UBYTE;

enum {
    DISKIO1_MASK_VALUE_FIRST_BIT_INDEX = 1
};

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *text);

extern void DISKIO1_AppendTimeSlotMaskSelectedTimes(void);
extern void DISKIO1_FormatBlackoutMaskFlags(void);
extern void DISKIO1_AppendBlackoutMaskSelectedTimes(void);
extern void DISKIO1_DumpDefaultCoiInfoBlock(void);

extern const char DISKIO_STR_TimeSlotListOpenParen[];
extern const char DISKIO_STR_TimeSlotListCloseParenNewline[];
extern const char DISKIO_STR_BlackoutListOpenParen[];
extern const char DISKIO_STR_BlackoutListCloseParenNewline[];

volatile UBYTE gDiskio1MaskValueBitIndex;

void DISKIO1_AppendTimeSlotMaskValueHeader(void)
{
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_TimeSlotListOpenParen);
    gDiskio1MaskValueBitIndex = DISKIO1_MASK_VALUE_FIRST_BIT_INDEX;
    DISKIO1_AppendTimeSlotMaskSelectedTimes();
}

void DISKIO1_AppendTimeSlotMaskValueTerminator(void)
{
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_TimeSlotListCloseParenNewline);
    DISKIO1_FormatBlackoutMaskFlags();
}

void DISKIO1_AppendBlackoutMaskValueHeader(void)
{
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_BlackoutListOpenParen);
    gDiskio1MaskValueBitIndex = DISKIO1_MASK_VALUE_FIRST_BIT_INDEX;
    DISKIO1_AppendBlackoutMaskSelectedTimes();
}

void DISKIO1_AppendBlackoutMaskValueTerminator(void)
{
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_BlackoutListCloseParenNewline);
    DISKIO1_DumpDefaultCoiInfoBlock();
}
