__asm__(
    ".globl _COI_TestEntryWithinTimeWindow_Return\n"
    "_COI_TestEntryWithinTimeWindow_Return:\n"
    "COI_TestEntryWithinTimeWindow_Return:\n"
    "    MOVE.L  -4(A5),D0\n"
    "    MOVEM.L (A7)+,D5-D7/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
