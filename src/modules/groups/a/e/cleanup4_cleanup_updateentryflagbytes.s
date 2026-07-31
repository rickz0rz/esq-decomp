    XDEF    _CLEANUP_UpdateEntryFlagBytes


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_UpdateEntryFlagBytes   (UpdateEntryFlagBytesuncertain)
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
_CLEANUP_UpdateEntryFlagBytes:
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