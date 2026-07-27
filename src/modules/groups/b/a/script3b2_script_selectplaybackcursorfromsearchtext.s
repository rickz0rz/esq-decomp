    XDEF    _SCRIPT_SelectPlaybackCursorFromSearchText


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_SelectPlaybackCursorFromSearchText   (Resolve cursor from split search windows)
; ARGS:
;   stack +8: matchCountOrIndex (long) ??
;   stack +12: parseBuffer (char *)
; RET:
;   D0: 1 when a primary or secondary lookup matched, else 0
; CLOBBERS:
;   A0/A1/A3/A7/D0/D5/D6/D7
; CALLS:
;   _TEXTDISP_SelectGroupAndEntry
; READS:
;   _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode, _SCRIPT_PrimarySearchFirstFlag
; WRITES:
;   _SCRIPT_SearchMatchCountOrIndex, _SCRIPT_PlaybackCursor, _SCRIPT_ChannelRangeArmedFlag
; DESC:
;   Splits the incoming parse buffer into primary/secondary lookup windows and
;   tries entry selection in preferred order based on _SCRIPT_PrimarySearchFirstFlag.
; NOTES:
;   Sets _SCRIPT_PlaybackCursor to 6/7 on successful primary/secondary matches,
;   otherwise forces cursor 1 and clears _SCRIPT_ChannelRangeArmedFlag.
;------------------------------------------------------------------------------
_SCRIPT_SelectPlaybackCursorFromSearchText:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #1,D6
    MOVE.L  D7,_SCRIPT_SearchMatchCountOrIndex
    MOVE.W  #1,_SCRIPT_ChannelRangeArmedFlag
    MOVEQ   #3,D5

.loop_1546:
    MOVEQ   #18,D0
    CMP.B   0(A3,D5.W),D0
    BEQ.S   .branch_1547

    MOVEQ   #30,D0
    CMP.W   D0,D5
    BGE.S   .branch_1547

    ADDQ.W  #1,D5
    BRA.S   .loop_1546

.branch_1547:
    CLR.B   0(A3,D5.W)
    TST.W   _SCRIPT_PrimarySearchFirstFlag
    BNE.S   .if_ne_1548

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  _TEXTDISP_SecondaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _TEXTDISP_SecondarySearchText
    MOVE.L  A1,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1548

    MOVEQ   #7,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.if_ne_1548:
    LEA     2(A3),A0
    MOVE.W  _TEXTDISP_PrimaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _TEXTDISP_PrimarySearchText
    MOVE.L  A0,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1549

    MOVEQ   #6,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.if_ne_1549:
    TST.W   _SCRIPT_PrimarySearchFirstFlag
    BEQ.S   .branch_154A

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  _TEXTDISP_SecondaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _TEXTDISP_SecondarySearchText
    MOVE.L  A1,-(A7)
    JSR     _TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .branch_154A

    MOVEQ   #7,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.branch_154A:
    MOVEQ   #0,D6
    CLR.W   _SCRIPT_ChannelRangeArmedFlag
    MOVEQ   #1,D0
    MOVE.L  D0,_SCRIPT_PlaybackCursor

.skip_154B:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======