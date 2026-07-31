    XDEF    _GCOMMAND_ResetPresetWorkTables

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ResetPresetWorkTables   (Clear preset work-entry table and pending flag)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   _GCOMMAND_PresetWorkEntryTable.._GCOMMAND_PresetWorkEntry3, _GCOMMAND_PresetWorkResetPendingFlag
; DESC:
;   Clears the preset work tables and resets the pending flag.
; NOTES:
;   Each table entry is 24 bytes; the first longword is set to index+4.
;------------------------------------------------------------------------------
_GCOMMAND_ResetPresetWorkTables:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7
    MOVE.L  #_GCOMMAND_PresetWorkEntryTable,-8(A5)

.entry_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    ADDQ.L  #4,D0
    MOVEA.L -8(A5),A0
    MOVE.L  D0,(A0)
    MOVEQ   #0,D0
    MOVE.L  D0,4(A0)
    MOVE.L  D0,8(A0)
    MOVE.L  D0,12(A0)
    MOVE.L  D0,16(A0)
    ADDQ.L  #1,D7
    MOVEQ   #24,D0
    ADD.L   D0,-8(A5)
    BRA.S   .entry_loop

.done:
    CLR.W   _GCOMMAND_PresetWorkResetPendingFlag
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======