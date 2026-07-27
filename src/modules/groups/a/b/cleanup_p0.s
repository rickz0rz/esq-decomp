    XDEF    _CLEANUP_ClearAud1InterruptVector


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_ClearAud1InterruptVector
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVOSetIntVector, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_REF_INTB_AUD1_INTERRUPT, _Global_REF_INTERRUPT_STRUCT_INTB_AUD1,
;   AbsExecBase, _Global_STR_CLEANUP_C_2
; WRITES:
;   INTENA
; DESC:
;   Restores the AUD1 interrupt vector and frees its interrupt structure.
; NOTES:
;   - Disables INTB_AUD1 in INTENA before restoring the vector.
;------------------------------------------------------------------------------
_CLEANUP_ClearAud1InterruptVector:
    MOVE.W  #$100,INTENA
    MOVEQ   #INTB_AUD1,D0
    MOVEA.L _Global_REF_INTB_AUD1_INTERRUPT,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    PEA     22.W
    MOVE.L  _Global_REF_INTERRUPT_STRUCT_INTB_AUD1,-(A7)
    PEA     74.W
    PEA     _Global_STR_CLEANUP_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    RTS

;!======