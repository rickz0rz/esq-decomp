__asm__(
    ".globl _ESQIFF_PlayNextExternalAssetFrame_Return\n"
    "_ESQIFF_PlayNextExternalAssetFrame_Return:\n"
    "ESQIFF_PlayNextExternalAssetFrame_Return:\n"
    "    MOVEM.L (A7)+,D6-D7\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
