    XDEF    _NEWGRID_ComputeColumnIndex


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ComputeColumnIndex   (Compute column index from selection)
; ARGS:
;   stack +8: A3 = grid struct
; RET:
;   D0: column index (0..?)
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   _NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   _NEWGRID_RowHeightPx, 52(A3), 54(A3)
; WRITES:
;   none
; DESC:
;   Computes a column index based on selection byte and header width.
; NOTES:
;   Returns 0 when selection >= 0x40.
;------------------------------------------------------------------------------
_NEWGRID_ComputeColumnIndex:
    LINK.W  A5,#-4
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEQ   #0,D7
    CMPI.B  #'@',54(A3)
    BCC.S   .done

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    TST.L   D0
    BPL.S   .center

    ADDQ.L  #3,D0

.center:
    ASR.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  52(A3),D1
    MOVE.L  D0,8(A7)
    MOVE.L  D1,D0
    MOVE.L  8(A7),D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,D7

.done:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======
