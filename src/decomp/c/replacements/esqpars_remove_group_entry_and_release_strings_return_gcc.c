__asm__(
    ".globl _ESQPARS_RemoveGroupEntryAndReleaseStrings_Return\n"
    "_ESQPARS_RemoveGroupEntryAndReleaseStrings_Return:\n"
    "ESQPARS_RemoveGroupEntryAndReleaseStrings_Return:\n"
    "    MOVEM.L (A7)+,D5-D7/A2\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
