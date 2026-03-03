__asm__(
    ".globl _ESQPARS_ReadLengthWordWithChecksumXor_Return\n"
    "_ESQPARS_ReadLengthWordWithChecksumXor_Return:\n"
    "ESQPARS_ReadLengthWordWithChecksumXor_Return:\n"
    "    MOVE.L  D7,D0\n"
    "    MOVEM.L (A7)+,D5-D7\n"
    "    RTS\n"
);
