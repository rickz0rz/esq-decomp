__asm__(
    ".globl _ESQDISP_RefreshStatusIndicatorsFromCurrentMask\n"
    "_ESQDISP_RefreshStatusIndicatorsFromCurrentMask:\n"
    "ESQDISP_RefreshStatusIndicatorsFromCurrentMask:\n"
    "    PEA     -1.W\n"
    "    BSR.W   ESQDISP_ApplyStatusMaskToIndicators\n"
    "\n"
    "    ADDQ.W  #4,A7\n"
    "    RTS\n"
);
