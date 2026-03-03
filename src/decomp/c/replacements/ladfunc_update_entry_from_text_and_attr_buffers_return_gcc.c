__asm__(
    ".globl _LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return\n"
    "_LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return:\n"
    "LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return:\n"
    "    MOVEM.L (A7)+,D6-D7/A2-A3/A6\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
