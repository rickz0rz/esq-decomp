__asm__(
    ".globl _DISKIO1_AppendBlackoutMaskAllIfAllBitsSet\n"
    "_DISKIO1_AppendBlackoutMaskAllIfAllBitsSet:\n"
    "DISKIO1_AppendBlackoutMaskAllIfAllBitsSet:\n"
    "    CMPI.L  #0x5fa,D5\n"
    "    BEQ.S   1f\n"
    "    JMP     DISKIO1_AppendBlackoutMaskValueHeader\n"
    "1:\n"
    "    PEA     DISKIO_STR_BLACKED_OUT\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    JMP     DISKIO1_DumpDefaultCoiInfoBlock\n"
);
