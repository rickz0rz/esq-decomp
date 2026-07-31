    XDEF    _NEWGRID_FindNextEntryWithAltMarkers


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
;   _NEWGRID_UpdatePresetEntry, _NEWGRID2_JMPTBL_ESQ_TestBit1Based
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans forward through primary entries and returns the first row whose entry
;   passes a compound eligibility gate: entry flags, marker-bit test result,
;   per-selector metadata bit test, and non-null row payload pointer.
; NOTES:
;   `_NEWGRID_UpdatePresetEntry` materializes two pointers used for validation:
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
    BSR.W   _NEWGRID_UpdatePresetEntry

    LEA     16(A7),A7
    MOVE.W  D0,-6(A5)                     ; local cached entry index from _NEWGRID_UpdatePresetEntry
    TST.L   -10(A5)                       ; local ptr A: entry record ptr (from _NEWGRID_UpdatePresetEntry out0)
    BEQ.S   .advance_index

    TST.L   -14(A5)                       ; local ptr B: entry aux/selector-metadata ptr (from _NEWGRID_UpdatePresetEntry out1)
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
    JSR     _NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

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