    XDEF    _NEWGRID_FindNextEntryWithAltMarkers
    XDEF    NEWGRID_FindNextEntryWithMarkers
    XDEF    NEWGRID_ProcessAltEntryState


;------------------------------------------------------------------------------
; FUNC: NEWGRID_FindNextEntryWithMarkers   (Find next entry meeting marker criteria)
; ARGS:
;   stack +8: D7 = scan mode selector (`0=reset`, `4=start+1`; others invalid)
;   stack +12: D6 = start index (entry scan cursor)
;   stack +18: D5 = selector/column offset used in metadata lookups
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID_ShouldOpenEditor
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans forward and returns the first entry that passes a stricter compound
;   eligibility gate than `_NEWGRID_FindNextEntryWithFlags`: entry flag bits,
;   marker-bitset test, editor-open veto, selector metadata bits, and payload ptr.
; NOTES:
;   Uses both entry record and selector metadata table pointers produced by
;   `NEWGRID_UpdatePresetEntry`.
;   The aux pointer is treated as a selector-indexed record where
;   `56 + (selector*4)` stores a text/source pointer used by downstream
;   rendering/selection routines.
;   Returns `-1` when no entry satisfies all gates.
;   Uses entry fields in `A0+46`, `A0+40`, `A0+27`, `A0+56` (names unknown).
;------------------------------------------------------------------------------
NEWGRID_FindNextEntryWithMarkers:
    LINK.W  A5,#-12
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.W  18(A5),D5
    MOVEQ   #0,D4
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_reset

    SUBQ.L  #4,D0
    BEQ.S   .case_increment

    BRA.S   .set_invalid

.case_reset:
    MOVEQ   #0,D6
    BRA.S   .check_loop

.case_increment:
    ADDQ.L  #1,D6
    BRA.S   .check_loop

.set_invalid:
    MOVEQ   #1,D4

.check_loop:
    TST.L   D4
    BNE.W   .return

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .return

.scan_loop:
    TST.L   D4
    BNE.W   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .scan_done

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -8(A5)
    PEA     -4(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    TST.L   -4(A5)                        ; local ptr A: entry record ptr (from NEWGRID_UpdatePresetEntry out0)
    BEQ.W   .advance_index

    TST.L   -8(A5)                        ; local ptr B: entry aux/selector-metadata ptr (from NEWGRID_UpdatePresetEntry out1)
    BEQ.S   .advance_index

    MOVEA.L -4(A5),A0
    MOVE.W  Struct_PrimaryEntry__StateFlagsWord(A0),D0           ; A0+46 = entry state flags word
    BTST    #1,D0
    BEQ.S   .advance_index

    MOVE.B  Struct_PrimaryEntry__MarkerStatusByte(A0),D0         ; A0+40 = entry marker/status byte
    BTST    #7,D0
    BEQ.S   .advance_index

    LEA     Struct_PrimaryEntry__SelectionBitsetBase(A0),A1      ; A0+28 = marker bitset base for _ESQ_TestBit1Based
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .advance_index

    MOVE.L  -4(A5),-(A7)
    JSR     _NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .advance_index

    MOVEA.L -8(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1                         ; selector-specific metadata offset
    BTST    #1,Struct_TitleAuxRecord__SelectorFlagsByteBase(A1)  ; A1+7 = selector flags byte (bit1 alters alt-flag gate)
    BNE.S   .check_alt_flags

    MOVEA.L -4(A5),A1
    MOVE.B  Struct_PrimaryEntry__EditorFlagsByte(A1),D0          ; A1+27 = entry flags byte (bit4 required when selector bit1 clear)
    BTST    #4,D0
    BEQ.S   .advance_index

.check_alt_flags:
    MOVEA.L A0,A1
    ADDA.W  D5,A1                         ; selector-specific metadata offset
    BTST    #7,Struct_TitleAuxRecord__SelectorFlagsByteBase(A1)  ; A1+7 = selector flags byte (bit7 blocks candidate)
    BNE.S   .advance_index

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   Struct_TitleAuxRecord__SelectorTextPtrBase(A0)       ; A0+56 = selector text/source pointer slot must be non-null
    BEQ.S   .advance_index

    MOVEQ   #1,D4
    BRA.W   .scan_loop

.advance_index:
    ADDQ.L  #1,D6
    BRA.W   .scan_loop

.scan_done:
    TST.L   D4
    BNE.S   .return

    MOVEQ   #-1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessAltEntryState   (Process alternate entry state)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = row index
;   stack +16: D6 = selector value
; RET:
;   D0: state (NEWGRID_AltEntryWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_HandleAltGridState, NEWGRID_FindNextEntryWithMarkers,
;   NEWGRID_DrawEmptyGridMessage, _NEWGRID_ValidateSelectionCode,
;   _NEWGRID_GetGridModeIndex, _NEWGRID_ComputeColumnIndex
; READS:
;   NEWGRID_AltEntryAttemptCounter/2026/2027, CONFIG_NewgridSelectionCode35EnabledFlag
; WRITES:
;   NEWGRID_AltEntryAttemptCounter/2026/2027
; DESC:
;   State machine wrapper around alternate grid entry handling.
; NOTES:
;   Uses a switch/jumptable for state dispatch.
;------------------------------------------------------------------------------
NEWGRID_ProcessAltEntryState:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.W  30(A7),D6
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BNE.S   .dispatch_workflow_state

    MOVEQ   #5,D0
    CMP.L   NEWGRID_AltEntryWorkflowState,D0
    BNE.S   .legacy_nullctx_reset_state

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleAltGridState

    LEA     12(A7),A7

.legacy_nullctx_reset_state:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    MOVE.L  D0,NEWGRID_AltEntryCursor
    BRA.W   .return_state

.dispatch_workflow_state:
    MOVE.L  NEWGRID_AltEntryWorkflowState,D0
    CMPI.L  #$6,D0
    BCC.W   .clear_workflow_state

    ADD.W   D0,D0
    MOVE.W  .state_jumptable(PC,D0.W),D0
    JMP     .state_jumptable+2(PC,D0.W)

; switch/jumptable
.state_jumptable:
    DC.W    .case_state0-.state_jumptable-2
    DC.W    .case_state1_draw_empty-.state_jumptable-2
    DC.W    .clear_workflow_state-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state3_or4-.state_jumptable-2
    DC.W    .case_state5-.state_jumptable-2

.case_state0:
    CLR.L   NEWGRID_AltEntryAttemptCounter
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_AltEntryCursor,-(A7)
    MOVE.L  NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVE.L  D0,NEWGRID_AltEntryCursor
    ADDQ.L  #1,D0
    BEQ.W   .return_state

    MOVEQ   #1,D0
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState

.case_state1_draw_empty:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawEmptyGridMessage

    LEA     12(A7),A7
    MOVEQ   #3,D0
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    BRA.W   .return_state

.case_state3_or4:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_AltEntryCursor,-(A7)
    MOVE.L  NEWGRID_AltEntryWorkflowState,-(A7)
    BSR.W   NEWGRID_FindNextEntryWithMarkers

    LEA     12(A7),A7
    MOVEQ   #1,D5
    MOVE.L  D0,NEWGRID_AltEntryCursor

.case_state5:
    MOVE.L  NEWGRID_AltEntryCursor,D0
    MOVEQ   #-1,D1
    CMP.L   D1,D0
    BEQ.S   .clear_workflow_state

    MOVE.L  D7,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_HandleAltGridState

    LEA     12(A7),A7
    MOVE.B  CONFIG_NewgridSelectionCode35EnabledFlag,D1
    MOVE.L  D0,NEWGRID_AltEntryWorkflowState
    MOVEQ   #89,D0
    CMP.B   D0,D1
    BNE.S   .return_state

    TST.L   D5
    BEQ.S   .update_column_adjust

    CMPI.L  #$1,NEWGRID_AltEntryAttemptCounter
    BGE.S   .update_column_adjust

    PEA     51.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    BSR.W   _NEWGRID_GetGridModeIndex

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_AltEntryAttemptCounter

.update_column_adjust:
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ComputeColumnIndex

    ADDQ.W  #4,A7
    SUB.L   D0,NEWGRID_AltEntryAttemptCounter
    BRA.S   .return_state

.clear_workflow_state:
    CLR.L   NEWGRID_AltEntryWorkflowState

.return_state:
    MOVE.L  NEWGRID_AltEntryWorkflowState,D0
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_FindNextEntryWithAltMarkers   (Find next entry with alt markers)
; ARGS:
;   stack +8: D7 = scan mode selector (`0=reset`, `4=start+1`, `6=keep start`; others invalid)
;   stack +12: D6 = start index (entry scan cursor)
;   stack +18: D5 = preset/column selector offset added into per-entry metadata
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   NEWGRID_UpdatePresetEntry, NEWGRID2_JMPTBL_ESQ_TestBit1Based
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans forward through primary entries and returns the first row whose entry
;   passes a compound eligibility gate: entry flags, marker-bit test result,
;   per-selector metadata bit test, and non-null row payload pointer.
; NOTES:
;   `NEWGRID_UpdatePresetEntry` materializes two pointers used for validation:
;   one to entry data and one to per-entry selector metadata.
;   The aux pointer is treated as a selector-indexed record where
;   `56 + (selector*4)` stores a text/source pointer required by consumers.
;   Scan ends when count/presence gates fail or when a qualifying entry is found.
;   If no entry matches, returns `-1`.
;   Uses entry fields `A0+46` (flags word) and `A0+40` (marker/status byte).
;------------------------------------------------------------------------------
_NEWGRID_FindNextEntryWithAltMarkers:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.W  18(A5),D5
    MOVEQ   #0,D4
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_reset

    SUBQ.L  #4,D0
    BEQ.S   .case_increment

    SUBQ.L  #2,D0
    BNE.S   .set_invalid

.case_reset:
    MOVEQ   #0,D6
    BRA.S   .check_loop

.case_increment:
    ADDQ.L  #1,D6
    BRA.S   .check_loop

.set_invalid:
    MOVEQ   #1,D4

.check_loop:
    TST.L   D4
    BNE.W   .return

.scan_loop:
    TST.L   D4
    BNE.W   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .scan_done

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.W   .scan_done

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -14(A5)
    PEA     -10(A5)
    BSR.W   NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.W  D0,-6(A5)                     ; local cached entry index from NEWGRID_UpdatePresetEntry
    TST.L   -10(A5)                       ; local ptr A: entry record ptr (from NEWGRID_UpdatePresetEntry out0)
    BEQ.S   .advance_index

    TST.L   -14(A5)                       ; local ptr B: entry aux/selector-metadata ptr (from NEWGRID_UpdatePresetEntry out1)
    BEQ.S   .advance_index

    MOVEA.L -10(A5),A0
    MOVE.W  Struct_PrimaryEntry__StateFlagsWord(A0),D0           ; A0+46 = entry state flags word
    BTST    #3,D0
    BEQ.S   .advance_index

    MOVE.B  Struct_PrimaryEntry__MarkerStatusByte(A0),D0         ; A0+40 = entry marker/status byte
    BTST    #7,D0
    BEQ.S   .advance_index

    LEA     Struct_PrimaryEntry__SelectionBitsetBase(A0),A1      ; A0+28 = marker bitset base used by _ESQ_TestBit1Based
    MOVE.W  -6(A5),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    JSR     NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .advance_index

    MOVEA.L -14(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D5,A1                         ; selector-specific metadata byte offset
    BTST    #7,Struct_TitleAuxRecord__SelectorFlagsByteBase(A1)  ; A1+7 = selector flag byte (bit7 blocks candidate)
    BNE.S   .advance_index

    MOVE.W  -6(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    TST.L   Struct_TitleAuxRecord__SelectorTextPtrBase(A0)       ; A0+56 = selector text/source pointer slot must be non-null
    BEQ.S   .advance_index

    MOVEQ   #1,D4
    BRA.W   .scan_loop

.advance_index:
    ADDQ.L  #1,D6
    BRA.W   .scan_loop

.scan_done:
    TST.L   D4
    BNE.S   .return

    MOVEQ   #-1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======