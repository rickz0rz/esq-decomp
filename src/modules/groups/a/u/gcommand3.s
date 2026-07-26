    XDEF    _GCOMMAND_ApplyHighlightFlag
    XDEF    GCOMMAND_MapKeycodeToPreset


;!======
; The content above or below belongs in its own file... need to determine which
;!======

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_MapKeycodeToPreset   (Interpret a keyboard scan code and map it to a preset palette index.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D6/D7
; CALLS:
;   GCOMMAND_GetBannerChar
; READS:
;   CONFIG_BannerCopperHeadByte, CONFIG_RefreshIntervalSeconds, ESQPARS2_BannerQueueBuffer, GCOMMAND_BannerQueueSlotPrevious
; WRITES:
;   (none observed)
; DESC:
;   Interpret a keyboard scan code and map it to a preset palette index.
; NOTES:
;   Uses bit masks `$30/$20/$40` on keycode byte and enqueues into
;   `ESQPARS2_BannerQueueBuffer` at `GCOMMAND_BannerQueueSlotPrevious`.
;------------------------------------------------------------------------------

; Interpret a keyboard scan code and map it to a preset palette index.
GCOMMAND_MapKeycodeToPreset:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVEQ   #0,D6
    MOVE.L  D7,D0
    ANDI.B  #$30,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BNE.S   .lab_0D67

    MOVE.L  CONFIG_RefreshIntervalSeconds,D6
    BRA.S   .lab_0D69

.lab_0D67:
    MOVE.L  D7,D0
    ANDI.B  #$20,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   .branch

    BSR.W   GCOMMAND_GetBannerChar

    MOVE.W  CONFIG_BannerCopperHeadByte,D1
    CMP.W   D0,D1
    BNE.S   .lab_0D69

    MOVE.L  CONFIG_RefreshIntervalSeconds,D6
    BRA.S   .lab_0D69

.branch:
    MOVE.L  D7,D0
    ANDI.B  #$40,D0
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   .lab_0D69

    MOVEQ   #-1,D6

.lab_0D69:
    LEA     ESQPARS2_BannerQueueBuffer,A0
    ADDA.W  GCOMMAND_BannerQueueSlotPrevious,A0
    MOVE.B  D6,(A0)
    MOVEM.L (A7)+,D6-D7
    RTS

;!======
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
;   _GCOMMAND_HighlightFlag, ESQ_CopperEffectTemplateRowsSet0, ESQ_CopperListBannerA, ESQ_CopperEffectTemplateRowsSet1, ESQ_CopperListBannerB
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
    MOVE.L  #ESQ_CopperEffectTemplateRowsSet0,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #ESQ_CopperEffectTemplateRowsSet1,-4(A5)
    MOVEQ   #-3,D0
    MOVEA.L -4(A5),A0
    AND.W   26(A0),D0
    OR.W    D7,D0
    MOVE.W  D0,26(A0)
    MOVE.L  #ESQ_CopperListBannerA,-8(A5)
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
    MOVE.L  #ESQ_CopperListBannerB,-8(A5)
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
