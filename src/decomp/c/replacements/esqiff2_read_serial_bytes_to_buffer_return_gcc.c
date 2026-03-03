__asm__(
    ".globl _ESQIFF2_ReadSerialBytesToBuffer_Return\n"
    "_ESQIFF2_ReadSerialBytesToBuffer_Return:\n"
    "ESQIFF2_ReadSerialBytesToBuffer_Return:\n"
    "    MOVE.L  A3,D0\n"
    "    MOVEM.L (A7)+,D6-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
