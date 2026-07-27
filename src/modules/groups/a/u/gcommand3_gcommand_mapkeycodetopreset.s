    XDEF    _GCOMMAND_MapKeycodeToPreset


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_MapKeycodeToPreset   (Interpret a keyboard scan code and map it to a preset palette index.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D6/D7
; CALLS:
;   _GCOMMAND_GetBannerChar
; READS:
;   _CONFIG_BannerCopperHeadByte, _CONFIG_RefreshIntervalSeconds, _ESQPARS2_BannerQueueBuffer, _GCOMMAND_BannerQueueSlotPrevious
; WRITES:
;   (none observed)
; DESC:
;   Interpret a keyboard scan code and map it to a preset palette index.
; NOTES:
;   Uses bit masks `$30/$20/$40` on keycode byte and enqueues into
;   `_ESQPARS2_BannerQueueBuffer` at `_GCOMMAND_BannerQueueSlotPrevious`.
;------------------------------------------------------------------------------

; Interpret a keyboard scan code and map it to a preset palette index.
_GCOMMAND_MapKeycodeToPreset:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVEQ   #0,D6
    MOVE.L  D7,D0
    ANDI.B  #$30,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BNE.S   .lab_0D67

    MOVE.L  _CONFIG_RefreshIntervalSeconds,D6
    BRA.S   .lab_0D69

.lab_0D67:
    MOVE.L  D7,D0
    ANDI.B  #$20,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   .branch

    BSR.W   _GCOMMAND_GetBannerChar

    MOVE.W  _CONFIG_BannerCopperHeadByte,D1
    CMP.W   D0,D1
    BNE.S   .lab_0D69

    MOVE.L  _CONFIG_RefreshIntervalSeconds,D6
    BRA.S   .lab_0D69

.branch:
    MOVE.L  D7,D0
    ANDI.B  #$40,D0
    MOVEQ   #64,D1
    CMP.B   D1,D0
    BNE.S   .lab_0D69

    MOVEQ   #-1,D6

.lab_0D69:
    LEA     _ESQPARS2_BannerQueueBuffer,A0
    ADDA.W  _GCOMMAND_BannerQueueSlotPrevious,A0
    MOVE.B  D6,(A0)
    MOVEM.L (A7)+,D6-D7
    RTS

;!======