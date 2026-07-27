    XDEF    _PARSEINI_ParseColorTable


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_ParseColorTable   (Routine at _PARSEINI_ParseColorTable)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +108: arg_4 (via 112(A5))
;   stack +112: arg_5 (via 116(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _PARSEINI_JMPTBL_STRING_CompareNoCase, _PARSEINI_JMPTBL_WDISP_SPrintf, _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit, _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition
; READS:
;   _Global_STR_COLOR_PERCENT_D, _ESQFUNC_BasePaletteRgbTriples, _KYBD_CustomPaletteTriplesRBase
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSEINI_ParseColorTable:
    LINK.W  A5,#-120
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7

    MOVE.L  D7,D0
    SUBQ.L  #4,D0
    BEQ.S   .mode4_select_table

    SUBQ.L  #1,D0
    BEQ.S   .mode5_select_table

    BRA.S   .init_color_index

.mode4_select_table:
    MOVE.L  #_KYBD_CustomPaletteTriplesRBase,-116(A5)
    MOVEQ   #8,D4
    BRA.S   .init_color_index

.mode5_select_table:
    MOVE.L  #_ESQFUNC_BasePaletteRgbTriples,-116(A5)
    MOVEQ   #8,D4

.init_color_index:
    MOVEQ   #0,D6

.color_index_loop:
    CMP.L   D4,D6
    BGE.S   .maybe_finalize

    MOVE.L  D6,-(A7)
    PEA     _Global_STR_COLOR_PERCENT_D
    PEA     -112(A5)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    PEA     -112(A5)
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    LEA     20(A7),A7
    TST.L   D0
    BNE.S   .next_color_index

    MOVEQ   #0,D5

.channel_loop:
    MOVEQ   #3,D0
    CMP.L   D0,D5
    BGE.S   .next_color_index

    MOVE.L  D6,D1
    LSL.L   #2,D1
    SUB.L   D6,D1
    ADD.L   D5,D1
    MOVE.B  0(A2,D5.L),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D1,28(A7)
    JSR     _SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEA.L -116(A5),A0
    MOVE.L  24(A7),D1
    MOVE.B  D0,0(A0,D1.L)
    ADDQ.L  #1,D5
    BRA.S   .channel_loop

.next_color_index:
    ADDQ.L  #1,D6
    BRA.S   .color_index_loop

.maybe_finalize:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BNE.S   .return

    JSR     _TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(PC)

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======