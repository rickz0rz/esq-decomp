    XDEF    _SETUP_INTERRUPT_INTB_AUD1


;------------------------------------------------------------------------------
; FUNC: _SETUP_INTERRUPT_INTB_AUD1   (InstallAud1InterruptVector)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOSetIntVector
; READS:
;   AbsExecBase, _ESQFUNC_JMPTBL_ESQ_PollCtrlInput, _Global_REF_INTERRUPT_STRUCT_INTB_AUD1, _Global_STR_ESQFUNC_C_2, _Global_STR_JOYSTICK_INT, INTB_AUD1, _CTRL_SampleEntryScratch, MEMF_CHIP
; WRITES:
;   _Global_REF_INTB_AUD1_INTERRUPT, _Global_REF_INTERRUPT_STRUCT_INTB_AUD1
; DESC:
;   Allocates and initializes an Interrupt struct for AUD1 and installs it on
;   INTB_AUD1, targeting _ESQFUNC_JMPTBL_ESQ_PollCtrlInput.
; NOTES:
;   Saves the previous vector returned by SetIntVector in _Global_REF_INTB_AUD1_INTERRUPT.
;------------------------------------------------------------------------------
_SETUP_INTERRUPT_INTB_AUD1:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_CHIP).W                   ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1172.W                          ; Line Number
    PEA     _Global_STR_ESQFUNC_C_2            ; Calling File
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7

    MOVE.L  D0,_Global_REF_INTERRUPT_STRUCT_INTB_AUD1
    MOVEA.L D0,A0
    MOVE.B  #$2,8(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    CLR.B   9(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    MOVE.L  #_Global_STR_JOYSTICK_INT,10(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A0
    MOVE.L  #_CTRL_SampleEntryScratch,14(A0)
    LEA     _ESQFUNC_JMPTBL_ESQ_PollCtrlInput(PC),A0

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_AUD1,A1
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_AUD1,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  D0,_Global_REF_INTB_AUD1_INTERRUPT
    RTS

;!======