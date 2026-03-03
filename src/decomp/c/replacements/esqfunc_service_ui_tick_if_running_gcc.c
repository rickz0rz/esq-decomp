__asm__(
    ".globl _ESQFUNC_ServiceUiTickIfRunning\n"
    "_ESQFUNC_ServiceUiTickIfRunning:\n"
    "ESQFUNC_ServiceUiTickIfRunning:\n"
    "    TST.W   ESQ_MainLoopUiTickEnabledFlag\n"
    "    BEQ.S   .return\n"
    "\n"
    "    BSR.W   ESQFUNC_ProcessUiFrameTick\n"
    "\n"
    ".return:\n"
    "    RTS\n"
);
