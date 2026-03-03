__asm__(
    ".globl _ESQSHARED_UpdateMatchingEntriesByTitle_Return\n"
    "_ESQSHARED_UpdateMatchingEntriesByTitle_Return:\n"
    "ESQSHARED_UpdateMatchingEntriesByTitle_Return:\n"
    "    MOVEM.L (A7)+,D2-D7/A2-A3/A6\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
