    XDEF    _CLEANUP_BuildAlignedStatusLine


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
;   _GROUP_AE_JMPTBL_ESQDISP_GetEntryPointerByMode, _CLEANUP_TestEntryFlagYAndBit1, _COI_GetAnimFieldPointerByMode,
;   _GROUP_AE_JMPTBL_WDISP_SPrintf, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _GROUP_AE_JMPTBL_LADFUNC_ParseHexDigit
; READS:
;   _CLOCK_FMT_WRAP_CHAR_STRING_CHAR, _CLOCK_STR_DOUBLE_SPACE, _CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY, _WDISP_CharClassTable, _TEXTDISP_CenterAlignToken
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
    BSR.W   _CLEANUP_TestEntryFlagYAndBit1

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
    PEA     _CLOCK_FMT_WRAP_CHAR_STRING_CHAR
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
    PEA     _CLOCK_STR_DOUBLE_SPACE
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

    LEA     _CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY,A0
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