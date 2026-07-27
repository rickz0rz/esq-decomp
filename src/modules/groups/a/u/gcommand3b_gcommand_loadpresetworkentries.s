    XDEF    _GCOMMAND_LoadPresetWorkEntries

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_LoadPresetWorkEntries   (Seed all preset work entries from message/record payload)
; ARGS:
;   stack +4: presetRecord
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0, A3
; CALLS:
;   _GCOMMAND_InitPresetWorkEntry
; READS:
;   32(A3), 36(A3), 55(A3)
; WRITES:
;   _GCOMMAND_PresetWorkEntryTable..GCOMMAND_PresetWorkEntry3
; DESC:
;   Seeds the preset work tables using the current preset record fields.
; NOTES:
;   Writes four entries into the _GCOMMAND_PresetWorkEntryTable block (stride 24 bytes).
;------------------------------------------------------------------------------
_GCOMMAND_LoadPresetWorkEntries:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    MOVEQ   #24,D1
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    LEA     _GCOMMAND_PresetWorkEntryTable,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.B  55(A3,D7.L),D0
    MOVE.L  D7,D1
    ASL.L   #2,D1
    MOVE.L  36(A3,D1.L),-(A7)
    MOVE.L  32(A3),-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    LEA     16(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .entry_loop

.done:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======