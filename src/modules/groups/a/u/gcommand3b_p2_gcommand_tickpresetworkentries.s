    XDEF    _GCOMMAND_TickPresetWorkEntries



;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_TickPresetWorkEntries   (Advance and clamp preset work-entry accumulators)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_PresetWorkEntryTable.._GCOMMAND_PresetWorkEntry3
; WRITES:
;   _GCOMMAND_PresetWorkEntryTable.._GCOMMAND_PresetWorkEntry3
; DESC:
;   Advances preset work entry accumulators and clamps them to bounds.
; NOTES:
;   Accumulator 16(A0) uses 1000 as the carry threshold.
;------------------------------------------------------------------------------
_GCOMMAND_TickPresetWorkEntries:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7
    MOVE.L  #_GCOMMAND_PresetWorkEntryTable,-4(A5)

.entry_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVEA.L -4(A5),A0
    TST.L   20(A0)
    BEQ.S   .maybe_advance

    SUBQ.L  #1,20(A0)
    BRA.S   .next_entry

.maybe_advance:
    MOVE.L  12(A0),D0
    TST.L   D0
    BLE.S   .next_entry

    MOVE.L  8(A0),D1
    CMP.L   4(A0),D1
    BGE.S   .next_entry

    ADD.L   D0,16(A0)

.carry_loop:
    MOVEA.L -4(A5),A0
    MOVE.L  16(A0),D0
    CMPI.L  #1000,D0
    BLT.S   .check_bounds

    ADDQ.L  #1,8(A0)
    SUBI.L  #1000,16(A0)
    BRA.S   .carry_loop

.check_bounds:
    MOVEA.L -4(A5),A0
    MOVE.L  4(A0),D0
    MOVE.L  8(A0),D1
    CMP.L   D0,D1
    BLE.S   .next_entry

    CLR.L   12(A0)
    MOVE.L  4(A0),8(A0)

.next_entry:
    ADDQ.L  #1,D7
    MOVEQ   #24,D0
    ADD.L   D0,-4(A5)
    BRA.S   .entry_loop

.done:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======