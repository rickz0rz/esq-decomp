    XDEF    _COI_ComputeEntryTimeDeltaMinutes
    XDEF    COI_ComputeEntryTimeDeltaMinutes_Return



;------------------------------------------------------------------------------
; FUNC: _COI_ComputeEntryTimeDeltaMinutes   (Routine at _COI_ComputeEntryTimeDeltaMinutes)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D5/D6/D7
; CALLS:
;   _GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset, _GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex
; READS:
;   COI_ComputeEntryTimeDeltaMinutes_Return, _TEXTDISP_PrimaryGroupCode, _CLOCK_HalfHourSlotIndex
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_COI_ComputeEntryTimeDeltaMinutes:
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVEA.L,1,A3
    UseStackWord    MOVE.W,5,D7

    MOVEQ   #49,D6
    MOVEQ   #-1,D5
    TST.W   D7
    BLE.W   COI_ComputeEntryTimeDeltaMinutes_Return

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   COI_ComputeEntryTimeDeltaMinutes_Return

    MOVE.L  D7,D6
    ADDQ.W  #1,D6

.lab_0365:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   .lab_0366

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BNE.S   .lab_0366

    ADDQ.W  #1,D6
    BRA.S   .lab_0365

.lab_0366:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .lab_0369

    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVE.B  498(A3),D1
    CMP.B   D0,D1
    BNE.S   .lab_0369

    MOVE.L  A3,-(A7)
    JSR     _GROUP_AE_JMPTBL_TLIBA_FindFirstWildcardMatchIndex(PC)

    MOVE.L  D0,D6
    MOVE.L  D6,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     12(A7),A7
    MOVEA.L D0,A3
    MOVE.L  A3,D0
    BEQ.S   .lab_0368

    MOVEQ   #1,D6

.lab_0367:
    MOVEQ   #49,D0
    CMP.W   D0,D6
    BGE.S   .lab_0369

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A3,D0.L)
    BNE.S   .lab_0369

    ADDQ.W  #1,D6
    BRA.S   .lab_0367

.lab_0368:
    MOVEQ   #49,D6

.lab_0369:
    MOVEQ   #48,D0
    CMP.W   D0,D6
    BLE.S   .lab_036A

    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MULU    #30,D0
    MOVE.L  #2880,D1
    SUB.L   D0,D1
    MOVE.L  D1,D5
    BRA.S   COI_ComputeEntryTimeDeltaMinutes_Return

.lab_036A:
    MOVEQ   #0,D0
    MOVE.B  498(A3),D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_TEXTDISP_ComputeTimeOffset(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

;------------------------------------------------------------------------------
; FUNC: COI_ComputeEntryTimeDeltaMinutes_Return   (Routine at COI_ComputeEntryTimeDeltaMinutes_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_ComputeEntryTimeDeltaMinutes_Return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======