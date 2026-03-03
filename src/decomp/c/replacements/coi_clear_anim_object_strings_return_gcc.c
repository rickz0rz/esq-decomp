__asm__(
    ".globl _COI_ClearAnimObjectStrings_Return\n"
    "_COI_ClearAnimObjectStrings_Return:\n"
    "COI_ClearAnimObjectStrings_Return:\n"
    "    MOVEM.L (A7)+,A2-A3\n"
    "    RTS\n"
);
