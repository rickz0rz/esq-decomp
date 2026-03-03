__asm__(
    ".globl _COI_GetAnimFieldPointerByMode_Return\n"
    "_COI_GetAnimFieldPointerByMode_Return:\n"
    "COI_GetAnimFieldPointerByMode_Return:\n"
    "    MOVEM.L (A7)+,D4-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
