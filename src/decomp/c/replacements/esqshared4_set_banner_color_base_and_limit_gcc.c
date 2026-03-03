__asm__(
    ".globl _ESQSHARED4_SetBannerColorBaseAndLimit\n"
    "_ESQSHARED4_SetBannerColorBaseAndLimit:\n"
    "ESQSHARED4_SetBannerColorBaseAndLimit:\n"
    "    MOVE.W  D0,ESQPARS2_BannerColorBaseValue\n"
    "    MOVE.W  #0xD9,D1\n"
    "    MOVE.B  D0,ESQ_BannerColorClampValueA\n"
    "    MOVE.B  D0,ESQ_BannerColorClampValueB\n"
    "    MOVE.B  D1,ESQ_BannerColorClampWaitRowA\n"
    "    MOVE.B  D1,ESQ_BannerColorClampWaitRowB\n"
    "    RTS\n"
);
