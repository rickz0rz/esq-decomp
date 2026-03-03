__asm__(
    ".globl _ESQIFF2_ApplyIncomingStatusPacket_Return\n"
    "_ESQIFF2_ApplyIncomingStatusPacket_Return:\n"
    "ESQIFF2_ApplyIncomingStatusPacket_Return:\n"
    "    MOVE.W  #1,ESQIFF_StatusPacketReadyFlag\n"
    "    MOVEM.L (A7)+,D2/D6-D7/A3\n"
    "    RTS\n"
);
