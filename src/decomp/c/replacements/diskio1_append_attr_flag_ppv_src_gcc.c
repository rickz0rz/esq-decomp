__asm__(
    ".globl _DISKIO1_AppendAttrFlagPpvSrc\n"
    "_DISKIO1_AppendAttrFlagPpvSrc:\n"
    "DISKIO1_AppendAttrFlagPpvSrc:\n"
    "    BTST    #4,27(A3)\n"
    "    BEQ.S   1f\n"
    "    PEA     DISKIO_STR_PPV_SRC_CompactSourceAttrFlags\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "1:\n"
    "    JMP     DISKIO1_AppendAttrFlagDitto\n"
);
