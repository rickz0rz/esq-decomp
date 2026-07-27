    XDEF    _GCOMMAND_InitPresetWorkEntry

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_InitPresetWorkEntry   (Initialize one preset work-entry state block)
; ARGS:
;   stack +4: entryPtr (work entry)
;   stack +8: presetIndex
;   stack +12: span
;   stack +16: baseValue
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0, A3
; CALLS:
;   GCOMMAND_SetPresetEntry
; READS:
;   _GCOMMAND_DefaultPresetTable
; WRITES:
;   [entryPtr]
; DESC:
;   Initializes a preset work entry based on index/span parameters.
; NOTES:
;   If index is invalid, forces entry index to 6 and updates the preset table.
;------------------------------------------------------------------------------
_GCOMMAND_InitPresetWorkEntry:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    TST.L   D7
    BMI.S   .invalid_index

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   .invalid_index

    MOVE.L  D7,(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,16(A3)
    MOVEQ   #4,D1
    CMP.L   D1,D6
    BLE.S   .span_small

    MOVE.L  D5,12(A3)
    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     _GCOMMAND_DefaultPresetTable,A0
    ADDA.L  D1,A0
    MOVE.W  (A0),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVE.L  D1,4(A3)
    MOVEQ   #2,D1
    MOVE.L  D1,20(A3)
    MOVEQ   #1,D1
    MOVE.L  D1,8(A3)
    BRA.S   .done

.span_small:
    TST.L   D6
    BMI.S   .done

    MOVE.L  D0,12(A3)
    MOVE.L  D0,4(A3)
    MOVE.L  D0,20(A3)
    MOVE.L  D0,8(A3)
    BRA.S   .done

.invalid_index:
    MOVEQ   #6,D0
    MOVE.L  D0,(A3)
    MOVEQ   #0,D1
    MOVE.L  D1,16(A3)
    MOVE.L  D1,12(A3)
    MOVE.L  D1,4(A3)
    MOVE.L  D1,20(A3)
    MOVE.L  D1,8(A3)
    PEA     1365.W
    MOVE.L  D0,-(A7)
    BSR.W   GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======