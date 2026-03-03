__asm__(
    ".globl _COI_AppendAnimFieldWithTrailingSpace_Return\n"
    "_COI_AppendAnimFieldWithTrailingSpace_Return:\n"
    "COI_AppendAnimFieldWithTrailingSpace_Return:\n"
    "    MOVE.L  A2,D0\n"
    "    MOVEM.L (A7)+,D7/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
