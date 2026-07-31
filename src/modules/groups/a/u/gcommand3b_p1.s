    XDEF    _GCOMMAND_UpdatePresetEntryCache
    XDEF    GCOMMAND_UpdatePresetEntryCache_Return


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_UpdatePresetEntryCache   (Populate cached preset deltas for one preset record)
; ARGS:
;   stack +4: presetRecord (struct pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   _GCOMMAND_ComputePresetIncrement
; READS:
;   32(A3), 36(A3), 55(A3)
; WRITES:
;   36(A3)..
; DESC:
;   Computes four cached values from presetRecord fields via _GCOMMAND_ComputePresetIncrement.
; NOTES:
;   Field layout is inferred; cache is written starting at offset 36.
;------------------------------------------------------------------------------
_GCOMMAND_UpdatePresetEntryCache:
    LINK.W  A5,#-16
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  32(A3),D6
    TST.L   D6
    BMI.S   GCOMMAND_UpdatePresetEntryCache_Return

    MOVEQ   #0,D7
    LEA     36(A3),A0
    LEA     55(A3),A1
    MOVE.L  A0,-8(A5)
    MOVE.L  A1,-16(A5)

.lab_0D8F:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   GCOMMAND_UpdatePresetEntryCache_Return

    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    ADDQ.L  #4,-8(A5)
    ADDQ.L  #1,-16(A5)
    BRA.S   .lab_0D8F

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdatePresetEntryCache_Return   (Routine at GCOMMAND_UpdatePresetEntryCache_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
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
GCOMMAND_UpdatePresetEntryCache_Return:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======