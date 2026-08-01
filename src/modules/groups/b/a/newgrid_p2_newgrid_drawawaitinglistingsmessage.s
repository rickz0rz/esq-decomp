    XDEF    _NEWGRID_DrawAwaitingListingsMessage



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawAwaitingListingsMessage   (Draw waiting banner)
; ARGS:
;   stack +8: A3 = base rastport/struct
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridFrame, _LVOSetAPen, _LVOTextLength, _LVOMove, _NEWGRID_DrawWrappedText, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _NEWGRID_RowHeightPx, _Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Draws the “Awaiting Listings Data” banner centered in the grid area on a single line.
; NOTES:
;   Uses text length to center the string within the 624px region. Seemingly truncates text if it's longer than 624px.
;------------------------------------------------------------------------------
_NEWGRID_DrawAwaitingListingsMessage:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrame

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    LEA     60(A3),A1
    MOVEA.L _Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2

.measure_message:
    TST.B   (A2)+
    BNE.S   .measure_message

    SUBQ.L  #1,A2
    SUBA.L  _Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2
    MOVE.L  A0,32(A7)
    MOVE.L  A2,D0

    ; Get the length of the Awaiting Listings Data text and subtract it from 624
    MOVEA.L _Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A0
    JSR     _LVOTextLength(A6)

    MOVE.L  #624,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .length_ok     ; if positive, keep

    ADDQ.L  #1,D1                                           ; compensate negative

.length_ok:
    ASR.L   #1,D1                                           ; Shift D1 right 1
    MOVEQ   #36,D0                                          ; 36 into D0
    ADD.L   D0,D1                                           ; Add D0 (36) into D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D0
    TST.L   D0
    BPL.S   .center_y

    ADDQ.L  #1,D0

.center_y:
    ASR.L   #1,D0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D0
    SUBQ.L  #1,D0
    PEA     1.W
    MOVE.L  _Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,-(A7)
    PEA     612.W
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  52(A7),-(A7)
    BSR.W   _NEWGRID_DrawWrappedText

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A7),A7
    MOVE.W  _NEWGRID_RowHeightPx,D0
    LSR.W   #1,D0

    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)

    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======