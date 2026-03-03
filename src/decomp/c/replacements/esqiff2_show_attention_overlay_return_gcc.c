__asm__(
    ".globl _ESQIFF2_ShowAttentionOverlay_Return\n"
    "_ESQIFF2_ShowAttentionOverlay_Return:\n"
    "ESQIFF2_ShowAttentionOverlay_Return:\n"
    "    MOVEM.L (A7)+,D2-D3/D5-D7\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
