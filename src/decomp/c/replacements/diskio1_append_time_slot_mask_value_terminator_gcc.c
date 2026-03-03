__asm__(
    ".globl _DISKIO1_AppendTimeSlotMaskValueTerminator\n"
    "_DISKIO1_AppendTimeSlotMaskValueTerminator:\n"
    "DISKIO1_AppendTimeSlotMaskValueTerminator:\n"
    "    PEA     DISKIO_STR_TimeSlotListCloseParenNewline\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    JMP     DISKIO1_FormatBlackoutMaskFlags\n"
);
