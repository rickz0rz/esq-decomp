__asm__(
    ".globl _GCOMMAND_ExpandPresetBlock_Return\n"
    "_GCOMMAND_ExpandPresetBlock_Return:\n"
    "GCOMMAND_ExpandPresetBlock_Return:\n"
    "    MOVEM.L (A7)+,D2/D5-D7/A3\n"
    "    RTS\n"
);
