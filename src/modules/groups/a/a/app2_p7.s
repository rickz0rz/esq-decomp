    XDEF    _ESQ_AdjustBracketedHourInString
    XDEF    ESQ_AdvanceBannerCharIndex_Return


;------------------------------------------------------------------------------
; FUNC: _ESQ_AdvanceBannerCharIndex   (Advance banner char index)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3
; CALLS:
;   (none)
; READS:
;   _WDISP_BannerCharIndex, _WDISP_BannerCharPhaseShift, _WDISP_BannerCharRangeStart, _WDISP_BannerCharRangeEnd, _BANNER_ResetPendingFlag
; WRITES:
;   _ESQ_BannerCharResetPulse, _WDISP_BannerCharIndex, _ESQ_BannerCharIndexShadow2273, _BANNER_ResetPendingFlag
; DESC:
;   Advances a cycling index in the 1..48 range and applies a step offset.
; NOTES:
;   If _BANNER_ResetPendingFlag is non-zero, forces a reset path and clears the flag.
;   Also resets when the index matches _WDISP_BannerCharRangeEnd, using _WDISP_BannerCharRangeStart as the base.
;------------------------------------------------------------------------------
_ESQ_AdvanceBannerCharIndex:
    MOVEM.L D2-D3,-(A7)
    MOVE.W  _WDISP_BannerCharIndex,D0
    MOVEQ   #1,D2
    ADD.W   D2,D0
    MOVEQ   #48,D3
    CMP.W   D3,D0
    BLE.S   .lab_00A1

    MOVE.W  D2,D0

.lab_00A1:
    TST.W   _BANNER_ResetPendingFlag
    BEQ.S   .lab_00A2

    MOVE.W  #0,_BANNER_ResetPendingFlag
    BRA.S   .lab_00A3

.lab_00A2:
    MOVE.W  _WDISP_BannerCharRangeEnd,D1
    CMP.W   D1,D0
    BNE.S   .lab_00A4

.lab_00A3:
    MOVE.W  D2,_ESQ_BannerCharResetPulse
    MOVE.W  _WDISP_BannerCharRangeStart,D0

.lab_00A4:
    MOVE.W  D0,_WDISP_BannerCharIndex
    MOVE.W  _WDISP_BannerCharPhaseShift,D1
    BEQ.S   ESQ_AdvanceBannerCharIndex_Return

    ADD.W   D1,D0
    ADD.W   D1,D0
    CMP.W   D2,D0
    BGE.S   .lab_00A5

    ADD.W   D3,D0
    BRA.S   ESQ_AdvanceBannerCharIndex_Return

.lab_00A5:
    CMP.W   D3,D0
    BLE.S   ESQ_AdvanceBannerCharIndex_Return

    SUB.W   D3,D0

;------------------------------------------------------------------------------
; FUNC: ESQ_AdvanceBannerCharIndex_Return   (Routine at ESQ_AdvanceBannerCharIndex_Return)
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
;   _ESQ_BannerCharIndexShadow2273
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
ESQ_AdvanceBannerCharIndex_Return:
    MOVE.W  D0,_ESQ_BannerCharIndexShadow2273
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQ_AdjustBracketedHourInString   (AdjustBracketedHourInStringuncertain)
; ARGS:
;   (none observed)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4, A0-A1
; CALLS:
;   (none)
; READS:
;   [textPtr]
; WRITES:
;   [textPtr]
; DESC:
;   Scans for bracketed hour fields, replaces '['/']' with '(' / ')' and
;   optionally offsets the hour value, wrapping it into 1..12.
; NOTES:
;   Only adjusts when hourOffset != 0; parsing assumes two-digit hours with
;   a possible leading space.
;------------------------------------------------------------------------------
_ESQ_AdjustBracketedHourInString:
    MOVEA.L 4(A7),A0
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D4

.scan_for_left_bracket:
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  D0,D2
    MOVEQ   #'[',D3

.find_left_bracket:
    MOVE.B  (A0)+,D2
    BEQ.W   .return

    CMP.B   D3,D2
    BNE.S   .find_left_bracket

    SUBQ.W  #1,A0
    MOVEQ   #'(',D3
    MOVE.B  D3,(A0)+
    TST.B   D4
    BEQ.S   .scan_for_right_bracket

    MOVE.B  (A0)+,D1
    CMPI.B  #' ',D1
    BEQ.S   .parse_second_digit

    MOVEQ   #10,D0

.parse_second_digit:
    MOVE.B  (A0)+,D1
    SUBI.B  #$30,D1
    ADD.B   D1,D0
    MOVEQ   #12,D1
    ADD.B   D4,D0
    CMPI.B  #$1,D0
    BGE.S   .wrap_hour_range

    ADD.B   D1,D0
    BRA.S   .emit_hour

.wrap_hour_range:
    CMP.B   D1,D0
    BLE.S   .emit_hour

    SUB.B   D1,D0
    BRA.S   .wrap_hour_range

.emit_hour:
    MOVEQ   #10,D1
    MOVEQ   #32,D2
    MOVEA.L A0,A1
    CMP.B   D1,D0
    BLT.S   .write_hour_digits

    SUB.B   D1,D0
    MOVEQ   #49,D2

.write_hour_digits:
    ADDI.B  #48,D0
    MOVE.B  D0,-(A1)
    MOVE.B  D2,-(A1)

.scan_for_right_bracket:
    MOVEQ   #']',D3

.find_right_bracket:
    MOVE.B  (A0)+,D2
    BEQ.S   .return

    CMP.B   D3,D2
    BNE.S   .find_right_bracket

    SUBQ.W  #1,A0
    MOVEQ   #')',D3
    MOVE.B  D3,(A0)+
    BRA.S   .scan_for_left_bracket

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======