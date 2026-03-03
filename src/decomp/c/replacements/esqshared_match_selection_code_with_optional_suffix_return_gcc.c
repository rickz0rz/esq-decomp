__asm__(
    ".globl _ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return\n"
    "_ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return:\n"
    "ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return:\n"
    "    MOVEM.L (A7)+,D4-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
