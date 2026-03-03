__asm__(
    ".globl _FORMAT_Buffer2WriteChar\n"
    "_FORMAT_Buffer2WriteChar:\n"
    "FORMAT_Buffer2WriteChar:\n"
    "    MOVE.L  D7,-(A7)\n"
    "    MOVE.L  8(A7),D7\n"
    "    ADDQ.L  #1,Global_FormatByteCount2(A4)\n"
    "    MOVE.L  D7,D0\n"
    "    MOVEA.L Global_FormatBufferPtr2(A4),A0\n"
    "    MOVE.B  D0,(A0)+\n"
    "    MOVE.L  A0,Global_FormatBufferPtr2(A4)\n"
    "    MOVE.L  (A7)+,D7\n"
    "    RTS\n"
);
