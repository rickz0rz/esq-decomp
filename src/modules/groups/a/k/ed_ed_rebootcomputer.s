    XDEF    _ED_RebootComputer


;------------------------------------------------------------------------------
; FUNC: _ED_RebootComputer   (Reboot computeruncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D6/D7
; CALLS:
;   _ED_IsConfirmKey, _DISPLIB_DisplayTextAtPosition, _ED1_JMPTBL_ESQ_ColdReboot,
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays a reboot message, delays briefly, and triggers a cold reboot.
; NOTES:
;   Skips display/reboot if _ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
_ED_RebootComputer:
; display 'rebooting computer' while requesting a reboot through supervisor?
    MOVEM.L D6-D7,-(A7)

    JSR     _ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_reboot

    PEA     _Global_STR_REBOOTING_COMPUTER     ; string
    PEA     120.W                           ; y
    PEA     40.W                            ; x
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)                  ; rastport
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEQ   #0,D6

.delay_loop:
    CMPI.L  #$aae60,D6
    BGE.S   .trigger_reboot

    ADDQ.L  #1,D6
    ADDQ.L  #1,D6
    BRA.S   .delay_loop

.trigger_reboot:
    JSR     _ED1_JMPTBL_ESQ_ColdReboot(PC)

.after_reboot:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    MOVEM.L (A7)+,D6-D7
    RTS

;!======