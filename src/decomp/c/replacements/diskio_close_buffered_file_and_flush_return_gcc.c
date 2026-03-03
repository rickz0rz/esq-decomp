__asm__(
    ".globl _DISKIO_CloseBufferedFileAndFlush_Return\n"
    "_DISKIO_CloseBufferedFileAndFlush_Return:\n"
    "DISKIO_CloseBufferedFileAndFlush_Return:\n"
    "    MOVEM.L (A7)+,D2-D3/D6-D7\n"
    "    RTS\n"
);
