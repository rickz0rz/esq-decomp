__asm__(
    ".globl _DISKIO1_AppendBlackoutMaskValueTerminator\n"
    "_DISKIO1_AppendBlackoutMaskValueTerminator:\n"
    "DISKIO1_AppendBlackoutMaskValueTerminator:\n"
    "    PEA     DISKIO_STR_BlackoutListCloseParenNewline\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    JMP     DISKIO1_DumpDefaultCoiInfoBlock\n"
);
