__asm__(
    ".globl _ESQSHARED4_CopyLongwordBlockDbfLoop\n"
    "_ESQSHARED4_CopyLongwordBlockDbfLoop:\n"
    "ESQSHARED4_CopyLongwordBlockDbfLoop:\n"
    "    MOVE.L  (A3)+,(A4)+\n"
    "    DBF     D1,ESQSHARED4_CopyLongwordBlockDbfLoop\n"
    "    MOVEM.L (A7)+,D0-D1/A0-A4\n"
    "    RTS\n"
);
