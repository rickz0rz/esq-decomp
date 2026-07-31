    XDEF    _NEWGRID_DrawEntryRowOrPlaceholder
    XDEF    _NEWGRID_GetEntryStateCode
    XDEF    _NEWGRID_SetSelectionMarkers
    XDEF    _NEWGRID_TestEntryState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_SetSelectionMarkers   (Set glyph markers based on indices)
; ARGS:
;   stack +8: D7 = primary selector
;   stack +12: D6 = secondary selector
;   stack +16: A3 = primary dst byte
;   stack +20: A2 = secondary dst byte
;   stack +24: A0 = tertiary dst byte
;   stack +28: A0 = quaternary dst byte
; RET:
;   D0: none
; CLOBBERS:
;   D0/D6-D7/A0-A3
; CALLS:
;   none
; DESC:
;   Writes marker bytes based on selector values (0/1/2).
; NOTES:
;   Uses fixed byte codes 0x80..0x8B for marker glyphs.
;------------------------------------------------------------------------------
_NEWGRID_SetSelectionMarkers:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3
    MOVEA.L 20(A5),A2
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_primary_default

    SUBQ.L  #1,D0
    BEQ.S   .case_primary1

    SUBQ.L  #1,D0
    BEQ.S   .case_primary2

    BRA.S   .case_primary_default

.case_primary1:
    MOVE.B  #$80,(A3)
    MOVE.B  #$81,(A2)
    BRA.S   .after_primary

.case_primary2:
    MOVE.B  #$82,(A3)
    MOVE.B  #$83,(A2)
    BRA.S   .after_primary

.case_primary_default:
    MOVEQ   #0,D0
    MOVE.B  D0,(A3)
    MOVE.B  D0,(A2)

.after_primary:
    MOVE.L  D6,D0
    TST.L   D0
    BEQ.S   .case_secondary_default

    SUBQ.L  #1,D0
    BEQ.S   .case_secondary1

    SUBQ.L  #1,D0
    BEQ.S   .case_secondary2

    BRA.S   .case_secondary_default

.case_secondary1:
    MOVEA.L 24(A5),A0
    MOVE.B  #$88,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$89,(A0)
    BRA.S   .done

.case_secondary2:
    MOVEA.L 24(A5),A0
    MOVE.B  #$8a,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  #$8b,(A0)
    BRA.S   .done

.case_secondary_default:
    MOVEQ   #0,D0
    MOVEA.L 24(A5),A0
    MOVE.B  D0,(A0)
    MOVEA.L 28(A5),A0
    MOVE.B  D0,(A0)

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_GetEntryStateCode   (Compute entry state code)
; ARGS:
;   stack +8: A3 = grid struct
;   stack +12: A2 = entry list
;   stack +18: D7 = row index
; RET:
;   D0: state code (1..3)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_ESQ_TestBit1Based
; READS:
;   7(A2,D7), 56(A2,index)
; DESC:
;   Computes a state code based on entry flags and availability.
; NOTES:
;   Returns 1 for invalid/out-of-range.
;------------------------------------------------------------------------------
_NEWGRID_GetEntryStateCode:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.W  30(A7),D7
    MOVE.L  A3,D0
    BEQ.S   .invalid

    MOVE.L  A2,D0
    BEQ.S   .invalid

    TST.W   D7
    BLE.S   .invalid

    MOVEQ   #49,D0
    CMP.W   D0,D7
    BGE.S   .invalid

    LEA     28(A3),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BEQ.S   .check_entry_flags

    MOVEQ   #0,D6
    BRA.S   .done

.check_entry_flags:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    TST.L   56(A2,D0.L)
    BEQ.S   .set_state3

    BTST    #7,7(A2,D7.W)
    BEQ.S   .set_state2

.set_state3:
    MOVEQ   #3,D6
    BRA.S   .done

.set_state2:
    MOVEQ   #2,D6
    BRA.S   .done

.invalid:
    MOVEQ   #1,D6

.done:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_TestEntryState   (Test entry state against mode)
; ARGS:
;   stack +8: D7 = mode selector
;   stack +12: D6 = key
;   stack +16: D5 = entry pointer
;   stack +22: D4 = selector value
; RET:
;   D0: boolean (-1/0) result
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID_GetEntryStateCode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; DESC:
;   Determines whether an entry matches the requested selector/mode.
; NOTES:
;   Uses SNE/NEG/EXT to booleanize in mode 0.
;------------------------------------------------------------------------------
_NEWGRID_TestEntryState:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.W  22(A5),D4
    CLR.L   -12(A5)
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BGT.S   .use_second_key

    MOVEQ   #1,D0
    CMP.W   D0,D4
    BNE.S   .use_first_key

.use_second_key:
    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.normalize_key:
    MOVEQ   #48,D0
    CMP.W   D0,D4
    BLE.S   .compute_state

    SUBI.W  #$30,D4
    BRA.S   .normalize_key

.use_first_key:
    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.compute_state:
    MOVE.L  D4,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _NEWGRID_GetEntryStateCode

    LEA     12(A7),A7
    MOVE.L  D0,-16(A5)
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .mode0

    SUBQ.L  #1,D0
    BEQ.S   .mode1

    SUBQ.L  #1,D0
    BEQ.S   .mode2

    SUBQ.L  #1,D0
    BEQ.S   .mode2

    BRA.S   .done

.mode0:
    TST.L   -16(A5)
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)
    BRA.S   .done

.mode1:
    MOVE.L  -16(A5),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .mode1_match

    SUBQ.L  #3,D0
    BEQ.S   .mode1_match

    MOVEQ   #0,D0
    BRA.S   .mode1_done

.mode1_match:
    MOVEQ   #1,D0

.mode1_done:
    MOVE.L  D0,-12(A5)
    BRA.S   .done

.mode2:
    MOVEQ   #3,D1
    CMP.L   -16(A5),D1
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-12(A5)

.done:
    MOVE.L  -12(A5),D0
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawEntryRowOrPlaceholder   (Draw entry row or placeholder)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +18: arg_4 (via 22(A5))
;   stack +22: arg_5 (via 26(A5))
;   stack +24: arg_6 (via 28(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridEntry, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer
; READS:
;   _NEWGRID_EntryPlaceholderModeFlag, _CONFIG_NewgridPlaceholderBevelFlag, _SCRIPT_PtrNoDataPlaceholder, _SCRIPT_PtrOffAirPlaceholder
; DESC:
;   Draws the grid entry for a row when data is present, otherwise draws a
;   placeholder label depending on the flags.
;------------------------------------------------------------------------------
_NEWGRID_DrawEntryRowOrPlaceholder:
    LINK.W  A5,#0
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  22(A5),D7
    MOVE.W  26(A5),D6
    MOVE.L  28(A5),D5
    MOVE.L  D5,D0
    TST.L   D0
    BEQ.S   .draw_empty_placeholder

    SUBQ.L  #1,D0
    BEQ.S   .draw_missing_placeholder

    SUBQ.L  #1,D0
    BNE.S   .draw_missing_placeholder

    TST.W   _NEWGRID_EntryPlaceholderModeFlag
    BEQ.S   .draw_simple_row

    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.B  _CONFIG_NewgridPlaceholderBevelFlag,D2
    MOVEQ   #89,D4
    CMP.B   D4,D2
    SEQ     D3
    NEG.B   D3
    EXT.W   D3
    EXT.L   D3
    PEA     2.W
    MOVE.L  D3,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .done

.draw_simple_row:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    PEA     1.W
    PEA     3.W
    MOVE.L  D0,-(A7)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridEntry

    LEA     28(A7),A7
    BRA.S   .done

.draw_empty_placeholder:
    MOVE.L  _SCRIPT_PtrOffAirPlaceholder,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .done

.draw_missing_placeholder:
    MOVE.L  _SCRIPT_PtrNoDataPlaceholder,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    ADDQ.W  #8,A7

.done:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======