    XDEF    _ESQDISP_ApplyStatusMaskToIndicators



;------------------------------------------------------------------------------
; FUNC: _ESQDISP_ApplyStatusMaskToIndicators   (Map status-bit mask to two indicator color slots)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   _ESQDISP_SetStatusIndicatorColorSlot
; READS:
;   status mask argument (D7 bits)
; WRITES:
;   (none observed)
; DESC:
;   Decodes grouped status bits and updates two indicator slots (mode 1 + mode 0)
;   by forwarding selected color IDs to _ESQDISP_SetStatusIndicatorColorSlot.
; NOTES:
;   `D7==-1` forces default reset behavior for both indicator groups.
;------------------------------------------------------------------------------
_ESQDISP_ApplyStatusMaskToIndicators:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .evaluate_primary_indicator_group

    PEA     1.W
    MOVE.L  D0,-(A7)
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .evaluate_secondary_indicator_group

.evaluate_primary_indicator_group:
    BTST    #4,D7
    BEQ.S   .primary_no_bit4

    BTST    #5,D7
    BEQ.S   .primary_bit4_only

    PEA     1.W
    PEA     4.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .evaluate_secondary_indicator_group

.primary_bit4_only:
    PEA     1.W
    PEA     2.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .evaluate_secondary_indicator_group

.primary_no_bit4:
    PEA     1.W
    PEA     7.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7

.evaluate_secondary_indicator_group:
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .secondary_eval_bit8

    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.W   .return

.secondary_eval_bit8:
    BTST    #8,D7
    BEQ.S   .secondary_eval_bit0

    CLR.L   -(A7)
    PEA     4.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_eval_bit0:
    BTST    #0,D7
    BEQ.S   .secondary_no_bit0

    BTST    #2,D7
    BEQ.S   .secondary_bit0_without_bit2

    CLR.L   -(A7)
    PEA     4.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_bit0_without_bit2:
    BTST    #1,D7
    BEQ.S   .secondary_bit0_fallback

    CLR.L   -(A7)
    PEA     2.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_bit0_fallback:
    CLR.L   -(A7)
    PEA     1.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_no_bit0:
    BTST    #2,D7
    BEQ.S   .secondary_no_bit0_no_bit2

    CLR.L   -(A7)
    PEA     3.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_no_bit0_no_bit2:
    BTST    #1,D7
    BEQ.S   .secondary_no_bits_1_2

    CLR.L   -(A7)
    PEA     3.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7
    BRA.S   .return

.secondary_no_bits_1_2:
    CLR.L   -(A7)
    PEA     7.W
    BSR.W   _ESQDISP_SetStatusIndicatorColorSlot

    ADDQ.W  #8,A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======