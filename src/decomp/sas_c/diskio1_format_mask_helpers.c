#include <exec/types.h>
enum {
    DISKIO1_MASK_INDEX_0 = 0,
    DISKIO1_MASK_INDEX_1 = 1,
    DISKIO1_MASK_INDEX_2 = 2,
    DISKIO1_MASK_INDEX_3 = 3,
    DISKIO1_MASK_INDEX_4 = 4,
    DISKIO1_MASK_BYTE_COUNT = 6,
    DISKIO1_MASK_LAST_INDEX = DISKIO1_MASK_BYTE_COUNT - 1,
    DISKIO1_MASK_SUM_INIT = 0,
    DISKIO1_MASK_INDEX_INIT = 0
};

extern void FORMAT_RawDoFmtWithScratchBuffer(const char *fmt, ...);
extern void DISKIO1_AccumulateTimeSlotMaskSum(void);
extern void DISKIO1_AccumulateBlackoutMaskSum(void);

extern const char DISKIO_STR_AttrFlagsCloseParenNewline_A[];
extern const char DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX[];
extern const char DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02[];

volatile UBYTE gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_BYTE_COUNT];
volatile UBYTE gDiskio1BlackoutMaskBytes[DISKIO1_MASK_BYTE_COUNT];
volatile ULONG gDiskio1MaskDecisionSum;
volatile ULONG gDiskio1MaskArrayIndex;

void DISKIO1_FormatTimeSlotMaskFlags(void)
{
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_STR_AttrFlagsCloseParenNewline_A);
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_TSLT_MASK_PCT_02LX_PCT_02LX_PCT_02LX,
        (ULONG)gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_INDEX_0],
        (ULONG)gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_INDEX_1],
        (ULONG)gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_INDEX_2],
        (ULONG)gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_INDEX_3],
        (ULONG)gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_INDEX_4],
        (ULONG)gDiskio1TimeSlotMaskBytes[DISKIO1_MASK_LAST_INDEX]);
    gDiskio1MaskDecisionSum = DISKIO1_MASK_SUM_INIT;
    gDiskio1MaskArrayIndex = DISKIO1_MASK_INDEX_INIT;
    DISKIO1_AccumulateTimeSlotMaskSum();
}

void DISKIO1_FormatBlackoutMaskFlags(void)
{
    FORMAT_RawDoFmtWithScratchBuffer(
        DISKIO_FMT_BLKOUT_MASK_PCT_02LX_PCT_02LX_PCT_02,
        (ULONG)gDiskio1BlackoutMaskBytes[DISKIO1_MASK_INDEX_0],
        (ULONG)gDiskio1BlackoutMaskBytes[DISKIO1_MASK_INDEX_1],
        (ULONG)gDiskio1BlackoutMaskBytes[DISKIO1_MASK_INDEX_2],
        (ULONG)gDiskio1BlackoutMaskBytes[DISKIO1_MASK_INDEX_3],
        (ULONG)gDiskio1BlackoutMaskBytes[DISKIO1_MASK_INDEX_4],
        (ULONG)gDiskio1BlackoutMaskBytes[DISKIO1_MASK_LAST_INDEX]);
    gDiskio1MaskDecisionSum = DISKIO1_MASK_SUM_INIT;
    gDiskio1MaskArrayIndex = DISKIO1_MASK_INDEX_INIT;
    DISKIO1_AccumulateBlackoutMaskSum();
}
