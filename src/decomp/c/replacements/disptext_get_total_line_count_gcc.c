__asm__(
    ".globl _DISPTEXT_GetTotalLineCount\n"
    "_DISPTEXT_GetTotalLineCount:\n"
    "DISPTEXT_GetTotalLineCount:\n"
    "    BSR.W   DISPTEXT_FinalizeLineTable\n"
    "\n"
    "    MOVEQ   #0,D0\n"
    "    MOVE.W  DISPTEXT_TargetLineIndex,D0\n"
    "    RTS\n"
);
