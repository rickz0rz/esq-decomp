__asm__(
    ".globl _LADFUNC_RepackEntryTextAndAttrBuffers_Return\n"
    "_LADFUNC_RepackEntryTextAndAttrBuffers_Return:\n"
    "LADFUNC_RepackEntryTextAndAttrBuffers_Return:\n"
    "    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
