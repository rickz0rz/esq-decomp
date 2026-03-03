__asm__(
    ".globl _DISKIO1_AppendBlackoutMaskNoneIfEmpty\n"
    "_DISKIO1_AppendBlackoutMaskNoneIfEmpty:\n"
    "DISKIO1_AppendBlackoutMaskNoneIfEmpty:\n"
    "    TST.L   D5\n"
    "    BEQ.S   1f\n"
    "    JMP     DISKIO1_AppendBlackoutMaskAllIfAllBitsSet\n"
    "1:\n"
    "    PEA     DISKIO_STR_NONE_BlackoutMaskEmpty\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    JMP     DISKIO1_DumpDefaultCoiInfoBlock\n"
);
