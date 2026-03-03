__asm__(
    ".globl _PARSE_ReadSignedLong_StoreResult\n"
    "_PARSE_ReadSignedLong_StoreResult:\n"
    "PARSE_ReadSignedLong_StoreResult:\n"
    "    MOVE.L  (A7)+,D2\n"
    "    MOVE.L  A0,D0\n"
    "    SUBQ.L  #1,D0\n"
    "    MOVEA.L 8(A7),A0\n"
    "    MOVE.L  D1,(A0)\n"
    "    SUB.L   A1,D0\n"
    "    RTS\n"
);
