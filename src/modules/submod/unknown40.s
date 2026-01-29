GET_CLOCK_CHIP_TIME:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_BATTCLOCK_RESOURCE,A6
    JSR     _LVOReadBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

SET_CLOCK_CHIP_TIME:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_BATTCLOCK_RESOURCE,A6
    MOVE.L  8(A7),D0
    JSR     _LVOWriteBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

LAB_1ADD:
    MOVEM.L A2/A6,-(A7)

    MOVEA.L LAB_231E,A6
    MOVEM.L 12(A7),A0-A1
    MOVEM.L 20(A7),D1/A2
    JSR     -48(A6)         ; Traced A6 to be AbsExecBase here? _LVOexecPrivate3

    MOVEM.L (A7)+,A2/A6
    RTS

;!======

DO_DELAY:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    MOVE.L  8(A7),D1
    JSR     _LVODelay(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

LAB_1ADF:
    MOVEM.L D2/A6,-(A7)

    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    MOVEM.L 12(A7),D1-D2
    JSR     _LVOSystemTagList(A6)

    MOVEM.L (A7)+,D2/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
