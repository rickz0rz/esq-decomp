__asm__(
    ".globl _ESQIFF2_PadEntriesToMaxTitleWidth_Return\n"
    "_ESQIFF2_PadEntriesToMaxTitleWidth_Return:\n"
    "ESQIFF2_PadEntriesToMaxTitleWidth_Return:\n"
    "    MOVEM.L (A7)+,D4-D7\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
