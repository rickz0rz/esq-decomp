    XDEF    _ESQDISP_ApplyStatusMaskToIndicators
    XDEF    _ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    ESQDISP_UpdateStatusMaskAndRefresh_Return


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

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_UpdateStatusMaskAndRefresh   (UpdateStatusMaskAndRefresh)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D5/D6/D7
; CALLS:
;   _ESQDISP_ApplyStatusMaskToIndicators
; READS:
;   ESQDISP_StatusIndicatorMask, fff
; WRITES:
;   ESQDISP_StatusIndicatorMask
; DESC:
;   Sets or clears bits in the global status mask, clamps to 12 bits, and only
;   refreshes status indicators when the effective mask changed.
; NOTES:
;   D6 controls operation mode: non-zero = OR-in mask, zero = clear mask bits.
;------------------------------------------------------------------------------
_ESQDISP_UpdateStatusMaskAndRefresh:
    MOVEM.L D5-D7,-(A7)
    MOVE.L  16(A7),D7
    MOVE.L  20(A7),D6
    MOVEQ   #-1,D5
    MOVE.L  ESQDISP_StatusIndicatorMask,D5
    TST.L   D6
    BEQ.S   .lab_08DB

    OR.L    D7,ESQDISP_StatusIndicatorMask
    BRA.S   .lab_08DC

.lab_08DB:
    MOVE.L  D7,D0
    NOT.L   D0
    AND.L   D0,ESQDISP_StatusIndicatorMask

.lab_08DC:
    ANDI.L  #$fff,ESQDISP_StatusIndicatorMask
    MOVE.L  ESQDISP_StatusIndicatorMask,D0
    CMP.L   D0,D5
    BEQ.S   ESQDISP_UpdateStatusMaskAndRefresh_Return

    MOVE.L  D0,-(A7)
    BSR.W   _ESQDISP_ApplyStatusMaskToIndicators

    ADDQ.W  #4,A7

;------------------------------------------------------------------------------
; FUNC: ESQDISP_UpdateStatusMaskAndRefresh_Return   (UpdateStatusMaskAndRefresh_Return)
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
;   Shared return tail for _ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Restores D5-D7 and returns.
;------------------------------------------------------------------------------
ESQDISP_UpdateStatusMaskAndRefresh_Return:
    MOVEM.L (A7)+,D5-D7
    RTS

;!======
