__asm__(
    ".globl _GCOMMAND_AddBannerTableByteDelta\n"
    "_GCOMMAND_AddBannerTableByteDelta:\n"
    "GCOMMAND_AddBannerTableByteDelta:\n"
    "    MOVEM.L D7/A3,-(A7)\n"
    "    MOVEA.L 12(A7),A3\n"
    "    MOVE.B  19(A7),D7\n"
    "    ADD.B   D7,(A3)\n"
    "    MOVEM.L (A7)+,D7/A3\n"
    "    RTS\n"
);
