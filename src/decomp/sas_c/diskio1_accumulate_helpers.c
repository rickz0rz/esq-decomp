typedef unsigned char UBYTE;
typedef unsigned long ULONG;

enum {
    DISKIO1_MASK_INDEX_STEP = 1,
    DISKIO1_MASK_TABLE_SIZE = 64,
    DISKIO1_MASK_SUM_COUNT = 6,
    DISKIO1_TIME_MASK_BASE = 28,
    DISKIO1_BLACKOUT_MASK_BASE = 34
};

extern void DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet(void);
extern void DISKIO1_AppendBlackoutMaskNoneIfEmpty(void);

volatile UBYTE gDiskio1TimeMaskTable[DISKIO1_MASK_TABLE_SIZE];
volatile UBYTE gDiskio1BlackoutMaskTable[DISKIO1_MASK_TABLE_SIZE];
volatile ULONG gDiskio1MaskSum;
volatile ULONG gDiskio1MaskIndex;

void DISKIO1_AccumulateTimeSlotMaskSum(void)
{
    while (gDiskio1MaskIndex < DISKIO1_MASK_SUM_COUNT) {
        gDiskio1MaskSum += gDiskio1TimeMaskTable[DISKIO1_TIME_MASK_BASE + gDiskio1MaskIndex];
        gDiskio1MaskIndex += DISKIO1_MASK_INDEX_STEP;
    }
    DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet();
}

void DISKIO1_AccumulateBlackoutMaskSum(void)
{
    while (gDiskio1MaskIndex < DISKIO1_MASK_SUM_COUNT) {
        gDiskio1MaskSum += gDiskio1BlackoutMaskTable[DISKIO1_BLACKOUT_MASK_BASE + gDiskio1MaskIndex];
        gDiskio1MaskIndex += DISKIO1_MASK_INDEX_STEP;
    }
    DISKIO1_AppendBlackoutMaskNoneIfEmpty();
}
