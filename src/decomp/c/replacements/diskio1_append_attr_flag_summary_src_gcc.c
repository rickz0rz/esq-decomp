__asm__(
    ".globl _DISKIO1_AppendAttrFlagSummarySrc\n"
    "_DISKIO1_AppendAttrFlagSummarySrc:\n"
    "DISKIO1_AppendAttrFlagSummarySrc:\n"
    "    BTST    #2,27(A3)\n"
    "    BEQ.S   1f\n"
    "    PEA     DISKIO_STR_SUM_SRC_CompactSourceAttrFlags\n"
    "    JSR     GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer\n"
    "    ADDQ.W  #4,A7\n"
    "1:\n"
    "    JMP     DISKIO1_AppendAttrFlagVideoTagDisable\n"
);
