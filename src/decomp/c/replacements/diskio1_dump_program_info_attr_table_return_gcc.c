__asm__(
    ".globl _DISKIO1_DumpProgramInfoAttrTable_Return\n"
    "_DISKIO1_DumpProgramInfoAttrTable_Return:\n"
    "DISKIO1_DumpProgramInfoAttrTable_Return:\n"
    "    MOVEM.L -68(A5),D2-D3/D6-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
