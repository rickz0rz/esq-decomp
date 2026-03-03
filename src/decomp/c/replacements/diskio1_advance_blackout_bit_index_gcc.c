__asm__(
    ".globl _DISKIO1_AdvanceBlackoutBitIndex\n"
    "_DISKIO1_AdvanceBlackoutBitIndex:\n"
    "DISKIO1_AdvanceBlackoutBitIndex:\n"
    "    ADDQ.B  #1,D4\n"
    "    JMP     DISKIO1_AppendBlackoutMaskSelectedTimes\n"
);
