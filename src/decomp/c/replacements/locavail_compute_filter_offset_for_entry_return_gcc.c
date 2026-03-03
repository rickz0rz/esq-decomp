__asm__(
    ".globl _LOCAVAIL_ComputeFilterOffsetForEntry_Return\n"
    "_LOCAVAIL_ComputeFilterOffsetForEntry_Return:\n"
    "LOCAVAIL_ComputeFilterOffsetForEntry_Return:\n"
    "    MOVEM.L (A7)+,D4-D7/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
