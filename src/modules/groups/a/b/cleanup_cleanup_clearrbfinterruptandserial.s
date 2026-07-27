    XDEF    _CLEANUP_ClearRbfInterruptAndSerial


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_ClearRbfInterruptAndSerial
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A1/A6
; CALLS:
;   _LVOCloseDevice, _GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport, _GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField,
;   _LVOSetIntVector, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _WDISP_SerialIoRequestPtr, _WDISP_SerialMessagePortPtr, _Global_REF_INTB_RBF_INTERRUPT,
;   _Global_REF_INTB_RBF_64K_BUFFER, _Global_REF_INTERRUPT_STRUCT_INTB_RBF,
;   AbsExecBase, _Global_STR_CLEANUP_C_3, _Global_STR_CLEANUP_C_4
; WRITES:
;   INTENA
; DESC:
;   Closes the serial device, restores the INTB_RBF interrupt vector, and
;   frees the RBF interrupt buffer/structure.
; NOTES:
;   - Signals the serial msg port before closing/freeing resources.
;------------------------------------------------------------------------------
_CLEANUP_ClearRbfInterruptAndSerial:
    MOVE.W  #$800,INTENA
    MOVEA.L _WDISP_SerialIoRequestPtr,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCloseDevice(A6)

    MOVE.L  _WDISP_SerialMessagePortPtr,-(A7)
    JSR     _GROUP_AG_JMPTBL_IOSTDREQ_CleanupSignalAndMsgport(PC)

    MOVE.L  _WDISP_SerialIoRequestPtr,(A7)
    JSR     _GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(PC)

    MOVEQ   #INTB_RBF,D0
    MOVEA.L _Global_REF_INTB_RBF_INTERRUPT,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetIntVector(A6)

    MOVE.L  #64000,(A7)
    MOVE.L  _Global_REF_INTB_RBF_64K_BUFFER,-(A7)
    PEA     113.W
    PEA     _Global_STR_CLEANUP_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    PEA     22.W
    MOVE.L  _Global_REF_INTERRUPT_STRUCT_INTB_RBF,-(A7)
    PEA     118.W
    PEA     _Global_STR_CLEANUP_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     32(A7),A7

    RTS

;!======