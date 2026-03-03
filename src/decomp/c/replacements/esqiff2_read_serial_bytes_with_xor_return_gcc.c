__asm__(
    ".globl _ESQIFF2_ReadSerialBytesWithXor_Return\n"
    "_ESQIFF2_ReadSerialBytesWithXor_Return:\n"
    "ESQIFF2_ReadSerialBytesWithXor_Return:\n"
    "    MOVE.L  A3,D0\n"
    "    MOVEM.L (A7)+,D6-D7/A2-A3\n"
    "    RTS\n"
);
