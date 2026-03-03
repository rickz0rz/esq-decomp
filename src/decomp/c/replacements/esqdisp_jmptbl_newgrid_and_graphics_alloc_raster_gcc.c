__asm__(
    ".globl _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages\n"
    ".globl _ESQDISP_JMPTBL_GRAPHICS_AllocRaster\n"
    "_ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages:\n"
    "ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages:\n"
    "    JMP     NEWGRID_ProcessGridMessages\n"
    "\n"
    "_ESQDISP_JMPTBL_GRAPHICS_AllocRaster:\n"
    "ESQDISP_JMPTBL_GRAPHICS_AllocRaster:\n"
    "    JMP     GRAPHICS_AllocRaster\n"
);
