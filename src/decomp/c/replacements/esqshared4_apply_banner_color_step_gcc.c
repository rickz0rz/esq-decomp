__asm__(
    ".globl _ESQSHARED4_ApplyBannerColorStep\n"
    "_ESQSHARED4_ApplyBannerColorStep:\n"
    "ESQSHARED4_ApplyBannerColorStep:\n"
    "    BSR.W   ESQSHARED4_SetBannerCopperColorAndThreshold\n"
    "    MOVE.W  #$58,D1\n"
    "    JSR     ESQSHARED4_BindAndClearBannerWorkRaster\n"
    "    RTS\n"
);
