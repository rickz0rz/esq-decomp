__asm__(
    ".globl _ESQPARS_ReplaceOwnedString_Return\n"
    "_ESQPARS_ReplaceOwnedString_Return:\n"
    "ESQPARS_ReplaceOwnedString_Return:\n"
    "    MOVEM.L (A7)+,D6-D7/A2-A3\n"
    "    RTS\n"
);
