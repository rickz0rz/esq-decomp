__asm__(
    ".globl _GCOMMAND_InitPresetDefaults\n"
    "_GCOMMAND_InitPresetDefaults:\n"
    "GCOMMAND_InitPresetDefaults:\n"
    "    PEA     GCOMMAND_DefaultPresetTable\n"
    "    JSR     GCOMMAND_InitPresetTableFromPalette\n"
    "    ADDQ.W  #4,A7\n"
    "    RTS\n"
);
