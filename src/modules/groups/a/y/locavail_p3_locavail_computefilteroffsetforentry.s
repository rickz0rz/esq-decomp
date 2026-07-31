    XDEF    _LOCAVAIL_ComputeFilterOffsetForEntry
    XDEF    LOCAVAIL_ComputeFilterOffsetForEntry_Return



;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_ComputeFilterOffsetForEntry   (Routine at _LOCAVAIL_ComputeFilterOffsetForEntry)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +24: arg_5 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _GROUP_AS_JMPTBL_STR_FindCharPtr, _GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask, _LOCAVAIL_MapFilterTokenCharToClass, _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   LOCAVAIL_ComputeFilterOffsetForEntry_Return, _ESQIFF_GAdsBrushListCount, _ED_DiagGraphModeChar, _ED_DiagVinModeChar, _LOCAVAIL_FilterStep, _LOCAVAIL_FilterPrevClassId, _LOCAVAIL_STR_YYLLZ_FilterGateCheck, _WDISP_HighlightActive, lab_0F3E, lab_0F43, lab_0F4B
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LOCAVAIL_ComputeFilterOffsetForEntry:
    LINK.W  A5,#-28
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    CLR.L   -28(A5)
    MOVE.L  D0,-20(A5)
    TST.L   _LOCAVAIL_FilterStep
    BNE.W   LOCAVAIL_ComputeFilterOffsetForEntry_Return

    CMP.L   _LOCAVAIL_FilterPrevClassId,D0
    BNE.W   LOCAVAIL_ComputeFilterOffsetForEntry_Return

    MOVEQ   #0,D7

.lab_0F3E:
    TST.B   (A3)
    BEQ.W   .lab_0F43

    MOVE.B  (A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _LOCAVAIL_MapFilterTokenCharToClass

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    CLR.L   -24(A5)
    MOVEQ   #0,D6

.lab_0F3F:
    TST.L   D5
    BEQ.S   .lab_0F41

    CMP.L   2(A2),D6
    BGE.S   .lab_0F41

    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    CMP.L   D1,D0
    BNE.S   .lab_0F40

    MOVE.L  6(A0),-28(A5)
    MOVE.L  A0,-24(A5)
    BRA.S   .lab_0F41

.lab_0F40:
    ADDQ.L  #1,D6
    BRA.S   .lab_0F3F

.lab_0F41:
    TST.L   D5
    BEQ.S   .lab_0F42

    TST.L   -24(A5)
    BEQ.S   .lab_0F42

    SUBQ.L  #1,D5
    MOVEA.L -24(A5),A0
    MOVE.W  4(A0),D0
    EXT.L   D0
    CMP.L   D0,D5
    BGE.S   .lab_0F42

    MOVEA.L -28(A5),A0
    TST.B   0(A0,D5.L)
    BEQ.S   .lab_0F42

    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .lab_0F43

    CMP.L   -20(A5),D0
    BNE.S   .lab_0F43

    MOVE.L  D6,D4
    MOVE.L  D5,-20(A5)
    BRA.S   .lab_0F43

.lab_0F42:
    ADDQ.L  #1,D7
    ADDQ.L  #1,A3
    BRA.W   .lab_0F3E

.lab_0F43:
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BEQ.W   .lab_0F4B

    MOVE.L  -20(A5),D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.W   .lab_0F4B

    MOVE.L  D4,D0
    MOVEQ   #10,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L 20(A2),A0
    ADDA.L  D0,A0
    MOVEA.L 6(A0),A1
    MOVEQ   #0,D0
    MOVE.L  -20(A5),D1
    MOVE.B  0(A1,D1.L),D0
    MOVE.L  A0,-24(A5)
    MOVE.L  A1,-28(A5)
    SUBQ.W  #1,D0
    BEQ.S   .lab_0F44

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F46

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F48

    SUBQ.W  #1,D0
    BEQ.S   .lab_0F49

    BRA.S   .lab_0F4A

.lab_0F44:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     _LOCAVAIL_STR_YYLLZ_FilterGateCheck
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .lab_0F45

    JSR     _GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BNE.S   .lab_0F4B

.lab_0F45:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F46:
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0F47

    TST.L   _ESQIFF_GAdsBrushListCount
    BNE.S   .lab_0F4B

.lab_0F47:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F48:
    TST.W   _WDISP_HighlightActive
    BNE.S   .lab_0F4B

    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F49:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)
    BRA.S   .lab_0F4B

.lab_0F4A:
    MOVEQ   #-1,D4
    MOVEQ   #-1,D0
    MOVE.L  D0,-20(A5)

.lab_0F4B:
    MOVE.L  D4,8(A2)
    MOVE.L  -20(A5),12(A2)

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_ComputeFilterOffsetForEntry_Return   (Return tail for filter-offset computation)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Restores saved registers/frame and returns to caller.
; NOTES:
;   Shared exit for early-reject and computed-offset paths.
;------------------------------------------------------------------------------
LOCAVAIL_ComputeFilterOffsetForEntry_Return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======