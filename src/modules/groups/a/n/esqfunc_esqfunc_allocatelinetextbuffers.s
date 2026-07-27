    XDEF    _ESQFUNC_AllocateLineTextBuffers


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_AllocateLineTextBuffers   (AllocateLineTextBuffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D7
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory
; READS:
;   _Global_STR_ESQFUNC_C_5, _LADFUNC_LineTextBufferPtrs, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   _LADFUNC_LineSlotWriteIndex, _LADFUNC_LineSlotSecondaryIndex
; DESC:
;   Allocates 20 line text buffers (60 bytes each), stores pointers in
;   _LADFUNC_LineTextBufferPtrs, and resets line-slot indices.
; NOTES:
;   Companion free path is _ESQFUNC_FreeLineTextBuffers.
;------------------------------------------------------------------------------
_ESQFUNC_AllocateLineTextBuffers:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_0964:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_LineTextBufferPtrs,A0
    ADDA.L  D0,A0

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)     ; Memory Type
    PEA     60.W                                ; Bytes to Allocate
    PEA     1222.W                              ; Line Number
    PEA     _Global_STR_ESQFUNC_C_5                ; Calling File
    MOVE.L  A0,20(A7)
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0964

.return:
    MOVEQ   #0,D0
    MOVE.W  D0,_LADFUNC_LineSlotWriteIndex
    MOVE.W  D0,_LADFUNC_LineSlotSecondaryIndex
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======