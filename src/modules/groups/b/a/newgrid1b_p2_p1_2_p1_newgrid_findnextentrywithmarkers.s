    XDEF    _NEWGRID_FindNextEntryWithMarkers



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_FindNextEntryWithMarkers   (Find next entry meeting marker criteria)
; ARGS:
;   stack +8: D7 = scan mode selector (`0=reset`, `4=start+1`; others invalid)
;   stack +12: D6 = start index (entry scan cursor)
;   stack +18: D5 = selector/column offset used in metadata lookups
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   _NEWGRID_UpdatePresetEntry, _NEWGRID2_JMPTBL_ESQ_TestBit1Based, _NEWGRID_ShouldOpenEditor
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans forward and returns the first entry that passes a stricter compound
;   eligibility gate than `_NEWGRID_FindNextEntryWithFlags`: entry flag bits,
;   marker-bitset test, editor-open veto, selector metadata bits, and payload ptr.
; NOTES:
;   Uses both entry record and selector metadata table pointers produced by
;   `_NEWGRID_UpdatePresetEntry`.
;   The aux pointer is treated as a selector-indexed record where
;   `56 + (selector*4)` stores a text/source pointer used by downstream
;   rendering/selection routines.
;   Returns `-1` when no entry satisfies all gates.
;   Uses entry fields in `A0+46`, `A0+40`, `A0+27`, `A0+56` (names unknown).
;------------------------------------------------------------------------------
_NEWGRID_FindNextEntryWithMarkers:
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
    BSR.W   _NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    TST.L   -4(A5)                        ; local ptr A: entry record ptr (from _NEWGRID_UpdatePresetEntry out0)
    BEQ.W   .advance_index

    TST.L   -8(A5)                        ; local ptr B: entry aux/selector-metadata ptr (from _NEWGRID_UpdatePresetEntry out1)
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
    JSR     _NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

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