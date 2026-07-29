    XDEF    _GCOMMAND_ApplyHighlightFlag

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ApplyHighlightFlag   (Update all banner layout rows to reflect the current highlight flag.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D1/D7
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_HighlightFlag, _ESQ_CopperEffectTemplateRowsSet0, _ESQ_CopperListBannerA, _ESQ_CopperEffectTemplateRowsSet1, _ESQ_CopperListBannerB
; WRITES:
;   (none observed)
; DESC:
;   Update all banner layout rows to reflect the current highlight flag.
; NOTES:
;   Chooses value 2 when highlight is on, otherwise 0, and writes it into both
;   banner table row records.
;------------------------------------------------------------------------------

; Update all banner layout rows to reflect the current highlight flag.
_GCOMMAND_ApplyHighlightFlag:
    LINK.W  A5,#-12
    MOVE.L  D7,-(A7)
    TST.W   _GCOMMAND_HighlightFlag
    BEQ.S   .lab_0D6B

    MOVEQ   #2,D0
    BRA.S   .lab_0D6C

.lab_0D6B:
    MOVEQ   #0,D0

.lab_0D6C:
    MOVE.L  D0,D7
    MOVE.L  #_ESQ_CopperEffectTemplateRowsSet0,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #_ESQ_CopperEffectTemplateRowsSet1,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #_ESQ_CopperListBannerA,-8(A5)
    MOVEQ   #-3,D0
    MOVEA.L -8(A5),A0
    AND.W   30(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,30(A0)
    MOVEQ   #-3,D1
    AND.W   114(A0),D1
    OR.W    D7,D1
    MOVE.W  D1,114(A0)
    MOVEQ   #-3,D0
    AND.W   678(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,678(A0)
    MOVEQ   #-3,D1
    AND.W   726(A0),D1
    OR.W    D7,D1
    MOVE.W  D1,726(A0)
    MOVEQ   #-3,D0
    AND.W   3922(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,3922(A0)
    MOVE.L  #_ESQ_CopperListBannerB,-8(A5)
    MOVEQ   #-3,D0
    MOVEA.L -8(A5),A0
    AND.W   30(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,30(A0)
    MOVEQ   #-3,D0
    AND.W   114(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,114(A0)
    MOVEQ   #-3,D0
    AND.W   678(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,678(A0)
    MOVEQ   #-3,D0
    AND.W   726(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,726(A0)
    MOVEQ   #-3,D0
    AND.W   3922(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,3922(A0)
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
