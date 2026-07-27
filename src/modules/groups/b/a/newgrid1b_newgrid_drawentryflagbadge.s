    XDEF    _NEWGRID_DrawEntryFlagBadge


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawEntryFlagBadge   (Draw entry flag indicator)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A2-A3
; CALLS:
;   _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams, _NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1, _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer, _NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes, _NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   27(A2)
; WRITES:
;   none
; DESC:
;   Draws a badge/flag indicator for entries with specific flags set.
; NOTES:
;   Uses cleanup/test helpers to validate the entry before drawing.
;------------------------------------------------------------------------------
_NEWGRID_DrawEntryFlagBadge:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.L  24(A5),D6
    MOVE.L  D6,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     12(A7),A7
    MOVE.L  A2,D0
    BEQ.S   .fallback_draw

    BTST    #4,27(A2)
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     5.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_TestEntryFlagYAndBit1(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _NEWGRID2_JMPTBL_COI_SelectAnimFieldPointer(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .fallback_draw

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _NEWGRID2_JMPTBL_CLEANUP_UpdateEntryFlagBytes(PC)

    MOVE.L  20(A5),(A7)
    PEA     20.W
    MOVE.L  -4(A5),-(A7)
    PEA     19.W
    PEA     _NEWGRID_EntryDetailFmtStr
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_BuildLayoutForSource(PC)

    LEA     28(A7),A7
    BRA.S   .done

.fallback_draw:
    MOVE.L  20(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======