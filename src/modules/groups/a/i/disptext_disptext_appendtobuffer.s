    XDEF    _DISPTEXT_AppendToBuffer




;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_AppendToBuffer   (Append to display text bufferuncertain)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: boolean success (0/-1)
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   _LVOAvailMem, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _DISPTEXT_TextBufferPtr
; WRITES:
;   _DISPTEXT_TextBufferPtr
; DESC:
;   Appends a string to the global display-text buffer, reallocating if needed.
; NOTES:
;   Booleanize pattern: SNE/NEG/EXT.
;------------------------------------------------------------------------------
_DISPTEXT_AppendToBuffer:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -8(A5)
    TST.L   _DISPTEXT_TextBufferPtr
    BEQ.W   .alloc_new_buffer

    MOVEA.L _DISPTEXT_TextBufferPtr,A0

.find_end_dst:
    TST.B   (A0)+
    BNE.S   .find_end_dst

    SUBQ.L  #1,A0
    SUBA.L  _DISPTEXT_TextBufferPtr,A0
    MOVEA.L A3,A1

.find_end_src:
    TST.B   (A1)+
    BNE.S   .find_end_src

    SUBQ.L  #1,A1
    SUBA.L  A3,A1
    MOVE.L  A0,D0
    MOVE.L  A1,D1
    ADD.L   D1,D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVEQ   #1,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    CMPI.L  #$2710,D0
    BLE.S   .realloc_buffer

    PEA     (MEMF_PUBLIC).W
    MOVE.L  D7,-(A7)
    PEA     127.W
    PEA     _Global_STR_DISPTEXT_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.realloc_buffer:
    TST.L   -8(A5)
    BEQ.S   .return_status

    MOVEA.L _DISPTEXT_TextBufferPtr,A0
    MOVEA.L -8(A5),A1

.copy_old_buffer:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_old_buffer

    MOVE.L  A3,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  _DISPTEXT_TextBufferPtr,(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     12(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  A0,_DISPTEXT_TextBufferPtr
    BRA.S   .return_status

.alloc_new_buffer:
    MOVE.L  _DISPTEXT_TextBufferPtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISPTEXT_TextBufferPtr

.return_status:
    TST.L   _DISPTEXT_TextBufferPtr
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======