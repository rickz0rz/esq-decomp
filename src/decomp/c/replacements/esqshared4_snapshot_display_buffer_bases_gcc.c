__asm__(
    ".globl _ESQSHARED4_SnapshotDisplayBufferBases\n"
    "_ESQSHARED4_SnapshotDisplayBufferBases:\n"
    "ESQSHARED4_SnapshotDisplayBufferBases:\n"
    "    MOVE.L  A1,-(A7)\n"
    "    LEA     ESQSHARED_LivePlaneBase0,A1\n"
    "    MOVE.L  (A1),ESQPARS2_SnapshotLivePlane0Base\n"
    "    LEA     ESQSHARED_LivePlaneBase1,A1\n"
    "    MOVE.L  (A1),ESQPARS2_SnapshotLivePlane1Base\n"
    "    LEA     ESQSHARED_LivePlaneBase2,A1\n"
    "    MOVE.L  (A1),ESQPARS2_SnapshotLivePlane2Base\n"
    "    MOVEA.L (A7)+,A1\n"
    "    RTS\n"
);
