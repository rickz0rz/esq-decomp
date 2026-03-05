typedef unsigned long ULONG;

extern void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(const char *text);
extern void DISKIO1_AppendTimeSlotMaskOffAirIfEmpty(void);
extern void DISKIO1_FormatBlackoutMaskFlags(void);
extern void DISKIO1_AppendTimeSlotMaskValueHeader(void);
extern void DISKIO1_AppendBlackoutMaskAllIfAllBitsSet(void);
extern void DISKIO1_DumpDefaultCoiInfoBlock(void);
extern void DISKIO1_AppendBlackoutMaskValueHeader(void);

extern const char DISKIO_STR_NONE_TimeSlotMaskAllSet[];
extern const char Global_STR_OFF_AIR_2[];
extern const char DISKIO_STR_NONE_BlackoutMaskEmpty[];
extern const char DISKIO_STR_BLACKED_OUT[];

volatile ULONG gDiskio1MaskDecisionSum;

void DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet(void)
{
    if (gDiskio1MaskDecisionSum != 0x5faUL) {
        DISKIO1_AppendTimeSlotMaskOffAirIfEmpty();
        return;
    }
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NONE_TimeSlotMaskAllSet);
    DISKIO1_FormatBlackoutMaskFlags();
}

void DISKIO1_AppendTimeSlotMaskOffAirIfEmpty(void)
{
    if (gDiskio1MaskDecisionSum != 0) {
        DISKIO1_AppendTimeSlotMaskValueHeader();
        return;
    }
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(Global_STR_OFF_AIR_2);
    DISKIO1_FormatBlackoutMaskFlags();
}

void DISKIO1_AppendBlackoutMaskNoneIfEmpty(void)
{
    if (gDiskio1MaskDecisionSum != 0) {
        DISKIO1_AppendBlackoutMaskAllIfAllBitsSet();
        return;
    }
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NONE_BlackoutMaskEmpty);
    DISKIO1_DumpDefaultCoiInfoBlock();
}

void DISKIO1_AppendBlackoutMaskAllIfAllBitsSet(void)
{
    if (gDiskio1MaskDecisionSum != 0x5faUL) {
        DISKIO1_AppendBlackoutMaskValueHeader();
        return;
    }
    GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_BLACKED_OUT);
    DISKIO1_DumpDefaultCoiInfoBlock();
}
