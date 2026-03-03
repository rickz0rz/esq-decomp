__asm__(
    ".globl _ESQIFF2_ReadSerialSizedTextRecord_Return\n"
    "_ESQIFF2_ReadSerialSizedTextRecord_Return:\n"
    "ESQIFF2_ReadSerialSizedTextRecord_Return:\n"
    "    MOVEM.L (A7)+,D4-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
