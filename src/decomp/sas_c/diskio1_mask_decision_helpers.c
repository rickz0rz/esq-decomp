#include <exec/types.h>
enum {
    DISKIO1_MASK_SUM_EMPTY = 0UL,
    DISKIO1_MASK_SUM_ALL_BITS_SET = 0x5faUL
};

extern void FORMAT_RawDoFmtWithScratchBuffer(const char *text);
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
    if (gDiskio1MaskDecisionSum != DISKIO1_MASK_SUM_ALL_BITS_SET) {
        DISKIO1_AppendTimeSlotMaskOffAirIfEmpty();
        return;
    }
    FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NONE_TimeSlotMaskAllSet);
    DISKIO1_FormatBlackoutMaskFlags();
}

void DISKIO1_AppendTimeSlotMaskOffAirIfEmpty(void)
{
    if (gDiskio1MaskDecisionSum != DISKIO1_MASK_SUM_EMPTY) {
        DISKIO1_AppendTimeSlotMaskValueHeader();
        return;
    }
    FORMAT_RawDoFmtWithScratchBuffer(Global_STR_OFF_AIR_2);
    DISKIO1_FormatBlackoutMaskFlags();
}

void DISKIO1_AppendBlackoutMaskNoneIfEmpty(void)
{
    if (gDiskio1MaskDecisionSum != DISKIO1_MASK_SUM_EMPTY) {
        DISKIO1_AppendBlackoutMaskAllIfAllBitsSet();
        return;
    }
    FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_NONE_BlackoutMaskEmpty);
    DISKIO1_DumpDefaultCoiInfoBlock();
}

void DISKIO1_AppendBlackoutMaskAllIfAllBitsSet(void)
{
    if (gDiskio1MaskDecisionSum != DISKIO1_MASK_SUM_ALL_BITS_SET) {
        DISKIO1_AppendBlackoutMaskValueHeader();
        return;
    }
    FORMAT_RawDoFmtWithScratchBuffer(DISKIO_STR_BLACKED_OUT);
    DISKIO1_DumpDefaultCoiInfoBlock();
}
