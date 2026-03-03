__asm__(
    ".globl _DISKIO_ForceUiRefreshIfIdle\n"
    "_DISKIO_ForceUiRefreshIfIdle:\n"
    "DISKIO_ForceUiRefreshIfIdle:\n"
    "    TST.W   Global_UIBusyFlag\n"
    "    BNE.S   1f\n"
    "    MOVE.W  #$100,ESQPARS2_ReadModeFlags\n"
    "    MOVE.W  #(-1),Global_RefreshTickCounter\n"
    "    JSR     GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh\n"
    "1:\n"
    "    RTS\n"
);
