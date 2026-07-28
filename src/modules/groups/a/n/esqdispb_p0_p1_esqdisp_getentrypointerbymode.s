    XDEF    _ESQDISP_GetEntryPointerByMode



;------------------------------------------------------------------------------
; FUNC: _ESQDISP_GetEntryPointerByMode   (Get entry pointer by mode/index)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Alias documentation header; full behavior contract is defined in the
;   immediately following detailed header block.
; NOTES:
;   Preserved as entry marker before expanded ARGS/READS section.
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: _ESQDISP_GetEntryPointerByMode   (Get entry pointer by mode/index)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Returns entry pointer for index in primary mode (1) or secondary mode (2),
;   with bounds checks against each group's entry count.
; NOTES:
;   Returns NULL for out-of-range index or unsupported mode.
;------------------------------------------------------------------------------
_ESQDISP_GetEntryPointerByMode:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    CLR.L   -4(A5)

    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .lab_0924

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .return

.lab_0924:
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .return

    TST.L   D7
    BMI.S   .return

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======