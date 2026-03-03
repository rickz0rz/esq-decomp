__asm__(
    ".globl _DISPLIB_ApplyInlineAlignmentPadding_Return\n"
    "_DISPLIB_ApplyInlineAlignmentPadding_Return:\n"
    "DISPLIB_ApplyInlineAlignmentPadding_Return:\n"
    "    MOVEM.L (A7)+,D4-D7/A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
