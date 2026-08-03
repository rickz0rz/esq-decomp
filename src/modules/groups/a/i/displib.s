    XDEF    _DISPLIB_FindPreviousValidEntryIndex
    XDEF    DISPLIB_FindPreviousValidEntryIndex_Return





;------------------------------------------------------------------------------
; FUNC: _DISPLIB_FindPreviousValidEntryIndex   (Routine at _DISPLIB_FindPreviousValidEntryIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A2/A3/A7/D0/D5/D6/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   _DISPLIB_PreviousSearchWrappedFlag
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISPLIB_FindPreviousValidEntryIndex:
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 24(A7),A3
    MOVEA.L 28(A7),A2
    MOVE.L  32(A7),D7

    BTST    #5,27(A3)
    BEQ.S   .lab_054D

    MOVEQ   #48,D5
    BRA.S   .lab_054E

.lab_054D:
    MOVEQ   #7,D5

.lab_054E:
    MOVE.L  D7,D6
    SUB.L   D5,D6
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BGE.S   .branch

    MOVE.L  D0,D6

.branch:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BNE.S   DISPLIB_FindPreviousValidEntryIndex_Return

    SUBQ.L  #1,D7
    CMP.L   D6,D7
    BGE.S   .branch_1

    MOVEQ   #0,D7
    CLR.W   _DISPLIB_PreviousSearchWrappedFlag
    BRA.S   DISPLIB_FindPreviousValidEntryIndex_Return

.branch_1:
    BTST    #5,27(A3)
    BNE.S   .branch

    MOVE.W  #1,_DISPLIB_PreviousSearchWrappedFlag
    BRA.S   .branch

;------------------------------------------------------------------------------
; FUNC: DISPLIB_FindPreviousValidEntryIndex_Return   (Routine at DISPLIB_FindPreviousValidEntryIndex_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D5
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
DISPLIB_FindPreviousValidEntryIndex_Return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======