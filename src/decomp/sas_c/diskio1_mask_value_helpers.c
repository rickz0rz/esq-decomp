typedef unsigned char UBYTE;

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
    gDiskio1MaskValueBitIndex = 1;
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
    gDiskio1MaskValueBitIndex = 1;
    DISKIO1_AppendBlackoutMaskSelectedTimes();
}

void DISKIO1_AppendBlackoutMaskValueTerminator(void)
{
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_BlackoutListCloseParenNewline);
    DISKIO1_DumpDefaultCoiInfoBlock();
}
