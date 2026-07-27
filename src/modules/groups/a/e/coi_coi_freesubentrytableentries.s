    XDEF    _COI_FreeSubEntryTableEntries
    XDEF    COI_FreeSubEntryTableEntries_Return


;------------------------------------------------------------------------------
; FUNC: _COI_FreeSubEntryTableEntries   (Routine at _COI_FreeSubEntryTableEntries)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0/D7
; CALLS:
;   _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString, _GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_COI_C_4, COI_FreeSubEntryTableEntries_Return
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_COI_FreeSubEntryTableEntries:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    TST.L   8(A5)
    BEQ.S   .lab_02D6

    MOVEA.L 8(A5),A1
    MOVEA.L 48(A1),A0
    BRA.S   .lab_02D7

.lab_02D6:
    SUBA.L  A0,A0

.lab_02D7:
    MOVEA.L A0,A3
    MOVE.L  A3,D0
    BEQ.W   COI_FreeSubEntryTableEntries_Return

    MOVEQ   #0,D7

.lab_02D8:
    CMP.W   36(A3),D7
    BGE.S   .lab_02D9

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L 38(A3),A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    CLR.W   (A2)
    MOVE.L  2(A2),-(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,2(A2)
    MOVE.L  6(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,6(A2)
    MOVE.L  10(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,10(A2)
    MOVE.L  14(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,14(A2)
    MOVE.L  18(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,18(A2)
    MOVE.L  22(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     28(A7),A7
    MOVE.L  D0,22(A2)
    CLR.L   26(A2)
    ADDQ.W  #1,D7
    BRA.S   .lab_02D8

.lab_02D9:
    TST.W   36(A3)
    BEQ.S   .lab_02DA

    MOVE.W  36(A3),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     30.W
    MOVE.L  38(A3),-(A7)
    JSR     _GROUP_AE_JMPTBL_SCRIPT_DeallocateBufferArray(PC)

    MOVE.W  36(A3),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  D0,(A7)
    MOVE.L  38(A3),-(A7)
    PEA     876.W
    PEA     _Global_STR_COI_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7

.lab_02DA:
    CLR.W   36(A3)
    CLR.L   38(A3)

;------------------------------------------------------------------------------
; FUNC: COI_FreeSubEntryTableEntries_Return   (Routine at COI_FreeSubEntryTableEntries_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_FreeSubEntryTableEntries_Return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======