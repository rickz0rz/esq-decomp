typedef unsigned char UBYTE;

extern void DISKIO1_AppendTimeSlotMaskSelectedTimes(void);
extern void DISKIO1_AppendBlackoutMaskSelectedTimes(void);

/* Scratch byte used only to force a byte increment pattern in SAS/C output. */
volatile UBYTE gDiskio1AdvanceHelperBitIndex;

void DISKIO1_AdvanceTimeSlotBitIndex(void)
{
    gDiskio1AdvanceHelperBitIndex++;
    DISKIO1_AppendTimeSlotMaskSelectedTimes();
}

void DISKIO1_AdvanceBlackoutBitIndex(void)
{
    gDiskio1AdvanceHelperBitIndex++;
    DISKIO1_AppendBlackoutMaskSelectedTimes();
}
