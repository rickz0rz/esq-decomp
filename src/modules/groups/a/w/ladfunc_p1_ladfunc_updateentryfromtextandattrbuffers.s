    XDEF    _LADFUNC_UpdateEntryFromTextAndAttrBuffers
    XDEF    LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_UpdateEntryFromTextAndAttrBuffers   (Routine at _LADFUNC_UpdateEntryFromTextAndAttrBuffers)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   _ESQPARS_ReplaceOwnedString, _LADFUNC_RepackEntryTextAndAttrBuffers, _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _Global_STR_LADFUNC_C_28, _Global_STR_LADFUNC_C_29, _Global_STR_LADFUNC_C_30, LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return, _LADFUNC_EntryPtrTable, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LADFUNC_UpdateEntryFromTextAndAttrBuffers:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3/A6,-(A7)
    MOVE.L  36(A7),D7
    MOVEA.L 40(A7),A3
    MOVEA.L 44(A7),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _LADFUNC_RepackEntryTextAndAttrBuffers

    ADDQ.W  #8,A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BNE.S   .lab_0EDC

    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     14.W
    PEA     1362.W
    PEA     _Global_STR_LADFUNC_C_28
    MOVE.L  A0,36(A7)
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   .lab_0EDC

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    MOVEQ   #0,D1
    MOVE.W  D1,(A6)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    MOVE.W  D1,2(A6)

.lab_0EDC:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   6(A6)
    BEQ.S   .lab_0EDE

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

.lab_0EDD:
    TST.B   (A0)+
    BNE.S   .lab_0EDD

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    BRA.S   .lab_0EDF

.lab_0EDE:
    MOVEQ   #0,D6

.lab_0EDF:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A6,32(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,6(A0)
    TST.L   D6
    BEQ.S   .lab_0EE0

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   10(A6)
    BEQ.S   .lab_0EE0

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     1386.W
    PEA     _Global_STR_LADFUNC_C_29
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.lab_0EE0:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

.lab_0EE1:
    TST.B   (A0)+
    BNE.S   .lab_0EE1

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D6,-(A7)
    PEA     1389.W
    PEA     _Global_STR_LADFUNC_C_30
    MOVE.L  A1,36(A7)
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,10(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   10(A6)
    BEQ.S   LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    MOVEA.L A2,A0
    MOVEA.L 10(A1),A6
    BRA.S   .lab_0EE3

.lab_0EE2:
    MOVE.B  (A0)+,(A6)+

.lab_0EE3:
    SUBQ.L  #1,D0
    BCC.S   .lab_0EE2

;------------------------------------------------------------------------------
; FUNC: LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return   (Routine at LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
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
LADFUNC_UpdateEntryFromTextAndAttrBuffers_Return:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======