    XDEF    _ED_UpdateActiveInactiveIndicator


;------------------------------------------------------------------------------
; FUNC: _ED_UpdateActiveInactiveIndicator   (Update active/inactive indicatoruncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _LVOSetAPen, _LVORectFill, _LVOSetDrMd, _DISPLIB_DisplayTextAtPosition
; READS:
;   _ED_AdActiveFlag, _ED_ActiveIndicatorCachedState, _Global_REF_RASTPORT_1
; WRITES:
;   _ED_ActiveIndicatorCachedState
; DESC:
;   Updates the active/inactive indicator when the flag changes.
; NOTES:
;   Draws two rectangles and the ACTIVE/INACTIVE label.
;------------------------------------------------------------------------------
_ED_UpdateActiveInactiveIndicator:
    MOVEM.L D2-D7,-(A7)

    MOVE.L  _ED_AdActiveFlag,D0
    MOVE.L  _ED_ActiveIndicatorCachedState,D1
    CMP.L   D0,D1
    BEQ.W   .after_indicator_update

    SUBQ.L  #1,D0
    BNE.S   .select_inactive

    MOVEQ   #110,D7
    NOT.B   D7
    MOVE.L  #265,D6
    MOVEQ   #40,D5
    MOVEQ   #65,D4
    ADD.L   D4,D4
    BRA.S   .draw_indicator

.select_inactive:
    MOVEQ   #40,D7
    MOVEQ   #65,D6
    ADD.L   D6,D6
    MOVEQ   #110,D5
    NOT.B   D5
    MOVE.L  #265,D4

.draw_indicator:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVE.L  D7,D0
    MOVE.L  D6,D2
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVE.L  D5,D0
    MOVE.L  D4,D2
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #68,D1
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     _Global_STR_ACTIVE_INACTIVE
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVE.L  _ED_AdActiveFlag,_ED_ActiveIndicatorCachedState

.after_indicator_update:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVEM.L (A7)+,D2-D7
    RTS

;!======