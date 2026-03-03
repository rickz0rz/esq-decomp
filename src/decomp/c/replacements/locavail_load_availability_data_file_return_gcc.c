__asm__(
    ".globl _LOCAVAIL_LoadAvailabilityDataFile_Return\n"
    "_LOCAVAIL_LoadAvailabilityDataFile_Return:\n"
    "LOCAVAIL_LoadAvailabilityDataFile_Return:\n"
    "    MOVE.L  D5,D0\n"
    "    MOVEM.L (A7)+,D4-D7/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
