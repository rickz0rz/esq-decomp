    XDEF    _GCOMMAND_ValidatePresetTable
    XDEF    GCOMMAND_ValidatePresetTable_Return

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ValidatePresetTable   (Validate preset table and repair from defaults)
; ARGS:
;   stack +4: presetTable (base pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A1, A3, A6
; CALLS:
;   _GCOMMAND_UpdateBannerBounds, _LVODisable, _LVOEnable
; READS:
;   [presetTable], _GCOMMAND_DefaultPresetTable
; WRITES:
;   _GCOMMAND_PresetWorkResetPendingFlag, _GCOMMAND_DefaultPresetTable
; DESC:
;   Validates preset table values and, if needed, copies defaults and resets
;   associated state.
; NOTES:
;   Value ranges are inferred (1..$40 and 0..$1000 checks).
;------------------------------------------------------------------------------
_GCOMMAND_ValidatePresetTable:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEQ   #1,D5
    MOVEQ   #0,D7

.lab_0D7B:
    TST.L   D5
    BEQ.S   .lab_0D82

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   .lab_0D82

    MOVE.L  D7,D0
    ADD.L   D0,D0
    CMPI.W  #1,0(A3,D0.L)
    BLE.S   .lab_0D7C

    CMPI.W  #$40,0(A3,D0.L)
    BGT.S   .lab_0D7C

    MOVEQ   #1,D0
    BRA.S   .lab_0D7D

.lab_0D7C:
    MOVEQ   #0,D0

.lab_0D7D:
    MOVE.L  D0,D5
    MOVEQ   #0,D6

.lab_0D7E:
    TST.L   D5
    BEQ.S   .lab_0D81

    MOVE.L  D7,D0
    ADD.L   D0,D0
    MOVE.W  0(A3,D0.L),D1
    EXT.L   D1
    CMP.L   D1,D6
    BGE.S   .lab_0D81

    MOVE.L  D7,D0
    ASL.L   #7,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    MOVE.L  D6,D1
    ADD.L   D1,D1
    ADDA.L  D1,A0
    CMPI.W  #0,32(A0)
    BCS.S   .lab_0D7F

    MOVEA.L A3,A0
    ADDA.L  D0,A0
    ADDA.L  D1,A0
    CMPI.W  #$1000,32(A0)
    BCC.S   .lab_0D7F

    MOVEQ   #1,D0
    BRA.S   .lab_0D80

.lab_0D7F:
    MOVEQ   #0,D0

.lab_0D80:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   .lab_0D7E

.lab_0D81:
    ADDQ.L  #1,D7
    BRA.S   .lab_0D7B

.lab_0D82:
    TST.L   D5
    BEQ.S   GCOMMAND_ValidatePresetTable_Return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVEA.L A3,A0
    LEA     _GCOMMAND_DefaultPresetTable,A1
    MOVE.L  #$820,D0
    JSR     _LVOCopyMem(A6)

    MOVE.W  #1,_GCOMMAND_PresetWorkResetPendingFlag
    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    PEA     6.W
    PEA     5.W
    MOVE.L  D0,-(A7)
    BSR.W   _GCOMMAND_UpdateBannerBounds

    LEA     16(A7),A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ValidatePresetTable_Return   (Routine at GCOMMAND_ValidatePresetTable_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D5
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
GCOMMAND_ValidatePresetTable_Return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======