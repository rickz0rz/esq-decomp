    XDEF    _DISPTEXT_ComputeMarkerWidths


;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_ComputeMarkerWidths   (Compute padding widthsuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A6/A7/D0/D4/D5/D6/D7
; CALLS:
;   _GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers, _LVOTextLength
; READS:
;   _DISPTEXT_ControlMarkerWidthPx
; WRITES:
;   _DISPTEXT_ControlMarkerWidthPx
; DESC:
;   Computes combined text lengths for two optional markers and stores in _DISPTEXT_ControlMarkerWidthPx.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_ComputeMarkerWidths:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    PEA     -4(A5)
    PEA     -3(A5)
    PEA     -2(A5)
    PEA     -1(A5)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    JSR     _GROUP_AI_JMPTBL_NEWGRID_SetSelectionMarkers(PC)

    LEA     24(A7),A7
    TST.B   -1(A5)
    BEQ.S   .no_prefix1

    MOVEA.L A3,A1
    LEA     -1(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .check_prefix2

.no_prefix1:
    MOVEQ   #0,D0

.check_prefix2:
    MOVE.L  D0,D5
    TST.B   -3(A5)
    BEQ.S   .no_prefix2

    MOVEA.L A3,A1
    LEA     -3(A5),A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    BRA.S   .store_combined

.no_prefix2:
    MOVEQ   #0,D0

.store_combined:
    MOVE.L  D0,D4
    MOVE.L  D5,D0
    ADD.L   D4,D0
    MOVE.L  D0,_DISPTEXT_ControlMarkerWidthPx
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======