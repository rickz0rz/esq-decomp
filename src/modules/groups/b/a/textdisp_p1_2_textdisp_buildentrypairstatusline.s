    XDEF    _TEXTDISP_BuildEntryPairStatusLine



;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_BuildEntryPairStatusLine   (Build aligned two-part line)
; ARGS:
;   stack +10: mode (word, 1/2)
;   stack +14: groupIndex (word)
;   stack +18: entryIndex (word)
; RET:
;   none
; CLOBBERS:
;   D0-D3/A0-A1
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow,
;   _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode, _STRING_AppendAtNull,
;   _TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine, _SCRIPT_SetupHighlightEffect
; READS:
;   _SCRIPT_AlignedPrefixEmptyD/_SCRIPT_SpacerTripleC/_SCRIPT_AlignedPrefixEmptyE
; DESC:
;   Builds a two-part aligned status string for a given entry and renders it.
; NOTES:
;   Uses two short strings (slots 2/3) when present; skips if empty.
;------------------------------------------------------------------------------
_TEXTDISP_BuildEntryPairStatusLine:
    LINK.W  A5,#-148
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    MOVE.L  D6,D0
    EXT.L   D0
    TST.W   D7
    BEQ.S   .use_kind_2

    MOVEQ   #1,D1
    BRA.S   .dispatch_kind

.use_kind_2:
    MOVEQ   #2,D1

.dispatch_kind:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-8(A5)
    TST.W   D7
    BEQ.S   .use_kind_1

    MOVEQ   #1,D2
    BRA.S   .dispatch_kind_2

.use_kind_1:
    MOVEQ   #2,D2

.dispatch_kind_2:
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .return

    TST.L   -8(A5)
    BEQ.W   .return

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  _CONFIG_TimeWindowMinutes,-(A7)
    PEA     30.W
    MOVE.L  D1,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   .return

    MOVEQ   #1,D0
    CMP.W   D0,D5
    BLT.S   .reject_entry_index

    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .build_entry_parts

.reject_entry_index:
    MOVEQ   #-1,D5

.build_entry_parts:
    MOVE.L  D5,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    PEA     3.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-142(A5)
    JSR     _TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    LEA     24(A7),A7
    MOVE.L  D0,-146(A5)
    TST.L   -142(A5)
    BEQ.S   .clear_prefix

    LEA     _SCRIPT_AlignedPrefixEmptyD,A0
    LEA     -137(A5),A1

.copy_align_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_align_prefix

    MOVE.L  -142(A5),-(A7)
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_second_part

.clear_prefix:
    MOVEQ   #0,D0
    MOVE.B  D0,-137(A5)

.append_second_part:
    TST.L   -146(A5)
    BEQ.S   .emit_status_line

    MOVE.B  -137(A5),D0
    TST.B   D0
    BEQ.S   .append_separator

    PEA     _SCRIPT_SpacerTripleC
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_separator:
    PEA     _SCRIPT_AlignedPrefixEmptyE
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    MOVE.L  -146(A5),(A7)
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    LEA     12(A7),A7

.emit_status_line:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.L  D3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -137(A5)
    JSR     _TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    TST.B   -137(A5)
    BEQ.S   .return

    PEA     -137(A5)
    BSR.W   _SCRIPT_SetupHighlightEffect

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======