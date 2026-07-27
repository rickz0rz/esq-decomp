    XDEF    _GCOMMAND_AddBannerTableByteDelta


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_AddBannerTableByteDelta   (Add signed byte delta to banner table head byte)
; ARGS:
;   stack +4: tablePtr
;   stack +8: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D7, A3
; CALLS:
;   (none)
; READS:
;   [tablePtr]
; WRITES:
;   [tablePtr]
; DESC:
;   Adds a signed byte delta to the first byte of a banner table.
; NOTES:
;   Used by GCOMMAND_AdjustBannerCopperOffset to bias banner data in-place.
;------------------------------------------------------------------------------
_GCOMMAND_AddBannerTableByteDelta:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.B  19(A7),D7
    ADD.B   D7,(A3)
    MOVEM.L (A7)+,D7/A3
    RTS

;!======