__asm__(
    ".globl _LOCAVAIL2_AutoRequestNoOp\n"
    "_LOCAVAIL2_AutoRequestNoOp:\n"
    "LOCAVAIL2_AutoRequestNoOp:\n"
    "    MOVE.L  A4,-(A7)\n"
    "    LEA     Global_REF_LONG_FILE_SCRATCH,A4\n"
    "    MOVEQ   #0,D0\n"
    "    MOVEA.L (A7)+,A4\n"
    "    RTS\n"
);
