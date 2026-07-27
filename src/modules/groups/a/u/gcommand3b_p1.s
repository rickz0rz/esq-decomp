    XDEF    _GCOMMAND_InitPresetWorkEntry
    XDEF    GCOMMAND_ResetPresetWorkTables
    XDEF    GCOMMAND_UpdatePresetEntryCache
    XDEF    GCOMMAND_UpdatePresetEntryCache_Return

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdatePresetEntryCache   (Populate cached preset deltas for one preset record)
; ARGS:
;   stack +4: presetRecord (struct pointer)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   _GCOMMAND_ComputePresetIncrement
; READS:
;   32(A3), 36(A3), 55(A3)
; WRITES:
;   36(A3)..
; DESC:
;   Computes four cached values from presetRecord fields via _GCOMMAND_ComputePresetIncrement.
; NOTES:
;   Field layout is inferred; cache is written starting at offset 36.
;------------------------------------------------------------------------------
GCOMMAND_UpdatePresetEntryCache:
    LINK.W  A5,#-16
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  32(A3),D6
    TST.L   D6
    BMI.S   GCOMMAND_UpdatePresetEntryCache_Return

    MOVEQ   #0,D7
    LEA     36(A3),A0
    LEA     55(A3),A1
    MOVE.L  A0,-8(A5)
    MOVE.L  A1,-16(A5)

.lab_0D8F:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   GCOMMAND_UpdatePresetEntryCache_Return

    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    ADDQ.W  #8,A7
    MOVEA.L -8(A5),A0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    ADDQ.L  #4,-8(A5)
    ADDQ.L  #1,-16(A5)
    BRA.S   .lab_0D8F

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdatePresetEntryCache_Return   (Routine at GCOMMAND_UpdatePresetEntryCache_Return)
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
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
GCOMMAND_UpdatePresetEntryCache_Return:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ResetPresetWorkTables   (Clear preset work-entry table and pending flag)
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
;   _GCOMMAND_PresetWorkEntryTable..GCOMMAND_PresetWorkEntry3, _GCOMMAND_PresetWorkResetPendingFlag
; DESC:
;   Clears the preset work tables and resets the pending flag.
; NOTES:
;   Each table entry is 24 bytes; the first longword is set to index+4.
;------------------------------------------------------------------------------
GCOMMAND_ResetPresetWorkTables:
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
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_InitPresetWorkEntry   (Initialize one preset work-entry state block)
; ARGS:
;   stack +4: entryPtr (work entry)
;   stack +8: presetIndex
;   stack +12: span
;   stack +16: baseValue
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0, A3
; CALLS:
;   GCOMMAND_SetPresetEntry
; READS:
;   _GCOMMAND_DefaultPresetTable
; WRITES:
;   [entryPtr]
; DESC:
;   Initializes a preset work entry based on index/span parameters.
; NOTES:
;   If index is invalid, forces entry index to 6 and updates the preset table.
;------------------------------------------------------------------------------
_GCOMMAND_InitPresetWorkEntry:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  32(A7),D5
    TST.L   D7
    BMI.S   .invalid_index

    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.S   .invalid_index

    MOVE.L  D7,(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,16(A3)
    MOVEQ   #4,D1
    CMP.L   D1,D6
    BLE.S   .span_small

    MOVE.L  D5,12(A3)
    MOVE.L  D7,D1
    ADD.L   D1,D1
    LEA     _GCOMMAND_DefaultPresetTable,A0
    ADDA.L  D1,A0
    MOVE.W  (A0),D1
    EXT.L   D1
    SUBQ.L  #1,D1
    MOVE.L  D1,4(A3)
    MOVEQ   #2,D1
    MOVE.L  D1,20(A3)
    MOVEQ   #1,D1
    MOVE.L  D1,8(A3)
    BRA.S   .done

.span_small:
    TST.L   D6
    BMI.S   .done

    MOVE.L  D0,12(A3)
    MOVE.L  D0,4(A3)
    MOVE.L  D0,20(A3)
    MOVE.L  D0,8(A3)
    BRA.S   .done

.invalid_index:
    MOVEQ   #6,D0
    MOVE.L  D0,(A3)
    MOVEQ   #0,D1
    MOVE.L  D1,16(A3)
    MOVE.L  D1,12(A3)
    MOVE.L  D1,4(A3)
    MOVE.L  D1,20(A3)
    MOVE.L  D1,8(A3)
    PEA     1365.W
    MOVE.L  D0,-(A7)
    BSR.W   GCOMMAND_SetPresetEntry

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======