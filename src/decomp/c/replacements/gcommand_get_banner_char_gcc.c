__asm__(
    ".globl _GCOMMAND_GetBannerChar\n"
    "_GCOMMAND_GetBannerChar:\n"
    "GCOMMAND_GetBannerChar:\n"
    "    LINK.W  A5,#-4\n"
    "    MOVE.L  #ESQ_CopperListBannerA,-4(A5)\n"
    "    MOVEQ   #0,D0\n"
    "    MOVEA.L -4(A5),A0\n"
    "    MOVE.B  (A0),D0\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
