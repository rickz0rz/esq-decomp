__asm__(
    ".globl _DISKIO1_AppendTimeSlotMaskValueHeader\n"
    "_DISKIO1_AppendTimeSlotMaskValueHeader:\n"
    "DISKIO1_AppendTimeSlotMaskValueHeader:\n"
    "    PEA     DISKIO_STR_TimeSlotListOpenParen\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    MOVEQ   #1,D4\n"
    "    JMP     DISKIO1_AppendTimeSlotMaskSelectedTimes\n"
);
