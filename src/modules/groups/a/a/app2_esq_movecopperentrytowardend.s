    XDEF    _ESQ_MoveCopperEntryTowardEnd


;------------------------------------------------------------------------------
; FUNC: _ESQ_MoveCopperEntryTowardEnd   (MoveCopperEntryTowardEnduncertain)
; ARGS:
;   stack +4: srcIndex (entry index, masked to 0..31)
;   stack +8: dstIndex (entry index, masked to 0..31)
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   _ESQ_CopperStatusDigitsA, _ESQ_CopperStatusDigitsB
; WRITES:
;   _ESQ_CopperStatusDigitsA, _ESQ_CopperStatusDigitsB
; DESC:
;   Moves an entry toward the end of the table by shifting intervening
;   entries up and inserting the original value at dstIndex.
; NOTES:
;   Table entries are 4 bytes wide; the secondary table mirrors part of the range.
;------------------------------------------------------------------------------
_ESQ_MoveCopperEntryTowardEnd:
    MOVE.L  4(A7),D1
    MOVE.L  8(A7),D0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  D0,D2
    ANDI.W  #$1f,D2
    ANDI.W  #$1f,D1
    LSL.W   #2,D1
    LSL.W   #2,D2
    LEA     _ESQ_CopperStatusDigitsA,A1
    LEA     _ESQ_CopperStatusDigitsB,A0
    ADDI.W  #0,D1
    ADDI.W  #0,D2
    MOVE.W  #$20,D4
    MOVEQ   #4,D3
    ADD.W   D1,D3
    MOVE.W  0(A1,D1.W),D0

.shift_up_loop:
    CMP.W   D2,D1
    BPL.W   .insert_entry

    MOVE.W  0(A1,D3.W),0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .copy_secondary_if_in_range

    MOVE.W  0(A1,D3.W),0(A0,D1.W)

.copy_secondary_if_in_range:
    ADDI.W  #4,D1
    ADDI.W  #4,D3
    BRA.S   .shift_up_loop

.insert_entry:
    MOVE.W  D0,0(A1,D1.W)
    CMP.W   D4,D1
    BPL.W   .return

    MOVE.W  D0,0(A0,D1.W)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======