__asm__(
    ".globl _GCOMMAND_EnableHighlight\n"
    "_GCOMMAND_EnableHighlight:\n"
    "GCOMMAND_EnableHighlight:\n"
    "    MOVE.W  #1,GCOMMAND_HighlightFlag\n"
    "    JSR     GCOMMAND_ApplyHighlightFlag\n"
    "    RTS\n"
);
