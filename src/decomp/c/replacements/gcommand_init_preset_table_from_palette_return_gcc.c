__asm__(
    ".globl _GCOMMAND_InitPresetTableFromPalette_Return\n"
    "_GCOMMAND_InitPresetTableFromPalette_Return:\n"
    "GCOMMAND_InitPresetTableFromPalette_Return:\n"
    "    MOVEM.L (A7)+,D6-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
