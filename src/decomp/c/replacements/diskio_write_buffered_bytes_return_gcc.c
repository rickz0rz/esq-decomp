__asm__(
    ".globl _DISKIO_WriteBufferedBytes_Return\n"
    "_DISKIO_WriteBufferedBytes_Return:\n"
    "DISKIO_WriteBufferedBytes_Return:\n"
    "    MOVEM.L (A7)+,D2-D7/A3\n"
    "    RTS\n"
);
