__asm__(
    ".globl _COI_FreeSubEntryTableEntries_Return\n"
    "_COI_FreeSubEntryTableEntries_Return:\n"
    "COI_FreeSubEntryTableEntries_Return:\n"
    "    MOVEM.L (A7)+,D7/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
