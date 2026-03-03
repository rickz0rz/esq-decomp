__asm__(
    ".globl _DISPLIB_FindPreviousValidEntryIndex_Return\n"
    "_DISPLIB_FindPreviousValidEntryIndex_Return:\n"
    "DISPLIB_FindPreviousValidEntryIndex_Return:\n"
    "    MOVE.L  D7,D0\n"
    "    MOVEM.L (A7)+,D5-D7/A2-A3\n"
    "    RTS\n"
);
