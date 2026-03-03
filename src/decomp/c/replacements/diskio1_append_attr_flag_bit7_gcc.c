__asm__(
    ".globl _DISKIO1_AppendAttrFlagBit7\n"
    "_DISKIO1_AppendAttrFlagBit7:\n"
    "DISKIO1_AppendAttrFlagBit7:\n"
    "    BTST    #7,27(A3)\n"
    "    BEQ.S   1f\n"
    "    PEA     DISKIO_STR_0X80\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "1:\n"
    "    JMP     DISKIO1_FormatTimeSlotMaskFlags\n"
);
