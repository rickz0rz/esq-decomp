;------------------------------------------------------------------------------
; FUNC: BATTCLOCK_GetSecondsFromBatteryBackedClock   (Read seconds from the battery-backed clock.)
; ARGS:
;   none
; RET:
;   D0: seconds since Amiga epoch
; CLOBBERS:
;   D0/A6
; CALLS:
;   _LVOReadBattClock
;------------------------------------------------------------------------------
BATTCLOCK_GetSecondsFromBatteryBackedClock:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_BATTCLOCK_RESOURCE,A6
    JSR     _LVOReadBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: BATTCLOCK_WriteSecondsToBatteryBackedClock   (Write seconds to the battery-backed clock.)
; ARGS:
;   stack +8: D0 = seconds since Amiga epoch
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A6
; CALLS:
;   _LVOWriteBattClock
;------------------------------------------------------------------------------
BATTCLOCK_WriteSecondsToBatteryBackedClock:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_BATTCLOCK_RESOURCE,A6
    MOVE.L  8(A7),D0
    JSR     _LVOWriteBattClock(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: EXEC_CallVector_48   (Exec.library call wrapper at LVO -48.)
; ARGS:
;   stack +12: A0-A1 = ??
;   stack +20: D1/A2 = ??
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0-A2/A6
; DESC:
;   Dispatches to LVO -48 using LAB_231E as library base.
; NOTES:
;   Vector identity unknown; verify against call sites.
;------------------------------------------------------------------------------
EXEC_CallVector_48:
    MOVEM.L A2/A6,-(A7)

    MOVEA.L LAB_231E,A6
    MOVEM.L 12(A7),A0-A1
    MOVEM.L 20(A7),D1/A2
    JSR     -48(A6)         ; Traced A6 to be AbsExecBase here? _LVOexecPrivate3

    MOVEM.L (A7)+,A2/A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DOS_Delay   (Delay for D1 ticks.)
; ARGS:
;   stack +8: D1 = ticks
; RET:
;   D0: ??
; CLOBBERS:
;   D1/A6
; CALLS:
;   _LVODelay
;------------------------------------------------------------------------------
DOS_Delay:
    MOVE.L  A6,-(A7)

    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    MOVE.L  8(A7),D1
    JSR     _LVODelay(A6)

    MOVEA.L (A7)+,A6
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: DOS_SystemTagList   (Call DOS SystemTagList.)
; ARGS:
;   stack +12: D1-D2 = ??
; RET:
;   D0: status
; CLOBBERS:
;   D0-D2/A6
; CALLS:
;   _LVOSystemTagList
;------------------------------------------------------------------------------
DOS_SystemTagList:
    MOVEM.L D2/A6,-(A7)

    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    MOVEM.L 12(A7),D1-D2
    JSR     _LVOSystemTagList(A6)

    MOVEM.L (A7)+,D2/A6
    RTS

;!======

    ; Alignment
    ALIGN_WORD
