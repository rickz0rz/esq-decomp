__asm__(
    ".globl _PARSE_ReadSignedLong_ParseDone\n"
    "_PARSE_ReadSignedLong_ParseDone:\n"
    "PARSE_ReadSignedLong_ParseDone:\n"
    "    CMPI.B  #'-',(A1)\n"
    "    BNE.W   PARSE_ReadSignedLong_StoreResult\n"
    "    JMP     PARSE_ReadSignedLong_NegateValue\n"
);
