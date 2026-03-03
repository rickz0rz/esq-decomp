__asm__(
    ".globl _LOCAVAIL_UpdateFilterStateMachine_Return\n"
    "_LOCAVAIL_UpdateFilterStateMachine_Return:\n"
    "LOCAVAIL_UpdateFilterStateMachine_Return:\n"
    "    MOVEM.L (A7)+,D2-D5/A2-A3\n"
    "    UNLK    A5\n"
    "    RTS\n"
);
