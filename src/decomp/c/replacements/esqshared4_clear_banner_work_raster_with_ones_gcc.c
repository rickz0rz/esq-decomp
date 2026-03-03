__asm__(
    ".globl _ESQSHARED4_ClearBannerWorkRasterWithOnes\n"
    "_ESQSHARED4_ClearBannerWorkRasterWithOnes:\n"
    "ESQSHARED4_ClearBannerWorkRasterWithOnes:\n"
    "    LEA     WDISP_BannerWorkRasterPtr,A1\n"
    "    MOVEA.L (A1),A0\n"
    "    LEA     (A0),A0\n"
    "    MOVE.L  #0x149,D1\n"
    "1:\n"
    "    MOVE.L  #0xFFFFFFFF,(A0)+\n"
    "    DBF     D1,1b\n"
    "    RTS\n"
);
