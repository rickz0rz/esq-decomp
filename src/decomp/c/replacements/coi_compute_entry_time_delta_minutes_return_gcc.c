__asm__(
    ".globl _COI_ComputeEntryTimeDeltaMinutes_Return\n"
    "_COI_ComputeEntryTimeDeltaMinutes_Return:\n"
    "COI_ComputeEntryTimeDeltaMinutes_Return:\n"
    "    MOVE.L  D5,D0\n"
    "    MOVEM.L (A7)+,D5-D7/A3\n"
    "    RTS\n"
);
