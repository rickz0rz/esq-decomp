    XDEF    _DISKIO2_CopyAndSanitizeSlotString


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_CopyAndSanitizeSlotString   (Copy and sanitize slot string.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +18: arg_4 (via 22(A5))
; RET:
;   D0: dest pointer (or 0 if not copied)
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D7
; CALLS:
;   _GROUP_AI_JMPTBL_STR_FindCharPtr, _GROUP_AH_JMPTBL_STR_FindAnyCharPtr
; READS:
;   7(A0,D7), 27(A2)
; WRITES:
;   dest buffer
; DESC:
;   Copies a slot string to the destination, trims/normalizes, and terminates it.
; NOTES:
;   Skips copy when flags indicate the slot should be hidden.
;------------------------------------------------------------------------------
_DISKIO2_CopyAndSanitizeSlotString:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 16(A5),A0
    MOVEA.L 56(A0,D0.L),A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A2,D0
    BEQ.W   .sanitize_return

    TST.L   16(A5)
    BEQ.W   .sanitize_return

    TST.W   D7
    BLE.W   .sanitize_return

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.W   .sanitize_return

    MOVE.L  A0,D0
    BEQ.W   .sanitize_return

    TST.B   (A0)
    BEQ.W   .sanitize_return

    MOVEA.L 16(A5),A0
    BTST    #1,7(A0,D7.W)
    BNE.S   .sanitize_copy_if_slot_visible

    BTST    #4,27(A2)
    BEQ.S   .sanitize_return

.sanitize_copy_if_slot_visible:
    MOVEA.L -12(A5),A0
    MOVEA.L A3,A1

    ; Copy source string into destination buffer.
.sanitize_copy_source_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .sanitize_copy_source_loop

    PEA     34.W
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .sanitize_trim_after_quote

    ADDQ.L  #1,-4(A5)
    PEA     34.W
    MOVE.L  -4(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)

.sanitize_trim_after_quote:
    TST.L   D0
    BEQ.S   .sanitize_set_return_ptr

    PEA     _NEWGRID_EntrySplitDelimiterMask
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AH_JMPTBL_STR_FindAnyCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .sanitize_scan_trim_point

    MOVE.L  D0,-4(A5)

.sanitize_scan_trim_point:
    ; Skip leading spaces after expansion.
    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .sanitize_terminate_string

    MOVEQ   #32,D0
    CMP.B   (A0),D0
    BEQ.S   .sanitize_terminate_string

    ADDQ.L  #1,-4(A5)
    BRA.S   .sanitize_scan_trim_point

.sanitize_terminate_string:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)

.sanitize_set_return_ptr:
    MOVEA.L A3,A0
    MOVE.L  A0,-12(A5)

.sanitize_return:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======