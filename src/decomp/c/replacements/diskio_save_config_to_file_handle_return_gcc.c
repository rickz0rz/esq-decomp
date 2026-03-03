__asm__(
    ".globl _DISKIO_SaveConfigToFileHandle_Return\n"
    "_DISKIO_SaveConfigToFileHandle_Return:\n"
    "DISKIO_SaveConfigToFileHandle_Return:\n"
    "    MOVEM.L -236(A5),D2-D7\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
