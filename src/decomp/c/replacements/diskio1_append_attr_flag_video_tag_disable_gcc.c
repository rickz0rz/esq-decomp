__asm__(
    ".globl _DISKIO1_AppendAttrFlagVideoTagDisable\n"
    "_DISKIO1_AppendAttrFlagVideoTagDisable:\n"
    "DISKIO1_AppendAttrFlagVideoTagDisable:\n"
    "    BTST    #3,27(A3)\n"
    "    BEQ.S   1f\n"
    "    PEA     DISKIO_STR_VIDEO_TAG_DISABLE_CompactSourceAttrFlags\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "1:\n"
    "    JMP     DISKIO1_AppendAttrFlagPpvSrc\n"
);
