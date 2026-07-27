    XDEF    _GCOMMAND_ComputePresetIncrement

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ComputePresetIncrement   (Compute per-tick preset delta from span and index)
; ARGS:
;   stack +4: presetIndex (0..15)
;   stack +8: span (value > 4 to enable scaling)
; RET:
;   D0: scaled increment (0 when out of range)
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID_JMPTBL_MATH_Mulu32, NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   _GCOMMAND_DefaultPresetTable
; WRITES:
;   (none)
; DESC:
;   Computes a scaled increment based on a preset table entry and span.
; NOTES:
;   Returns 0 when presetIndex is out of range or span <= 4.
;------------------------------------------------------------------------------
_GCOMMAND_ComputePresetIncrement:
    LINK.W  A5,#-12
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D0
    MOVE.L  D0,-12(A5)
    TST.L   D7
    BMI.S   .return

    MOVEQ   #16,D1
    CMP.L   D1,D7
    BGE.S   .return

    MOVEQ   #4,D1
    CMP.L   D1,D6
    BLE.S   .return

    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     _GCOMMAND_DefaultPresetTable,A0
    ADDA.L  D1,A0
    MOVE.W  (A0),D1
    EXT.L   D1
    MOVE.L  D1,D5
    SUBQ.L  #1,D5
    MOVE.L  D6,D4
    SUBQ.L  #5,D4
    BLE.S   .set_zero

    MOVE.L  D5,D0
    MOVE.L  #1000,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D4,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    BRA.S   .store_result

.set_zero:
    MOVEQ   #0,D0

.store_result:
    MOVE.L  D0,-12(A5)

.return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======