__asm__(
    ".globl _DISKIO1_AdvanceTimeSlotBitIndex\n"
    "_DISKIO1_AdvanceTimeSlotBitIndex:\n"
    "DISKIO1_AdvanceTimeSlotBitIndex:\n"
    "    ADDQ.B  #1,D4\n"
    "    JMP     DISKIO1_AppendTimeSlotMaskSelectedTimes\n"
);
