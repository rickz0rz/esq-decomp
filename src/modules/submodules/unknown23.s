;------------------------------------------------------------------------------
; FUNC: HANDLE_GetEntryByIndex   (Validate handle index and return entry pointer.)
; ARGS:
;   stack +8: D7 = handle index
; RET:
;   D0: pointer to handle entry, or 0 on error
; CLOBBERS:
;   D0/A0
; READS:
;   Global_HandleTableCount, Global_HandleTableBase
; WRITES:
;   Global_DosIoErr (cleared), Global_AppErrorCode (set to 9 on invalid)
; DESC:
;   Bounds-checks the handle index and ensures entry is non-null.
;------------------------------------------------------------------------------
HANDLE_GetEntryByIndex:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    MOVEQ   #0,D0
    MOVE.L  D0,Global_DosIoErr(A4)
    TST.L   D7
    BMI.S   .invalid_index

    CMP.L   Global_HandleTableCount(A4),D7
    BGE.S   .invalid_index

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    TST.L   Struct_HandleEntry__Flags(A0,D0.L)
    BEQ.S   .invalid_index

    MOVE.L  D7,D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    ADDA.L  D0,A0
    MOVE.L  A0,D0
    BRA.S   .return

.invalid_index:
    MOVEQ   #9,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #0,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
