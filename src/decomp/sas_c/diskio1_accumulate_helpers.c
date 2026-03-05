typedef unsigned char UBYTE;
typedef unsigned long ULONG;

extern void DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet(void);
extern void DISKIO1_AppendBlackoutMaskNoneIfEmpty(void);

volatile UBYTE gDiskio1TimeMaskTable[64];
volatile UBYTE gDiskio1BlackoutMaskTable[64];
volatile ULONG gDiskio1MaskSum;
volatile ULONG gDiskio1MaskIndex;

void DISKIO1_AccumulateTimeSlotMaskSum(void)
{
    while (gDiskio1MaskIndex < 6) {
        gDiskio1MaskSum += gDiskio1TimeMaskTable[28 + gDiskio1MaskIndex];
        gDiskio1MaskIndex++;
    }
    DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet();
}

void DISKIO1_AccumulateBlackoutMaskSum(void)
{
    while (gDiskio1MaskIndex < 6) {
        gDiskio1MaskSum += gDiskio1BlackoutMaskTable[34 + gDiskio1MaskIndex];
        gDiskio1MaskIndex++;
    }
    DISKIO1_AppendBlackoutMaskNoneIfEmpty();
}
