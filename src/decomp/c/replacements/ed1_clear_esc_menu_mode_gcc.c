__asm__(
    ".globl _ED1_ClearEscMenuMode\n"
    "_ED1_ClearEscMenuMode:\n"
    "ED1_ClearEscMenuMode:\n"
    "    CLR.B   ED_MenuStateId\n"
    "    RTS\n"
);
