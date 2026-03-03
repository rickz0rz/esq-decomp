__asm__(
    ".globl _ESQIFF_RunCopperDropTransition\n"
    "_ESQIFF_RunCopperDropTransition:\n"
    "ESQIFF_RunCopperDropTransition:\n"
    "    MOVE.W  #15,COPPER_AnimationLane2_Countdown\n"
    "    BSR.W   ESQIFF_RunPendingCopperAnimations\n"
    "\n"
    "    RTS\n"
);
