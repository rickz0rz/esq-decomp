    XDEF    _SETUP_INTERRUPT_INTB_RBF


;------------------------------------------------------------------------------
; FUNC: _SETUP_INTERRUPT_INTB_RBF   (InstallSerialRbfInterruptVector)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0
; CALLS:
;   _ESQIFF_JMPTBL_MEMORY_AllocateMemory, _LVOSetIntVector
; READS:
;   AbsExecBase, _ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt, _Global_REF_INTB_RBF_64K_BUFFER, _Global_REF_INTERRUPT_STRUCT_INTB_RBF, _Global_STR_ESQFUNC_C_3, _Global_STR_ESQFUNC_C_4, _Global_STR_RS232_RECEIVE_HANDLER, INTB_RBF, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   _Global_REF_INTB_RBF_64K_BUFFER, _Global_REF_INTB_RBF_INTERRUPT, _Global_REF_INTERRUPT_STRUCT_INTB_RBF
; DESC:
;   Allocates an Interrupt struct plus a 64k receive buffer and installs the
;   serial receive-full handler vector on INTB_RBF.
; NOTES:
;   Vector target is _ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt.
;------------------------------------------------------------------------------
_SETUP_INTERRUPT_INTB_RBF:
    ; Allocate 22 bytes to memory for interrupt struct
    PEA     (MEMF_PUBLIC).W                 ; Memory Type
    PEA     22.W                            ; Bytes to Allocate
    PEA     1195.W                          ; Line Number
    PEA     _Global_STR_ESQFUNC_C_3            ; Calling File
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    MOVE.L  D0,_Global_REF_INTERRUPT_STRUCT_INTB_RBF

    ; Allocate 64,000 bytes to memory
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)  ; Memory Type
    MOVE.L  #64000,-(A7)                    ; Bytes to Allocate
    PEA     1197.W                          ; Line Number
    PEA     _Global_STR_ESQFUNC_C_4            ; Calling File
    JSR     _ESQIFF_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     28(A7),A7

    MOVE.L  D0,_Global_REF_INTB_RBF_64K_BUFFER

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.B  #2,8(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    CLR.B   9(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.L  #_Global_STR_RS232_RECEIVE_HANDLER,10(A0)

    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_RBF,A0
    MOVE.L  _Global_REF_INTB_RBF_64K_BUFFER,14(A0)

    LEA     _ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt(PC),A0
    MOVEA.L _Global_REF_INTERRUPT_STRUCT_INTB_RBF,A1

    ; Setup IntVector on INTB_RBF (interrupt 11 aka "serial port recieve buffer full") pointing to 18(A1)
    MOVE.L  A0,18(A1)
    MOVEQ   #INTB_RBF,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  D0,_Global_REF_INTB_RBF_INTERRUPT
    RTS

;!======