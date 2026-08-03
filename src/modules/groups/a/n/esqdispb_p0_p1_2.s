    XDEF    _ESQDISP_TestEntryGridEligibility
    XDEF    ESQDISP_TestEntryGridEligibility_Return


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_TestEntryGridEligibility   (Test per-slot grid eligibility)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   fc
; WRITES:
;   (none observed)
; DESC:
;   Returns 1 when the requested slot index is valid and either entry slot bit4
;   is set or the slot value byte (base+0xFC+idx) lies in range 5..10.
; NOTES:
;   Valid slot range is 1..48; otherwise returns 0.
;------------------------------------------------------------------------------
_ESQDISP_TestEntryGridEligibility:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.W  22(A7),D7

    MOVEQ   #0,D6
    TST.W   D7
    BLE.S   ESQDISP_TestEntryGridEligibility_Return

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   ESQDISP_TestEntryGridEligibility_Return

    MOVE.L  A3,D0
    BEQ.S   ESQDISP_TestEntryGridEligibility_Return

    BTST    #4,7(A3,D7.W)
    BNE.S   .lab_091C

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$5,0(A3,D0.W)
    BCS.S   .lab_091B

    MOVE.L  D7,D0
    ADDI.W  #$fc,D0
    CMPI.B  #$a,0(A3,D0.W)
    BLS.S   .lab_091C

.lab_091B:
    MOVEQ   #0,D0
    BRA.S   .lab_091D

.lab_091C:
    MOVEQ   #1,D0

.lab_091D:
    MOVE.L  D0,D6

;------------------------------------------------------------------------------
; FUNC: ESQDISP_TestEntryGridEligibility_Return   (Return tail for grid eligibility test)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for _ESQDISP_TestEntryGridEligibility.
; NOTES:
;   Returns D6 in D0.
;------------------------------------------------------------------------------
ESQDISP_TestEntryGridEligibility_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======