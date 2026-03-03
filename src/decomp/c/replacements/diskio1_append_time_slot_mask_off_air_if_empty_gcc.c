__asm__(
    ".globl _DISKIO1_AppendTimeSlotMaskOffAirIfEmpty\n"
    "_DISKIO1_AppendTimeSlotMaskOffAirIfEmpty:\n"
    "DISKIO1_AppendTimeSlotMaskOffAirIfEmpty:\n"
    "    TST.L   D5\n"
    "    BEQ.S   1f\n"
    "    JMP     DISKIO1_AppendTimeSlotMaskValueHeader\n"
    "1:\n"
    "    PEA     Global_STR_OFF_AIR_2\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    JMP     DISKIO1_FormatBlackoutMaskFlags\n"
);
