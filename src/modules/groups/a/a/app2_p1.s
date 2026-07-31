    XDEF    _ESQ_UpdateCopperListsFromParams


;------------------------------------------------------------------------------
; FUNC: _ESQ_UpdateCopperListsFromParams   (UpdateCopperListsFromParams)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D4, A0-A1, A6
; CALLS:
;   (none)
; READS:
;   _HIGHLIGHT_CopperEffectSeed, _HIGHLIGHT_CopperEffectParamA, _HIGHLIGHT_CopperEffectParamB, _ESQ_CopperEffectTemplateRowsSet0
; WRITES:
;   _ESQ_CopperEffectListA, _ESQ_CopperEffectListB
; DESC:
;   Expands packed effect parameters into copper list words for two tables.
; NOTES:
;   Writes 16 entries (DBF runs D4+1 iterations). Exact effect semantics unknown.
;------------------------------------------------------------------------------
_ESQ_UpdateCopperListsFromParams:
    LEA     _ESQ_CopperEffectTemplateRowsSet0,A0
    MOVE.W  26(A0),D1
    MOVE.L  _HIGHLIGHT_CopperEffectSeed,D0
    LEA     _ESQ_CopperEffectListA,A0
    LEA     _ESQ_CopperEffectListB,A1
    ADDQ.L  #6,A0
    ADDQ.L  #6,A1
    ADD.B   D0,D0
    ADD.B   D0,D0
    ADD.W   D0,D0
    ADD.W   D0,D0
    SWAP    D0
    TST.B   D0
    BNE.S   .normalize_seed

    MOVEQ   #0,D0

.normalize_seed:
    ROL.L   #5,D0
    MOVEM.L D2-D4/A6,-(A7)
    MOVEA.W #$100,A6
    MOVE.W  D1,D3
    BCLR    #8,D3
    MOVEQ   #15,D4

.write_copper_loop:
    MOVE.W  A6,D2
    AND.W   D0,D2
    OR.W    D3,D2
    MOVE.W  D2,(A0)
    MOVE.W  D2,(A1)
    MOVE.W  D2,4(A0)
    MOVE.W  D2,4(A1)
    MOVE.W  D2,136(A0)
    MOVE.W  D2,136(A1)
    MOVE.W  D2,140(A0)
    MOVE.W  D2,140(A1)
    ADDQ.L  #8,A0
    ADDQ.L  #8,A1
    ROL.L   #1,D0
    DBF     D4,.write_copper_loop

    MOVE.W  D1,(A0)
    MOVE.W  D1,(A1)
    MOVE.W  D1,136(A0)
    MOVE.W  D1,136(A1)
    MOVEM.L (A7)+,D2-D4/A6
    MOVEQ   #0,D0
    RTS

;!======