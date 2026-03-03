__asm__(
    ".globl _GCOMMAND_ValidatePresetTable_Return\n"
    "_GCOMMAND_ValidatePresetTable_Return:\n"
    "GCOMMAND_ValidatePresetTable_Return:\n"
    "    MOVEM.L (A7)+,D5-D7/A3\n"
    "    RTS\n"
);
