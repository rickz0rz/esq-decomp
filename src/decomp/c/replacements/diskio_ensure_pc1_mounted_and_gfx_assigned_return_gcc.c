__asm__(
    ".globl _DISKIO_EnsurePc1MountedAndGfxAssigned_Return\n"
    "_DISKIO_EnsurePc1MountedAndGfxAssigned_Return:\n"
    "DISKIO_EnsurePc1MountedAndGfxAssigned_Return:\n"
    "    MOVEM.L (A7)+,D2-D3\n"
    "    RTS\n"
);
