__asm__(
    ".globl _FLIB_AppendClockStampedLogEntry_Return\n"
    "_FLIB_AppendClockStampedLogEntry_Return:\n"
    "FLIB_AppendClockStampedLogEntry_Return:\n"
    "    MOVEM.L -140(A5),D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
