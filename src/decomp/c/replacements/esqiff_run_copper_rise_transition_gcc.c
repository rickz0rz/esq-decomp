__asm__(
    ".globl _ESQIFF_RunCopperRiseTransition\n"
    "_ESQIFF_RunCopperRiseTransition:\n"
    "ESQIFF_RunCopperRiseTransition:\n"
    "    MOVE.W  #15,COPPER_AnimationLane3_Countdown\n"
    "    BSR.W   ESQIFF_RunPendingCopperAnimations\n"
    "\n"
    "    RTS\n"
);
