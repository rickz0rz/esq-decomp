    XDEF    _ESQPARS_ApplyRtcBytesAndPersist




;------------------------------------------------------------------------------
; FUNC: _ESQPARS_ApplyRtcBytesAndPersist   (Apply incoming RTC bytes and persist globals)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +14: arg_6 (via 18(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
;   stack +20: arg_9 (via 24(A5))
;   stack +28: arg_10 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D7
; CALLS:
;   _ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals, _ESQDISP_NormalizeClockAndRedrawBanner
; READS:
;   _ESQPARS2_ReadModeFlags
; WRITES:
;   _ESQPARS2_ReadModeFlags
; DESC:
;   Loads RTC bytes from the incoming command payload into stack temporaries,
;   persists them through PARSEINI, then normalizes/redraws clock display state.
; NOTES:
;   year byte is converted to full year by adding 1900 before persisting.
;------------------------------------------------------------------------------
_ESQPARS_ApplyRtcBytesAndPersist:
    LINK.W  A5,#-24
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.B  (A3),D0
    EXT.W   D0
    MOVE.W  D0,-24(A5)
    MOVE.B  1(A3),D0
    EXT.W   D0
    MOVE.W  D0,-22(A5)
    MOVE.B  2(A3),D0
    EXT.W   D0
    MOVE.W  D0,-20(A5)
    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    ADDI.L  #1900,D0
    MOVE.W  D0,-18(A5)
    MOVE.B  4(A3),D0
    EXT.W   D0
    MOVE.W  D0,-16(A5)
    MOVE.B  5(A3),D0
    EXT.W   D0
    MOVE.W  D0,-14(A5)
    MOVE.B  6(A3),D0
    EXT.W   D0
    MOVE.W  D0,-12(A5)
    MOVE.B  7(A3),D0
    EXT.W   D0
    MOVE.W  D0,-10(A5)
    PEA     -24(A5)
    JSR     _ESQDISP_NormalizeClockAndRedrawBanner(PC)

    MOVE.W  _ESQPARS2_ReadModeFlags,D7
    MOVE.W  #256,_ESQPARS2_ReadModeFlags
    JSR     _ESQPARS_JMPTBL_PARSEINI_WriteRtcFromGlobals(PC)

    MOVE.W  D7,_ESQPARS2_ReadModeFlags

    MOVEM.L -32(A5),D7/A3
    UNLK    A5
    RTS

;!======