__asm__(
    ".globl _GCOMMAND_SetPresetEntry_Return\n"
    "_GCOMMAND_SetPresetEntry_Return:\n"
    "GCOMMAND_SetPresetEntry_Return:\n"
    "    MOVEM.L (A7)+,D6-D7\n"
    "    RTS\n"
);
