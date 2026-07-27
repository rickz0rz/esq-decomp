    XDEF    _ESQ_StoreCtrlSampleEntry


; Rename this file to its proper purpose.

;------------------------------------------------------------------------------
; FUNC: _ESQ_StoreCtrlSampleEntry   (StoreCtrlSampleEntryuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, A0-A1
; CALLS:
;   (none)
; READS:
;   _CTRL_SampleEntryScratch, _ED_StateRingWriteIndex
; WRITES:
;   _ED_StateRingTable, _ED_StateRingWriteIndex
; DESC:
;   Copies a null-terminated byte sequence from _CTRL_SampleEntryScratch into the current
;   5-byte slot of _ED_StateRingTable, then advances the slot index.
; NOTES:
;   Slot index wraps at 20 entries. Entry size includes the terminator.
;------------------------------------------------------------------------------
_ESQ_StoreCtrlSampleEntry:
    MOVEM.L D0-D1/A0-A1,-(A7)

    LEA     _ED_StateRingTable,A0
    MOVE.L  _ED_StateRingWriteIndex,D0
    MOVE.W  D0,D1
    MULS    #5,D1
    ADDA.W  D1,A0
    LEA     _CTRL_SampleEntryScratch,A1

.lab_0051:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .lab_0051

    ADDQ.L  #1,D0
    MOVEQ   #20,D1
    CMP.L   D1,D0
    BLT.S   .return

    MOVEQ   #0,D0

.return:
    MOVE.L  D0,_ED_StateRingWriteIndex
    MOVEM.L (A7)+,D0-D1/A0-A1
    RTS

;!======