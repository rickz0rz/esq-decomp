__asm__(
    ".globl _DISKIO1_DumpDefaultCoiInfoBlock_Return\n"
    "_DISKIO1_DumpDefaultCoiInfoBlock_Return:\n"
    "DISKIO1_DumpDefaultCoiInfoBlock_Return:\n"
    "    MOVEM.L (A7)+,D2-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
