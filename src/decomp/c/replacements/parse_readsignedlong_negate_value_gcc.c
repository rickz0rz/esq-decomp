__asm__(
    ".globl _PARSE_ReadSignedLong_NegateValue\n"
    "_PARSE_ReadSignedLong_NegateValue:\n"
    "PARSE_ReadSignedLong_NegateValue:\n"
    "    NEG.L   D1\n"
    "    JMP     PARSE_ReadSignedLong_StoreResult\n"
);
