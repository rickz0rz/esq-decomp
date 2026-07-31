    XDEF    _GCOMMAND_ExpandPresetBlock
    XDEF    GCOMMAND_ExpandPresetBlock_Return

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ExpandPresetBlock   (Decode a nibble-packed preset block into the preset table via _GCOMMAND_SetPresetEntry.)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Decode a nibble-packed preset block into the preset table via _GCOMMAND_SetPresetEntry.
; NOTES:
;   Treats high/low nibbles as decimal digits per byte to build row values.
;------------------------------------------------------------------------------
_GCOMMAND_ExpandPresetBlock:
    MOVEM.L D2/D5-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #4,D7

.lab_0D76:
    MOVEQ   #8,D0
    CMP.L   D0,D7
    BGE.S   GCOMMAND_ExpandPresetBlock_Return

    MOVEQ   #0,D5
    MOVEQ   #0,D6

.lab_0D77:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.S   .lab_0D78

    MOVE.L  D7,D1
    LSL.L   #2,D1
    SUB.L   D7,D1
    ADD.L   D6,D1
    MOVEQ   #2,D0
    SUB.L   D6,D0
    ASL.L   #2,D0
    MOVEQ   #0,D2
    MOVE.B  0(A3,D1.L),D2
    ASL.L   D0,D2
    MOVEQ   #15,D1
    ASL.L   D0,D1
    AND.L   D1,D2
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    ADD.L   D2,D0
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   .lab_0D77

.lab_0D78:
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   _GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7
    ADDQ.L  #1,D7
    BRA.S   .lab_0D76

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ExpandPresetBlock_Return   (Routine at GCOMMAND_ExpandPresetBlock_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
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
GCOMMAND_ExpandPresetBlock_Return:
    MOVEM.L (A7)+,D2/D5-D7/A3
    RTS

;!======