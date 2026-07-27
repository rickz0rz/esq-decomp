    XDEF    _ESQFUNC_FreeLineTextBuffers


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_FreeLineTextBuffers   (Free and clear LADFUNC line text buffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D7
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_ESQFUNC_C_6, _LADFUNC_LineTextBufferPtrs
; WRITES:
;   (none observed)
; DESC:
;   Iterates 20 line-text buffer pointers, deallocates each 60-byte buffer, and
;   clears the pointer slot.
; NOTES:
;   Uses _Global_STR_ESQFUNC_C_6 as deallocation callsite tag.
;------------------------------------------------------------------------------
_ESQFUNC_FreeLineTextBuffers:
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.loop_free_line_text_buffers:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .return_free_line_text_buffers

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0

    ; Deallocate 60 bytes from A0
    PEA     60.W
    MOVE.L  (A0),-(A7)
    PEA     1235.W
    PEA     _Global_STR_ESQFUNC_C_6
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0
    CLR.L   (A0)
    ADDQ.W  #1,D7
    BRA.S   .loop_free_line_text_buffers

.return_free_line_text_buffers:
    MOVE.L  (A7)+,D7
    RTS

;!======