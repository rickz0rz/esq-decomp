    XDEF    _SETUP_INTERRUPT_INTB_VERTB


;------------------------------------------------------------------------------
; FUNC: _SETUP_INTERRUPT_INTB_VERTB   (InstallVerticalBlankInterruptVector)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOAddIntVector
; READS:
;   AbsExecBase, _ESQFUNC_JMPTBL_ESQ_TickGlobalCounters, _Global_REF_INTERRUPT_STRUCT_INTB_VERTB, _Global_STR_ESQFUNC_C_1, _Global_STR_VERTICAL_BLANK_INT, INTB_VERTB, _ESQ_VerticalBlankInterruptUserData, MEMF_PUBLIC
; WRITES:
;   _Global_REF_INTERRUPT_STRUCT_INTB_VERTB
; DESC:
;   Allocates and initializes an Interrupt struct for VBLANK and installs it on
;   INTB_VERTB, targeting _ESQFUNC_JMPTBL_ESQ_TickGlobalCounters.
; NOTES:
;   Stores the allocated Interrupt pointer in _Global_REF_INTERRUPT_STRUCT_INTB_VERTB.
;------------------------------------------------------------------------------
_SETUP_INTERRUPT_INTB_VERTB:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1159.W                          ; Line Number
    PEA     _Global_STR_ESQFUNC_C_1            ; Calling File
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,_Global_REF_INTERRUPT_STRUCT_INTB_VERTB
    MOVEA.L D0,A0
    MOVE.B  #$2,8(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    CLR.B   9(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    MOVE.L  #_Global_STR_VERTICAL_BLANK_INT,10(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A0
    MOVE.L  #_ESQ_VerticalBlankInterruptUserData,14(A0)
    LEA     _ESQFUNC_JMPTBL_ESQ_TickGlobalCounters(PC),A0

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_VERTB,A1
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_VERTB,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAddIntVector(A6)

    RTS

;!======