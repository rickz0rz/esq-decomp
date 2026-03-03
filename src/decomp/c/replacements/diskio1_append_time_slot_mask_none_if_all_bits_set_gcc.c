__asm__(
    ".globl _DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet\n"
    "_DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet:\n"
    "DISKIO1_AppendTimeSlotMaskNoneIfAllBitsSet:\n"
    "    CMPI.L  #0x5fa,D5\n"
    "    BEQ.S   1f\n"
    "    JMP     DISKIO1_AppendTimeSlotMaskOffAirIfEmpty\n"
    "1:\n"
    "    PEA     DISKIO_STR_NONE_TimeSlotMaskAllSet\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    JMP     DISKIO1_FormatBlackoutMaskFlags\n"
);
