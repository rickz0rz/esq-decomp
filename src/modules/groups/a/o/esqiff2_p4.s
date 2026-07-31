    XDEF    _ESQIFF2_ClearPrimaryEntryFlags34To39
    XDEF    ESQIFF2_ClearPrimaryEntryFlags34To39_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ClearPrimaryEntryFlags34To39   (Clear primary entry flag bytes 34..39)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Iterates primary entries and clears six contiguous per-entry flag bytes
;   at offsets 34 through 39.
; NOTES:
;   Inner loop runs 6 iterations per primary entry.
;------------------------------------------------------------------------------
_ESQIFF2_ClearPrimaryEntryFlags34To39:
    LINK.W  A5,#-8
    MOVEM.L D6-D7,-(A7)
    MOVEQ   #0,D7

.lab_0B30:
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.W   D0,D7
    BGE.S   ESQIFF2_ClearPrimaryEntryFlags34To39_Return

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D6

.lab_0B31:
    MOVEQ   #6,D0
    CMP.W   D0,D6
    BGE.S   .lab_0B32

    MOVEA.L -4(A5),A0
    CLR.B   34(A0,D6.W)
    ADDQ.W  #1,D6
    BRA.S   .lab_0B31

.lab_0B32:
    ADDQ.W  #1,D7
    BRA.S   .lab_0B30

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ClearPrimaryEntryFlags34To39_Return   (Return tail for primary flag-clear helper)
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
;   Restores D6-D7/frame and returns from flag-clear helper.
; NOTES:
;   Shared return after outer loop completes.
;------------------------------------------------------------------------------
ESQIFF2_ClearPrimaryEntryFlags34To39_Return:
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
