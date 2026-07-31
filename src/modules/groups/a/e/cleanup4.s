    XDEF    _CLEANUP_BuildAlignedStatusLine
    XDEF    CLEANUP_TestEntryFlagYAndBit1
    XDEF    CLEANUP_UpdateEntryFlagBytes


;------------------------------------------------------------------------------
; FUNC: CLEANUP_TestEntryFlagYAndBit1   (TestEntryFlagYAndBit1uncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: 0/1 result
; CLOBBERS:
;   D0-D1/D5-D7/A0-A3
; CALLS:
;   _COI_GetAnimFieldPointerByMode
; READS:
;   entryPtr+40 (bit 1), entry data at fieldOffset
; WRITES:
;   (none)
; DESC:
;   Looks up entry data for entryIndex and returns 1 if the selected byte
;   equals 'Y' and a flag bit is set in the entry.
; NOTES:
;   - Uses _COI_GetAnimFieldPointerByMode to resolve the entry record.
;------------------------------------------------------------------------------
CLEANUP_TestEntryFlagYAndBit1:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .return_false

    TST.L   D6
    BMI.S   .return_false

    MOVEQ   #5,D1
    CMP.L   D1,D6
    BGT.S   .return_false

    MOVEQ   #89,D0
    MOVEA.L -4(A5),A0
    CMP.B   0(A0,D6.L),D0
    BNE.S   .return_false

    BTST    #1,40(A3)
    BEQ.S   .return_false

    MOVEQ   #1,D0
    BRA.S   .done

.return_false:
    MOVEQ   #0,D0

.done:
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_UpdateEntryFlagBytes   (UpdateEntryFlagBytesuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +11: arg_3 (via 15(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D7/A0-A3
; CALLS:
;   _COI_GetAnimFieldPointerByMode, _GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit
; READS:
;   _WDISP_CharClassTable, _CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY
; WRITES:
;   _DISPTEXT_InsetNibblePrimary, _DISPTEXT_InsetNibbleSecondary
; DESC:
;   Loads two flag bytes from the entry data and writes derived values into
;   _DISPTEXT_InsetNibblePrimary/_DISPTEXT_InsetNibbleSecondary using _WDISP_CharClassTable attribute bits.
; NOTES:
;   - Falls back to _CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY when the entry record is missing.
;------------------------------------------------------------------------------
CLEANUP_UpdateEntryFlagBytes:
    LINK.W  A5,#-16
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BNE.S   .entry_ok

    LEA     _CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY,A0
    LEA     -15(A5),A1

.copy_default_entry_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_default_entry_loop

    LEA     -15(A5),A0
    MOVE.L  A0,-4(A5)

.entry_ok:
    MOVEA.L -4(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry_flag6_not_set

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_flag6

.entry_flag6_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_flag6:
    MOVE.B  D1,_DISPTEXT_InsetNibblePrimary
    MOVEA.L -4(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry_flag7_not_set

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_flag7

.entry_flag7_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_flag7:
    MOVE.B  D1,_DISPTEXT_InsetNibbleSecondary
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _CLEANUP_BuildAlignedStatusLine   (BuildAlignedStatusLineuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +14: arg_4 (via 18(A5))
;   stack +18: arg_5 (via 22(A5))
;   stack +19: arg_6 (via 23(A5))
;   stack +20: arg_7 (via 24(A5))
;   stack +24: arg_8 (via 28(A5))
;   stack +28: arg_9 (via 32(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode, CLEANUP_TestEntryFlagYAndBit1, _COI_GetAnimFieldPointerByMode,
;   _GROUP_AE_JMPTBL_WDISP_SPrintf, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit
; READS:
;   CLOCK_FMT_WRAP_CHAR_STRING_CHAR, CLOCK_STR_DOUBLE_SPACE, CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY, _WDISP_CharClassTable, _TEXTDISP_CenterAlignToken
; WRITES:
;   _CLEANUP_AlignedInsetNibblePrimary, _CLEANUP_AlignedInsetNibbleSecondary, _CLOCK_AlignedInsetRenderGateFlag
; DESC:
;   Builds an aligned status string into outText, optionally using entry data
;   and setting flag bytes for later rendering.
; NOTES:
;   - Uses _COI_GetAnimFieldPointerByMode to resolve entry records and _WDISP_CharClassTable for attribute bits.
;------------------------------------------------------------------------------
_CLEANUP_BuildAlignedStatusLine:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.W  18(A5),D6
    MOVE.W  22(A5),D5
    CLR.L   -28(A5)
    MOVE.L  D6,D0
    EXT.L   D0
    TST.W   D7
    BEQ.S   .use_format_b

    MOVEQ   #1,D1
    BRA.S   .format_selected

.use_format_b:
    MOVEQ   #2,D1

.format_selected:
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  24(A5),(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   CLEANUP_TestEntryFlagYAndBit1

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .skip_entry_text

    MOVE.L  D5,D0
    EXT.L   D0
    PEA     6.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-28(A5)

.skip_entry_text:
    TST.L   -28(A5)
    BEQ.W   .clear_status_flag

    PEA     20.W
    MOVE.L  -28(A5),-(A7)
    PEA     19.W
    PEA     CLOCK_FMT_WRAP_CHAR_STRING_CHAR
    PEA     -12(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7
    TST.L   28(A5)
    BEQ.S   .append_default_prefix

    PEA     _TEXTDISP_CenterAlignToken
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .append_entry_text

.append_default_prefix:
    PEA     CLOCK_STR_DOUBLE_SPACE
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_entry_text:
    PEA     -12(A5)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _COI_GetAnimFieldPointerByMode

    LEA     20(A7),A7
    MOVE.L  D0,-32(A5)
    TST.L   D0
    BNE.S   .entry2_ok

    LEA     CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY,A0
    LEA     -23(A5),A1

.copy_default_entry2_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_default_entry2_loop

    LEA     -23(A5),A0
    MOVE.L  A0,-32(A5)

.entry2_ok:
    MOVEA.L -32(A5),A0
    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry2_flag6_not_set

    MOVE.B  6(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_entry2_flag6

.entry2_flag6_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_entry2_flag6:
    MOVE.B  D1,_CLEANUP_AlignedInsetNibblePrimary
    MOVEA.L -32(A5),A0
    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .entry2_flag7_not_set

    MOVE.B  7(A0),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .store_entry2_flag7

.entry2_flag7_not_set:
    MOVEQ   #0,D1
    NOT.B   D1

.store_entry2_flag7:
    MOVE.B  D1,_CLEANUP_AlignedInsetNibbleSecondary
    MOVE.B  #$1,_CLOCK_AlignedInsetRenderGateFlag
    BRA.S   .done

.clear_status_flag:
    CLR.B   _CLOCK_AlignedInsetRenderGateFlag

.done:
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======