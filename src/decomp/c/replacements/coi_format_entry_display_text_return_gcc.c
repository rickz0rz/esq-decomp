__asm__(
    ".globl _COI_FormatEntryDisplayText_Return\n"
    "_COI_FormatEntryDisplayText_Return:\n"
    "COI_FormatEntryDisplayText_Return:\n"
    "    MOVE.L  20(A5),D0\n"
    "    MOVEM.L (A7)+,D2/D5-D7/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
