__asm__(
    ".globl _ESQSHARED4_ResetBannerColorToStart\n"
    "_ESQSHARED4_ResetBannerColorToStart:\n"
    "ESQSHARED4_ResetBannerColorToStart:\n"
    "    LEA     ESQ_CopperListBannerA,A4\n"
    "    MOVE.W  #0x62,ESQPARS2_BannerColorStepCounter\n"
    "    MOVE.W  #0x19,D0\n"
    "    JMP     ESQSHARED4_ApplyBannerColorStep\n"
);
