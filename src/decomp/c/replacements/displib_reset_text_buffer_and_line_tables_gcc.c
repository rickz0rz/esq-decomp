__asm__(
    ".globl _DISPLIB_ResetTextBufferAndLineTables\n"
    "_DISPLIB_ResetTextBufferAndLineTables:\n"
    "DISPLIB_ResetTextBufferAndLineTables:\n"
    "    MOVE.L  DISPTEXT_TextBufferPtr,-(A7)\n"
    "    CLR.L   -(A7)\n"
    "    JSR     GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)\n"
    "\n"
    "    MOVE.L  D0,DISPTEXT_TextBufferPtr\n"
    "    BSR.S   DISPLIB_ResetLineTables\n"
    "\n"
    "    ADDQ.W  #8,A7\n"
    "    RTS\n"
);
