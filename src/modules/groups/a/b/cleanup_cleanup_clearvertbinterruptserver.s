    XDEF    _CLEANUP_ClearVertbInterruptServer


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_ClearVertbInterruptServer
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVORemIntServer, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_INTERRUPT_STRUCT_INTB_VERTB, AbsExecBase, _Global_STR_CLEANUP_C_1
; WRITES:
;   (none)
; DESC:
;   Removes the INTB_VERTB interrupt server and frees its interrupt structure.
; NOTES:
;   - Deallocates the struct via _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory.
;------------------------------------------------------------------------------
_CLEANUP_ClearVertbInterruptServer:
    MOVEQ   #INTB_VERTB,D0
    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVORemIntServer(A6)

    PEA     Struct_Interrupt_Size.W
    MOVE.L  _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,-(A7)
    PEA     57.W
    PEA     _Global_STR_CLEANUP_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    RTS

;!======