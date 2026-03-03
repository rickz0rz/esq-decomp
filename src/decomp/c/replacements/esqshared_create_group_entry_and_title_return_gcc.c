__asm__(
    ".globl _ESQSHARED_CreateGroupEntryAndTitle_Return\n"
    "_ESQSHARED_CreateGroupEntryAndTitle_Return:\n"
    "ESQSHARED_CreateGroupEntryAndTitle_Return:\n"
    "    MOVEM.L (A7)+,D5-D7/A2-A3/A6\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
