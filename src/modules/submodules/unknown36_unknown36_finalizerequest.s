    XDEF    _UNKNOWN36_FinalizeRequest


;------------------------------------------------------------------------------
; Struct offsets (UNKNOWN36 request struct)
Struct_UNKNOWN36_Request__Arg16     = 16
Struct_UNKNOWN36_Request__Arg20     = 20
Struct_UNKNOWN36_Request__Flags     = Struct_PreallocHandleNode__OpenFlags
Struct_UNKNOWN36_Request__FlagByte  = Struct_PreallocHandleNode__StateFlags
Struct_UNKNOWN36_Request__Handler   = Struct_PreallocHandleNode__HandleIndex
; NOTE: When this helper is used with handle nodes, clearing +24 clears the
;       overlaid OpenFlags/ModeFlags/StateFlags bytes in one write.
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; FUNC: _UNKNOWN36_FinalizeRequest   (Finalize a request struct and dispatch callbacks.)
; ARGS:
;   stack +16: struct* request (A3)
; RET:
;   D0: 0 on success, -1 on failure
; CLOBBERS:
;   A3/A7/D0/D6/D7
; CALLS:
;   _STREAM_BufferedPutcOrFlush, _ALLOC_InsertFreeBlock, _HANDLE_CloseByIndex
; READS:
;   Struct_UNKNOWN36_Request__Arg16, Struct_UNKNOWN36_Request__Arg20, Struct_UNKNOWN36_Request__FlagByte, Struct_UNKNOWN36_Request__Flags, Struct_UNKNOWN36_Request__Handler
; WRITES:
;   Struct_UNKNOWN36_Request__Flags: flags cleared
; DESC:
;   If a flag is set, calls a callback with -1, optionally runs a secondary
;   cleanup, clears the flags field, then invokes the struct’s handler at 28(A3).
; NOTES:
;   Returns -1 if _STREAM_BufferedPutcOrFlush returns -1 or if the handler returns non-zero.
;------------------------------------------------------------------------------
_UNKNOWN36_FinalizeRequest:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    BTST    #1,Struct_UNKNOWN36_Request__FlagByte(A3)
    BEQ.S   .no_abort_flag

    ; If flag set, invoke _STREAM_BufferedPutcOrFlush with -1 and capture result.
    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     _STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    BRA.S   .after_abort_call

.no_abort_flag:
    MOVEQ   #0,D7

.after_abort_call:
    MOVEQ   #12,D0
    AND.L   Struct_UNKNOWN36_Request__Flags(A3),D0
    BNE.S   .after_optional_cleanup

    TST.L   Struct_UNKNOWN36_Request__Arg20(A3)
    BEQ.S   .after_optional_cleanup

    MOVE.L  Struct_UNKNOWN36_Request__Arg20(A3),-(A7)
    MOVE.L  Struct_UNKNOWN36_Request__Arg16(A3),-(A7)
    JSR     _ALLOC_InsertFreeBlock(PC)

    ADDQ.W  #8,A7

.after_optional_cleanup:
    CLR.L   Struct_UNKNOWN36_Request__Flags(A3) ; clears overlaid open/mode/state bytes too
    ; Invoke handler at 28(A3).
    MOVE.L  Struct_UNKNOWN36_Request__Handler(A3),-(A7)
    JSR     _HANDLE_CloseByIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .return

    TST.L   D6
    BNE.S   .return

    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======