__asm__(
    ".globl _LOCAVAIL_SaveAvailabilityDataFile_Return\n"
    "_LOCAVAIL_SaveAvailabilityDataFile_Return:\n"
    "LOCAVAIL_SaveAvailabilityDataFile_Return:\n"
    "    MOVE.L  D5,D0\n"
    "    MOVEM.L (A7)+,D4-D7/A2-A3/A6\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
