__asm__(
    ".globl _ESQIFF2_ShowVersionMismatchOverlay_Return\n"
    "_ESQIFF2_ShowVersionMismatchOverlay_Return:\n"
    "ESQIFF2_ShowVersionMismatchOverlay_Return:\n"
    "    MOVEM.L (A7)+,D2-D3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
