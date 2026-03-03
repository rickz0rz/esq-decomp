__asm__(
    ".globl _DISKIO1_AppendBlackoutMaskValueHeader\n"
    "_DISKIO1_AppendBlackoutMaskValueHeader:\n"
    "DISKIO1_AppendBlackoutMaskValueHeader:\n"
    "    PEA     DISKIO_STR_BlackoutListOpenParen\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "    MOVEQ   #1,D4\n"
    "    JMP     DISKIO1_AppendBlackoutMaskSelectedTimes\n"
);
