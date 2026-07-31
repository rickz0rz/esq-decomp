    XDEF    _ESQIFF2_ValidateFieldIndexAndLength
    XDEF    ESQIFF2_ValidateFieldIndexAndLength_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ValidateFieldIndexAndLength   (Validate group-record field index/length bounds)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D6/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Validates parser field index (0..3) and per-field text length bounds.
; NOTES:
;   Field index 1 allows up to 10 chars; all other fields allow up to 7.
;------------------------------------------------------------------------------
_ESQIFF2_ValidateFieldIndexAndLength:
    MOVEM.L D6-D7,-(A7)
    MOVE.W  14(A7),D7
    MOVE.W  18(A7),D6
    MOVEQ   #3,D0
    CMP.W   D0,D7
    BLE.S   .validate_field_length_bound

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.validate_field_length_bound:
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BNE.S   .validate_non_field1_length

    MOVEQ   #10,D0
    CMP.W   D0,D6
    BLE.S   .return_valid_field_bounds

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.validate_non_field1_length:
    MOVEQ   #7,D0
    CMP.W   D0,D6
    BLE.S   .return_valid_field_bounds

    MOVEQ   #0,D0
    BRA.S   ESQIFF2_ValidateFieldIndexAndLength_Return

.return_valid_field_bounds:
    MOVEQ   #1,D0

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ValidateFieldIndexAndLength_Return   (Return tail for field index/length validator)
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
;   Restores D6-D7 and returns validation result in D0.
; NOTES:
;   Shared tail for all bounds-check branches.
;------------------------------------------------------------------------------
ESQIFF2_ValidateFieldIndexAndLength_Return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======