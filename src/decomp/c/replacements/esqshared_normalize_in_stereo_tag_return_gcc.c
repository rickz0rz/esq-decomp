__asm__(
    ".globl _ESQSHARED_NormalizeInStereoTag_Return\n"
    "_ESQSHARED_NormalizeInStereoTag_Return:\n"
    "ESQSHARED_NormalizeInStereoTag_Return:\n"
    "    MOVEM.L (A7)+,D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
