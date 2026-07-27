    XDEF    _DISPTEXT_BuildLayoutForSource

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_BuildLayoutForSource   (Build layout for a source string)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: boolean success
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
; CALLS:
;   _GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2, _DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   _DISPTEXT_LineTableLockFlag, _Global_REF_1000_BYTES_ALLOCATED_1
; WRITES:
;   _Global_REF_1000_BYTES_ALLOCATED_1 (via _GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2)
; DESC:
;   Prepares output buffer and runs layout; returns success flag.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISPTEXT_BuildLayoutForSource:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    TST.L   _DISPTEXT_LineTableLockFlag
    BNE.S   .return_status

    LEA     16(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  12(A5),-(A7)
    MOVE.L  _Global_REF_1000_BYTES_ALLOCATED_1,-(A7)
    MOVE.L  A0,-8(A5)
    JSR     _GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(PC)

    MOVE.L  _Global_REF_1000_BYTES_ALLOCATED_1,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _DISPTEXT_LayoutAndAppendToBuffer

    LEA     16(A7),A7
    MOVE.L  D0,D7

.return_status:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======