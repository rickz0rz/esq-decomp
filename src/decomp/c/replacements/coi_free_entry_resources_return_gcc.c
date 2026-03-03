__asm__(
    ".globl _COI_FreeEntryResources_Return\n"
    "_COI_FreeEntryResources_Return:\n"
    "COI_FreeEntryResources_Return:\n"
    "    MOVEM.L (A7)+,A2-A3\n"
    "    RTS\n"
);
