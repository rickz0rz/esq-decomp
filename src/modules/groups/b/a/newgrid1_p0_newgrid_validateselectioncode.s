    XDEF    _NEWGRID_ValidateSelectionCode


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ValidateSelectionCode   (Validate selection code against flags)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: D7 = selection code
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   none
; READS:
;   _CONFIG_NewgridSelectionCode16EnabledFlag, _CONFIG_NewgridSelectionCode32EnabledFlag, _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,
;   _CONFIG_NewgridSelectionCode34AltEnabledFlag, _CONFIG_NewgridSelectionCode35EnabledFlag, _CONFIG_NewgridSelectionCode48_49EnabledFlag,
;   _GCOMMAND_DigitalNicheEnabledFlag
; WRITES:
;   54(A3)
; DESC:
;   Validates a selection code against feature flags and updates the active
;   selection byte when allowed.
; NOTES:
;   Long chain of comparisons over coded ranges.
;------------------------------------------------------------------------------
_NEWGRID_ValidateSelectionCode:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVEQ   #0,D0
    MOVE.B  54(A3),D0
    CMP.L   D7,D0
    BGE.W   .maybe_keep_or_clear_zero

    MOVE.L  D7,D0
    MOVEQ   #16,D1
    SUB.L   D1,D0
    BEQ.S   .case_16

    MOVEQ   #16,D1
    SUB.L   D1,D0
    BEQ.W   .case_32

    SUBQ.L  #1,D0
    BEQ.W   .case_33

    SUBQ.L  #1,D0
    BEQ.W   .case_34

    SUBQ.L  #1,D0
    BEQ.W   .case_35

    SUBQ.L  #1,D0
    BEQ.W   .case_36

    SUBQ.L  #1,D0
    BEQ.W   .case_37

    MOVEQ   #11,D1
    SUB.L   D1,D0
    BEQ.S   .case_48

    SUBQ.L  #1,D0
    BEQ.W   .case_49

    SUBQ.L  #1,D0
    BEQ.W   .case_34

    SUBQ.L  #1,D0
    BEQ.W   .case_35

    SUBQ.L  #1,D0
    BEQ.W   .case_36

    SUBQ.L  #1,D0
    BEQ.W   .case_37

    MOVEQ   #11,D1
    SUB.L   D1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    SUBQ.L  #1,D0
    BEQ.W   .case_64

    BRA.W   .clear_active_selection

.case_16:
    MOVE.B  _CONFIG_NewgridSelectionCode16EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_32:
    MOVE.B  _CONFIG_NewgridSelectionCode32EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_48:
    MOVE.B  _CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_33:
    MOVE.B  _GCOMMAND_DigitalNicheEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.W   .return_selection_validation

.case_49:
    MOVE.B  _CONFIG_NewgridSelectionCode48_49EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return_selection_validation

    MOVE.B  _GCOMMAND_DigitalNicheEnabledFlag,D0
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_34:
    MOVE.B  _CONFIG_NewgridSelectionCode34PrimaryEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .case_34_alt

    MOVE.B  _CONFIG_NewgridSelectionCode34AltEnabledFlag,D0
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

.case_34_alt:
    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_35:
    MOVE.B  _CONFIG_NewgridSelectionCode35EnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_36:
    MOVE.B  _GCOMMAND_DigitalMplexEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_37:
    MOVE.B  _GCOMMAND_DigitalPpvEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.case_64:
    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)
    BRA.S   .return_selection_validation

.clear_active_selection:
    CLR.B   54(A3)
    BRA.S   .return_selection_validation

.maybe_keep_or_clear_zero:
    TST.L   D7
    BNE.S   .return_selection_validation

    MOVE.L  D7,D0
    MOVE.B  D0,54(A3)

.return_selection_validation:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======