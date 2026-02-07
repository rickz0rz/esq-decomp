;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA1_DrawTextWithInsetSegments   (Draw text with inline $13/$14 inset segments)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +19: arg_5 (via 23(A5))
;   stack +23: arg_6 (via 27(A5))
;   stack +24: arg_7 (via 28(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   MEMORY_AllocateMemory, MEMORY_DeallocateMemory, SCRIPT_DrawInsetTextWithFrame, UNKNOWN7_FindCharWrapper, _LVOMove, _LVOText
; READS:
;   Global_REF_GRAPHICS_LIBRARY, Global_STR_TLIBA1_C_1, Global_STR_TLIBA1_C_2, MEMF_CLEAR, MEMF_PUBLIC, if_eq_1768, if_ne_1763, return_176B
; WRITES:
;   (none observed)
; DESC:
;   Copies source text into a scratch buffer, splits on control bytes $13/$14,
;   draws plain spans directly, and renders inset spans via SCRIPT helper.
; NOTES:
;   Gracefully returns when input text is null/empty or allocation fails.
;------------------------------------------------------------------------------
TLIBA1_DrawTextWithInsetSegments:
    LINK.W  A5,#-20
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.B  23(A5),D5
    MOVEA.L 28(A5),A2
    CLR.L   -16(A5)
    MOVE.L  A2,D0
    BEQ.S   .if_eq_1762

    TST.B   (A2)
    BEQ.S   .if_eq_1762

    MOVEA.L A2,A0

.if_ne_1760:
    TST.B   (A0)+
    BNE.S   .if_ne_1760

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-20(A5)
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1842.W
    PEA     Global_STR_TLIBA1_C_1
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    MOVEA.L A2,A0
    MOVEA.L D0,A1

.if_ne_1761:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .if_ne_1761

.if_eq_1762:
    TST.L   -16(A5)
    BEQ.W   .return_176B

    MOVEA.L -16(A5),A0
    PEA     19.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    TST.L   -8(A5)
    BEQ.W   .if_eq_1768

.if_ne_1763:
    MOVEA.L -12(A5),A0
    PEA     20.W
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   -8(A5)
    BEQ.S   .if_eq_1764

    MOVEQ   #0,D1
    MOVEA.L -8(A5),A0
    MOVE.B  D1,(A0)+
    MOVE.L  A0,-8(A5)

.if_eq_1764:
    TST.L   D0
    BEQ.S   .if_eq_1765

    MOVEA.L D0,A0
    CLR.B   (A0)+
    MOVE.L  A0,-12(A5)

.if_eq_1765:
    TST.L   -4(A5)
    BEQ.S   .if_eq_1767

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.S   .if_eq_1767

.if_ne_1766:
    TST.B   (A0)+
    BNE.S   .if_ne_1766

    SUBQ.L  #1,A0
    SUBA.L  -4(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -4(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.if_eq_1767:
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  27(A5),D1
    MOVE.L  -8(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     SCRIPT_DrawInsetTextWithFrame(PC)

    LEA     16(A7),A7
    PEA     19.W
    MOVE.L  -12(A5),-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BNE.W   .if_ne_1763

.if_eq_1768:
    TST.L   -12(A5)
    BEQ.S   .if_eq_176A

    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BEQ.S   .if_eq_176A

.if_ne_1769:
    TST.B   (A0)+
    BNE.S   .if_ne_1769

    SUBQ.L  #1,A0
    SUBA.L  -12(A5),A0
    MOVEA.L A3,A1
    MOVE.L  A0,D0
    MOVEA.L -12(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.if_eq_176A:
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     1885.W
    PEA     Global_STR_TLIBA1_C_2
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return_176B:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA1_ParseStyleCodeChar   (Parse style char '1'..'7' or 'X')
; ARGS:
;   stack +8: styleChar (u8)
; RET:
;   D0: -1 for 'X', 1..7 for '1'..'7', else 0
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Converts single-character style tokens into compact numeric style IDs.
; NOTES:
;   Input is case-sensitive for 'X'.
;------------------------------------------------------------------------------
TLIBA1_ParseStyleCodeChar:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #88,D0
    CMP.B   D0,D7
    BNE.S   .if_ne_176D

    MOVEQ   #-1,D7
    BRA.S   .return_1770

.if_ne_176D:
    MOVEQ   #49,D0
    CMP.B   D0,D7
    BCS.S   .if_cs_176E

    MOVEQ   #55,D0
    CMP.B   D0,D7
    BLS.S   .if_ls_176F

.if_cs_176E:
    MOVEQ   #0,D7
    BRA.S   .return_1770

.if_ls_176F:
    SUBI.B  #$30,D7

.return_1770:
    MOVE.L  D7,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA1_DrawInlineStyledText   (Render one text line with inline style markers)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +14: arg_6 (via 18(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +18: arg_8 (via 22(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   TLIBA1_DrawTextWithInsetSegments, TLIBA1_ParseStyleCodeChar, MEM_Move,
;   TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble, TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble, UNKNOWN7_FindCharWrapper,
;   UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition, _LVOTextLength
; READS:
;   Global_REF_GRAPHICS_LIBRARY, DATA_CLOCK_CONST_WORD_1B5D, DATA_WDISP_BSS_BYTE_21B3, DATA_WDISP_BSS_BYTE_21B4, ff, if_eq_1780, if_eq_1787, if_ne_1773, return_1788
; WRITES:
;   DATA_CLOCK_CONST_WORD_1B5D
; DESC:
;   Parses inline marker sequences and chooses framed/plain drawing paths for a
;   single rendered text row.
; NOTES:
;   Updates DATA_CLOCK_CONST_WORD_1B5D gating flag after framed draw path.
;------------------------------------------------------------------------------
TLIBA1_DrawInlineStyledText:
    LINK.W  A5,#-24
    MOVEM.L D2-D3/D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVEA.L 20(A5),A2
    MOVEQ   #0,D0
    MOVE.L  D0,-18(A5)
    MOVE.L  D0,-14(A5)
    TST.B   DATA_CLOCK_CONST_WORD_1B5D
    BEQ.S   .if_eq_1772

    PEA     19.W
    MOVE.L  A2,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .if_eq_1772

    PEA     20.W
    MOVE.L  A2,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .if_eq_1772

    MOVEQ   #0,D0
    MOVE.B  DATA_WDISP_BSS_BYTE_21B4,D0
    MOVEQ   #0,D1
    MOVE.B  DATA_WDISP_BSS_BYTE_21B3,D1
    MOVE.L  A2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA1_DrawTextWithInsetSegments

    LEA     24(A7),A7
    CLR.B   DATA_CLOCK_CONST_WORD_1B5D
    BRA.W   .return_1788

.if_eq_1772:
    PEA     30.W
    MOVE.L  A2,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .if_eq_1780

.if_ne_1773:
    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  D0,-22(A5)
    MOVE.L  A0,-8(A5)

.loop_1774:
    MOVEA.L -8(A5),A0
    CMPI.B  #$20,(A0)
    BLS.S   .if_ls_1775

    ADDQ.L  #1,-8(A5)
    ADDQ.L  #1,-22(A5)
    BRA.S   .loop_1774

.if_ls_1775:
    MOVEA.L A3,A1
    MOVEA.L -4(A5),A0
    MOVE.L  -22(A5),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,-14(A5)
    CMPI.L  #$2,-22(A5)
    BLE.S   .if_le_1776

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  1(A0),D0
    MOVE.L  D0,-(A7)
    BSR.W   TLIBA1_ParseStyleCodeChar

    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  2(A0),D1
    MOVE.L  D1,(A7)
    MOVE.B  D0,-10(A5)
    BSR.W   TLIBA1_ParseStyleCodeChar

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    BRA.S   .skip_1777

.if_le_1776:
    MOVEQ   #0,D0
    MOVE.L  D0,D5
    MOVE.B  D0,-10(A5)

.skip_1777:
    MOVEQ   #0,D0
    MOVE.B  -10(A5),D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .if_eq_1778

    MOVEQ   #1,D2
    CMP.B   D2,D0
    BCS.S   .branch_177A

    MOVEQ   #7,D3
    CMP.B   D3,D0
    BHI.S   .branch_177A

.if_eq_1778:
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    CMP.L   D1,D0
    BEQ.S   .if_eq_1779

    MOVEQ   #1,D0
    CMP.B   D0,D5
    BCS.S   .branch_177A

    MOVEQ   #7,D0
    CMP.B   D0,D5
    BHI.S   .branch_177A

.if_eq_1779:
    MOVEA.L -4(A5),A0
    CMPI.B  #$20,3(A0)
    BHI.S   .if_hi_177C

.branch_177A:
    MOVEA.L -8(A5),A0

.if_ne_177B:
    TST.B   (A0)+
    BNE.S   .if_ne_177B

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     MEM_Move(PC)

    LEA     12(A7),A7
    BRA.S   .skip_177E

.if_hi_177C:
    MOVE.B  #$13,(A0)
    LEA     3(A0),A1
    LEA     1(A0),A6
    MOVE.L  -22(A5),D0
    SUBQ.L  #3,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A6,-(A7)
    MOVE.L  A1,-(A7)
    JSR     MEM_Move(PC)

    MOVEA.L -4(A5),A0
    ADDA.L  -22(A5),A0
    MOVE.B  #$14,-2(A0)
    SUBQ.L  #1,A0
    MOVEA.L -8(A5),A1

.if_ne_177D:
    TST.B   (A1)+
    BNE.S   .if_ne_177D

    SUBQ.L  #1,A1
    SUBA.L  -8(A5),A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     MEM_Move(PC)

    LEA     20(A7),A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  -22(A5),D0
    SUBQ.L  #3,D0
    MOVEA.L A3,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,-18(A5)
    MOVEQ   #0,D0
    MOVE.B  -10(A5),D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .skip_177E

    ADDQ.L  #8,-18(A5)

.skip_177E:
    PEA     30.W
    MOVE.L  A2,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BNE.W   .if_ne_1773

    MOVE.L  -14(A5),D0
    SUB.L   -18(A5),D0
    TST.L   D0
    BPL.S   .if_pl_177F

    ADDQ.L  #1,D0

.if_pl_177F:
    ASR.L   #1,D0
    ADD.L   D0,D7
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  -10(A5),D1
    MOVE.L  A2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA1_DrawTextWithInsetSegments

    LEA     24(A7),A7
    BRA.W   .return_1788

.if_eq_1780:
    PEA     23.W
    MOVE.L  A2,-(A7)
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .if_eq_1787

    MOVEA.L D0,A0
    MOVE.B  #$13,(A0)+
    MOVE.L  A0,-4(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    TST.L   D0
    BPL.S   .if_pl_1781

    ADDQ.L  #1,D0

.if_pl_1781:
    ASR.L   #1,D0
    ADD.L   D0,D7
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,-10(A5)
    MOVEQ   #1,D1
    CMP.B   D1,D0
    BCS.S   .if_cs_1782

    MOVEQ   #7,D1
    CMP.B   D1,D0
    BLS.S   .if_ls_1783

.if_cs_1782:
    MOVE.B  #$ff,-10(A5)

.if_ls_1783:
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    JSR     TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.B   D0,D5
    BCS.S   .if_cs_1784

    MOVEQ   #7,D0
    CMP.B   D0,D5
    BLS.S   .loop_1785

.if_cs_1784:
    MOVEQ   #-1,D5

.loop_1785:
    MOVEA.L -4(A5),A0
    MOVE.B  1(A0),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BLS.S   .if_ls_1786

    MOVE.B  D0,(A0)
    ADDQ.L  #1,-4(A5)
    BRA.S   .loop_1785

.if_ls_1786:
    MOVEA.L -4(A5),A0
    MOVE.B  #$14,(A0)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  -10(A5),D1
    MOVE.L  A2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA1_DrawTextWithInsetSegments

    LEA     24(A7),A7
    BRA.S   .return_1788

.if_eq_1787:
    MOVE.L  A2,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.return_1788:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA1_DrawFormattedTextBlock   (Layout and draw a multi-line formatted block)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +14: arg_6 (via 18(A5))
;   stack +16: arg_7 (via 20(A5))
;   stack +17: arg_8 (via 21(A5))
;   stack +18: arg_9 (via 22(A5))
;   stack +22: arg_10 (via 26(A5))
;   stack +24: arg_11 (via 28(A5))
;   stack +26: arg_12 (via 30(A5))
;   stack +28: arg_13 (via 32(A5))
;   stack +30: arg_14 (via 34(A5))
;   stack +32: arg_15 (via 36(A5))
;   stack +34: arg_16 (via 38(A5))
;   stack +36: arg_17 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   TLIBA1_DrawInlineStyledText, MATH_DivS32, MATH_Mulu32, MEMORY_AllocateMemory,
;   MEMORY_DeallocateMemory, _LVOSetAPen, _LVOSetFont, _LVOTextLength
; READS:
;   Global_HANDLE_PREVUE_FONT, Global_REF_GRAPHICS_LIBRARY, Global_STR_TLIBA1_C_3, DATA_CLOCK_CONST_WORD_1B5D, DATA_TLIBA1_STR_TLIBA1_DOT_C_2164, DATA_WDISP_BSS_BYTE_21B3, DATA_WDISP_BSS_WORD_236C, MEMF_CLEAR, MEMF_PUBLIC, if_eq_178F, if_eq_1792, if_eq_1794, if_eq_1798, if_eq_1799, if_ge_17A6, loop_179C, return_17A7, skip_179A, skip_179B
; WRITES:
;   (none observed)
; DESC:
;   Tokenizes source text into render runs, computes per-line offsets/fonts,
;   then renders each line with TLIBA1_DrawInlineStyledText.
; NOTES:
;   Uses a temporary 10-byte record table per emitted line.
;------------------------------------------------------------------------------
TLIBA1_DrawFormattedTextBlock:
    LINK.W  A5,#-48
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  18(A5),D7
    MOVE.W  22(A5),D6
    MOVE.W  26(A5),D5
    MOVEQ   #0,D0
    MOVE.L  D5,D1
    SUB.W   D7,D1
    ADDQ.W  #1,D1
    MOVE.W  30(A5),D2
    SUB.W   D6,D2
    ADDQ.W  #1,D2
    MOVE.L  A2,-8(A5)
    MOVE.W  D0,-28(A5)
    MOVE.W  D0,-30(A5)
    MOVE.W  D0,-32(A5)
    MOVE.W  D0,-34(A5)
    MOVE.W  D0,-36(A5)
    MOVE.W  D0,-12(A5)
    MOVE.W  D0,-18(A5)
    MOVE.W  D0,-20(A5)
    MOVE.W  D0,-40(A5)
    MOVE.W  D0,-38(A5)
    MOVE.W  D0,-10(A5)
    MOVE.W  D1,-14(A5)
    MOVE.W  D2,-16(A5)

.loop_178A:
    MOVEA.L -8(A5),A0
    TST.B   (A0)
    BEQ.S   .if_eq_178E

    MOVE.B  (A0),D0
    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   .if_eq_178B

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BEQ.S   .if_eq_178B

    SUBQ.B  #6,D0
    BNE.S   .if_ne_178C

.if_eq_178B:
    TST.W   -40(A5)
    BNE.S   .skip_178D

    MOVEQ   #1,D0
    ADDQ.W  #1,-18(A5)
    MOVE.W  D0,-40(A5)
    BRA.S   .skip_178D

.if_ne_178C:
    CLR.W   -40(A5)

.skip_178D:
    ADDQ.L  #1,-8(A5)
    BRA.S   .loop_178A

.if_eq_178E:
    MOVEQ   #0,D0
    MOVE.W  D0,-40(A5)
    TST.W   -18(A5)
    BEQ.W   .return_17A7

    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     MATH_Mulu32(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     2115.W
    PEA     Global_STR_TLIBA1_C_3
    JSR     MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .return_17A7

    MOVE.L  A2,-8(A5)
    MOVE.W  #2,-32(A5)

.if_eq_178F:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    TST.W   D0
    BEQ.W   .if_eq_1798

    SUBQ.W  #6,D0
    BEQ.W   .if_eq_1794

    SUBI.W  #12,D0
    BEQ.W   .if_eq_1799

    SUBQ.W  #6,D0
    BEQ.S   .if_eq_1790

    SUBQ.W  #1,D0
    BEQ.W   .if_eq_1792

    BRA.W   .skip_179A

.if_eq_1790:
    TST.W   -40(A5)
    BEQ.S   .if_eq_1791

    SUBQ.W  #1,-28(A5)
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #1,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    MOVE.L  D1,D4
    ADDQ.W  #1,D4
    MOVE.W  D4,2(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    BRA.W   .skip_179B

.if_eq_1791:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #0,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,4(A0,D1.L)
    MOVEQ   #1,D4
    MOVE.W  D4,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,2(A0,D0.L)
    MOVE.W  D4,8(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVEA.L 52(A3),A0
    MOVE.W  20(A0),D0
    ADDQ.W  #1,D0
    ADD.W   D0,-30(A5)
    ADDQ.W  #1,-32(A5)
    MOVE.W  D3,-38(A5)
    MOVE.W  D4,-40(A5)
    BRA.W   .skip_179B

.if_eq_1792:
    TST.W   -40(A5)
    BEQ.S   .if_eq_1793

    SUBQ.W  #1,-28(A5)
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #3,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    MOVE.L  D1,D4
    ADDQ.W  #1,D4
    MOVE.W  D4,2(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    BRA.W   .skip_179B

.if_eq_1793:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #0,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,4(A0,D1.L)
    MOVE.W  #3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,2(A0,D0.L)
    MOVEQ   #1,D1
    MOVE.W  D1,8(A0,D0.L)
    ADDQ.W  #1,-28(A5)
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVEA.L 52(A3),A0
    MOVE.W  20(A0),D0
    ADDQ.W  #1,D0
    ADD.W   D0,-30(A5)
    ADDQ.W  #1,-32(A5)
    MOVE.W  D1,-40(A5)
    MOVE.W  D3,-38(A5)
    BRA.W   .skip_179B

.if_eq_1794:
    TST.W   -40(A5)
    BEQ.S   .if_eq_1795

    SUBQ.W  #1,-28(A5)

.if_eq_1795:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MOVEQ   #10,D2
    MULS    D2,D1
    MOVEQ   #1,D3
    MOVEA.L -4(A5),A0
    MOVE.W  D3,4(A0,D1.L)
    MOVE.W  D3,0(A0,D1.L)
    MULS    D2,D0
    MOVE.W  -36(A5),D1
    ADDQ.W  #1,D1
    MOVE.W  D1,2(A0,D0.L)
    TST.W   -38(A5)
    BEQ.S   .if_eq_1796

    MOVEQ   #0,D1
    MOVE.W  D1,8(A0,D0.L)
    BRA.S   .skip_1797

.if_eq_1796:
    MOVE.W  -28(A5),D0
    MOVE.L  D0,D1
    MULS    D2,D1
    MOVE.W  D3,8(A0,D1.L)
    ADDQ.W  #1,-32(A5)

.skip_1797:
    ADDQ.W  #1,-28(A5)
    MOVEA.L -8(A5),A0
    CLR.B   (A0)
    MOVEA.L Global_HANDLE_PREVUE_FONT,A0
    MOVE.W  20(A0),D0
    ADD.W   D0,-30(A5)
    CLR.W   -40(A5)
    MOVE.W  D3,-38(A5)
    BRA.S   .skip_179B

.if_eq_1798:
    MOVEQ   #1,D0
    ADDQ.W  #1,-32(A5)
    MOVE.W  D0,-10(A5)
    BRA.S   .skip_179B

.if_eq_1799:
    TST.W   -38(A5)
    BNE.S   .skip_179B

    MOVEA.L -8(A5),A0
    MOVE.B  #$20,(A0)
    BRA.S   .skip_179B

.skip_179A:
    CLR.W   -40(A5)

.skip_179B:
    ADDQ.W  #1,-36(A5)
    ADDQ.L  #1,-8(A5)
    TST.W   -10(A5)
    BEQ.W   .if_eq_178F

    MOVE.W  -16(A5),D0
    EXT.L   D0
    MOVE.W  -30(A5),D1
    EXT.L   D1
    SUB.L   D1,D0
    MOVE.W  -32(A5),D1
    EXT.L   D1
    JSR     MATH_DivS32(PC)

    MOVE.B  25(A3),-21(A5)
    MOVE.L  52(A3),-26(A5)
    CLR.W   -12(A5)
    MOVE.W  D0,-30(A5)
    MOVE.W  D0,-34(A5)

.loop_179C:
    MOVE.W  -12(A5),D0
    CMP.W   -18(A5),D0
    BGE.W   .if_ge_17A6

    TST.W   DATA_WDISP_BSS_WORD_236C
    BEQ.S   .if_eq_179D

    MULS    #10,D0
    MOVEA.L -4(A5),A0
    MOVE.W  0(A0,D0.L),D1
    EXT.L   D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.if_eq_179D:
    MOVE.W  -12(A5),D0
    MULS    #10,D0
    MOVEA.L -4(A5),A0
    TST.W   4(A0,D0.L)
    BEQ.S   .if_eq_179E

    MOVEA.L A3,A1
    MOVEA.L Global_HANDLE_PREVUE_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    BRA.S   .skip_179F

.if_eq_179E:
    MOVEA.L A3,A1
    MOVEA.L -26(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

.skip_179F:
    MOVE.W  -12(A5),D0
    MULS    #10,D0
    MOVEA.L A2,A0
    MOVEA.L -4(A5),A1
    ADDA.W  2(A1,D0.L),A0
    MOVEA.L A0,A1

.if_ne_17A0:
    TST.B   (A1)+
    BNE.S   .if_ne_17A0

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,36(A7)
    MOVEA.L A3,A1
    MOVE.L  36(A7),D0
    JSR     _LVOTextLength(A6)

    TST.B   DATA_CLOCK_CONST_WORD_1B5D
    BEQ.S   .if_eq_17A1

    MOVEQ   #0,D1
    MOVE.B  DATA_WDISP_BSS_BYTE_21B3,D1
    MOVEQ   #0,D2
    NOT.B   D2
    CMP.L   D2,D1
    BEQ.S   .if_eq_17A1

    MOVEQ   #8,D1
    BRA.S   .skip_17A2

.if_eq_17A1:
    MOVEQ   #0,D1

.skip_17A2:
    ADD.L   D1,D0
    MOVE.W  D0,-20(A5)
    MOVE.W  -14(A5),D1
    CMP.W   D1,D0
    BLE.S   .if_le_17A3

    MOVE.W  D1,-20(A5)

.if_le_17A3:
    MOVE.W  -12(A5),D0
    MOVE.L  D0,D2
    MOVEQ   #10,D3
    MULS    D3,D2
    MOVEA.L -4(A5),A0
    TST.W   8(A0,D2.L)
    BEQ.S   .if_eq_17A4

    MOVE.W  -34(A5),D2
    ADDQ.W  #1,D2
    ADD.W   D2,-30(A5)

.if_eq_17A4:
    MOVE.W  58(A3),D2
    ADD.W   D2,-30(A5)
    EXT.L   D1
    MOVE.W  -20(A5),D2
    EXT.L   D2
    SUB.L   D2,D1
    TST.L   D1
    BPL.S   .if_pl_17A5

    ADDQ.L  #1,D1

.if_pl_17A5:
    ASR.L   #1,D1
    MOVE.L  D7,D2
    EXT.L   D2
    ADD.L   D1,D2
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.W  -30(A5),D4
    EXT.L   D4
    ADD.L   D4,D1
    MULS    D3,D0
    MOVEA.L A2,A0
    MOVEA.L -4(A5),A1
    ADDA.W  2(A1,D0.L),A0
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA1_DrawInlineStyledText

    LEA     16(A7),A7
    ADDQ.W  #1,-12(A5)
    BRA.W   .loop_179C

.if_ge_17A6:
    MOVE.B  -21(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEA.L -26(A5),A0
    JSR     _LVOSetFont(A6)

    TST.L   -4(A5)
    BEQ.S   .return_17A7

    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     MATH_Mulu32(PC)

    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     2385.W
    PEA     DATA_TLIBA1_STR_TLIBA1_DOT_C_2164
    JSR     MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return_17A7:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA1_BuildClockFormatEntryIfVisible   (Build formatted entry string when slot is active)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +16: arg_6 (via 20(A5))
;   stack +18: arg_7 (via 22(A5))
;   stack +20: arg_8 (via 24(A5))
;   stack +24: arg_9 (via 28(A5))
;   stack +26: arg_10 (via 30(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   TLIBA1_FormatClockFormatEntry, TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode,
;   TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow, TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode,
;   TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; READS:
;   CONFIG_TimeWindowMinutes, TEXTDISP_ActiveGroupId
; WRITES:
;   (none observed)
; DESC:
;   Gathers timing fields for the active group, tests visibility against the
;   configured time window, then emits a formatted entry string when valid.
; NOTES:
;   Clears output buffer when no visible fields are available.
;------------------------------------------------------------------------------
TLIBA1_BuildClockFormatEntryIfVisible:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVEA.L 16(A5),A3
    MOVE.W  22(A5),D5
    CLR.W   -30(A5)
    MOVE.W  TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .if_ne_17A9

    MOVE.L  D7,D0
    EXT.L   D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    BRA.S   .skip_17AA

.if_ne_17A9:
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     2.W
    MOVE.L  D0,-(A7)
    JSR     TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    MOVE.L  D7,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)

.skip_17AA:
    MOVE.L  D6,D1
    EXT.L   D1
    PEA     5.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     3.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-12(A5)
    JSR     TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     2.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-16(A5)
    JSR     TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     4.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-20(A5)
    JSR     TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    PEA     1.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-24(A5)
    JSR     TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode(PC)

    LEA     60(A7),A7
    MOVE.L  D0,-28(A5)
    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BEQ.S   .if_eq_17AB

    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  CONFIG_TimeWindowMinutes,-(A7)
    PEA     1440.W
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .if_eq_17AE

.if_eq_17AB:
    TST.L   -12(A5)
    BNE.S   .if_ne_17AC

    TST.L   -16(A5)
    BNE.S   .if_ne_17AC

    TST.L   -20(A5)
    BNE.S   .if_ne_17AC

    TST.L   -24(A5)
    BNE.S   .if_ne_17AC

    TST.L   -28(A5)
    BEQ.S   .if_eq_17AE

.if_ne_17AC:
    MOVE.L  A3,D0
    BEQ.S   .if_eq_17AD

    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -28(A5),-(A7)
    MOVE.L  -24(A5),-(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -16(A5),-(A7)
    MOVE.L  -12(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   TLIBA1_FormatClockFormatEntry

    LEA     28(A7),A7

.if_eq_17AD:
    MOVE.W  #1,-30(A5)
    BRA.S   .skip_17B0

.if_eq_17AE:
    MOVE.L  A3,D0
    BEQ.S   .if_eq_17AF

    CLR.B   (A3)

.if_eq_17AF:
    MOVEQ   #0,D0
    MOVE.W  D0,-30(A5)

.skip_17B0:
    MOVE.W  -30(A5),D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA1_FormatClockFormatEntry   (Compose TLFORMAT metadata + values into output text)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +30: arg_7 (via 34(A5))
;   stack +528: arg_8 (via 532(A5))
;   stack +534: arg_9 (via 538(A5))
;   stack +538: arg_10 (via 542(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   FORMAT_RawDoFmtWithScratchBuffer, STRING_AppendAtNull, WDISP_SPrintf
; READS:
;   DATA_TEXTDISP_CONST_LONG_2156, DATA_TLIBA1_BSS_BYTE_2165, DATA_TLIBA1_BSS_WORD_2166, DATA_TLIBA1_BSS_WORD_2167, DATA_TLIBA1_BSS_WORD_2168, DATA_TLIBA1_BSS_WORD_2169, DATA_TLIBA1_FMT_PCT_C_PCT_S_216A, DATA_TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X_216B, DATA_TLIBA1_STR_VALUE_216C, DATA_TLIBA1_FMT_TLF_COLOR_PCT_D_216D, DATA_TLIBA1_FMT_TLF_OFFSET_PCT_D_216E, DATA_TLIBA1_FMT_TLF_FONTSEL_PCT_D_216F, DATA_TLIBA1_FMT_TLF_ALIGN_PCT_D_2170, DATA_TLIBA1_FMT_TLF_PREGAP_PCT_D_2171, DATA_TLIBA1_STR_VALUE_2172, WDISP_CharClassTable, copy_loop
; WRITES:
;   (none observed)
; DESC:
;   Builds a formatted output string by combining template fragments and current
;   TLFORMAT/value fields, appending each fragment into destination buffer.
; NOTES:
;   Falls back to module default field strings when optional pointers are null.
;------------------------------------------------------------------------------
TLIBA1_FormatClockFormatEntry:
    LINK.W  A5,#-544
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  34(A5),D7
    LEA     DATA_TLIBA1_BSS_BYTE_2165,A0
    LEA     -532(A5),A1
    MOVE.W  #$1ff,D0
; This is weird, it's purposefully one byte back
; so that it can start the loop as if it's doing a
; do/while loop.
.copy_loop:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_loop
    MOVE.L  A2,D0
    BEQ.S   .if_eq_17B3

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   .skip_17B4

.if_eq_17B3:
    MOVEQ   #65,D0

.skip_17B4:
    LEA     WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .if_eq_17B7

    MOVE.L  A2,D0
    BEQ.S   .if_eq_17B5

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   .skip_17B6

.if_eq_17B5:
    MOVEQ   #65,D0

.skip_17B6:
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .skip_17B9

.if_eq_17B7:
    MOVE.L  A2,D0
    BEQ.S   .if_eq_17B8

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   .skip_17B9

.if_eq_17B8:
    MOVEQ   #65,D0

.skip_17B9:
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    SUBI.B  #$41,D0
    MOVE.L  D0,D5
    ADDQ.B  #1,D5
    TST.W   D7
    BNE.S   .branch_17BA

    MOVEQ   #0,D0
    CMP.B   D0,D5
    BCS.S   .branch_17BA

    MOVEQ   #2,D1
    CMP.B   D1,D5
    BCC.S   .branch_17BA

    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     DATA_TEXTDISP_CONST_LONG_2156,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .skip_17BB

.branch_17BA:
    MOVE.L  DATA_TEXTDISP_CONST_LONG_2156,-4(A5)

.skip_17BB:
    TST.L   28(A5)
    BEQ.S   .if_eq_17BC

    MOVEA.L 28(A5),A0
    BRA.S   .skip_17BD

.if_eq_17BC:
    LEA     DATA_TLIBA1_BSS_WORD_2166,A0

.skip_17BD:
    MOVE.L  A0,-20(A5)
    TST.L   16(A5)
    BEQ.S   .if_eq_17BE

    MOVEA.L 16(A5),A0
    BRA.S   .skip_17BF

.if_eq_17BE:
    LEA     DATA_TLIBA1_BSS_WORD_2167,A0

.skip_17BF:
    MOVE.L  A0,-16(A5)
    TST.L   24(A5)
    BEQ.S   .if_eq_17C0

    MOVEA.L 24(A5),A0
    BRA.S   .skip_17C1

.if_eq_17C0:
    LEA     DATA_TLIBA1_BSS_WORD_2168,A0

.skip_17C1:
    MOVE.L  A0,-12(A5)
    TST.L   20(A5)
    BEQ.S   .if_eq_17C2

    MOVEA.L 20(A5),A0
    BRA.S   .skip_17C3

.if_eq_17C2:
    LEA     DATA_TLIBA1_BSS_WORD_2169,A0

.skip_17C3:
    MOVE.L  A0,-8(A5)
    CLR.B   (A3)
    CLR.L   -538(A5)

.loop_17C4:
    MOVE.L  -538(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .return_17C8

    ASL.L   #2,D0
    MOVEA.L -20(A5,D0.L),A0

.if_ne_17C5:
    TST.B   (A0)+
    BNE.S   .if_ne_17C5

    SUBQ.L  #1,A0
    SUBA.L  -20(A5,D0.L),A0
    MOVE.L  A0,-542(A5)
    BLE.S   .branch_17C7

    MOVE.L  A0,D0
    CMPI.L  #$200,D0
    BGE.S   .branch_17C7

    MOVEA.L A3,A0

.if_ne_17C6:
    TST.B   (A0)+
    BNE.S   .if_ne_17C6

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D1
    ADD.L   D1,D0
    CMPI.L  #$200,D0
    BGE.S   .branch_17C7

    CLR.B   -532(A5)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.L  -538(A5),D1
    MOVE.B  0(A0,D1.L),D0
    ASL.L   #2,D1
    MOVE.L  -20(A5,D1.L),-(A7)
    MOVE.L  D0,-(A7)
    PEA     DATA_TLIBA1_FMT_PCT_C_PCT_S_216A
    PEA     -532(A5)
    JSR     WDISP_SPrintf(PC)

    PEA     -532(A5)
    MOVE.L  A3,-(A7)
    JSR     STRING_AppendAtNull(PC)

    LEA     24(A7),A7

.branch_17C7:
    ADDQ.L  #1,-538(A5)
    BRA.S   .loop_17C4

.return_17C8:
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,-(A7)
    PEA     DATA_TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X_216B
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     DATA_TLIBA1_STR_VALUE_216C
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  (A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     DATA_TLIBA1_FMT_TLF_COLOR_PCT_D_216D
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  2(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     DATA_TLIBA1_FMT_TLF_OFFSET_PCT_D_216E
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  4(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     DATA_TLIBA1_FMT_TLF_FONTSEL_PCT_D_216F
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  6(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     DATA_TLIBA1_FMT_TLF_ALIGN_PCT_D_2170
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    MOVE.W  8(A3),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     DATA_TLIBA1_FMT_TLF_PREGAP_PCT_D_2171
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    PEA     DATA_TLIBA1_STR_VALUE_2172
    JSR     FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     36(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   COI_GetAnimFieldPointerByMode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to COI_GetAnimFieldPointerByMode.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_COI_GetAnimFieldPointerByMode:
    JMP     COI_GetAnimFieldPointerByMode

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQDISP_GetEntryAuxPointerByMode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQDISP_GetEntryAuxPointerByMode.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode:
    JMP     ESQDISP_GetEntryAuxPointerByMode

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   LADFUNC_GetPackedPenLowNibble
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LADFUNC_GetPackedPenLowNibble.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble:
    JMP     LADFUNC_GetPackedPenLowNibble

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQDISP_GetEntryPointerByMode
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQDISP_GetEntryPointerByMode.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode:
    JMP     ESQDISP_GetEntryPointerByMode

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   COI_TestEntryWithinTimeWindow
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to COI_TestEntryWithinTimeWindow.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow:
    JMP     COI_TestEntryWithinTimeWindow

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry   (JumpStub_CLEANUP_FormatClockFormatEntry)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   CLEANUP_FormatClockFormatEntry
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to CLEANUP_FormatClockFormatEntry.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry:
    JMP     CLEANUP_FormatClockFormatEntry

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQDISP_ComputeScheduleOffsetForRow
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQDISP_ComputeScheduleOffsetForRow.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow:
    JMP     ESQDISP_ComputeScheduleOffsetForRow

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold   (JumpStub_ESQ_FindSubstringCaseFold)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_FindSubstringCaseFold
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_FindSubstringCaseFold.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_ESQ_FindSubstringCaseFold:
    JMP     ESQ_FindSubstringCaseFold

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   DISPLIB_FindPreviousValidEntryIndex
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to DISPLIB_FindPreviousValidEntryIndex.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_DISPLIB_FindPreviousValidEntryIndex:
    JMP     DISPLIB_FindPreviousValidEntryIndex

;------------------------------------------------------------------------------
; FUNC: TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   LADFUNC_GetPackedPenHighNibble
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LADFUNC_GetPackedPenHighNibble.
;------------------------------------------------------------------------------
TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble:
    JMP     LADFUNC_GetPackedPenHighNibble

;!======

    ; Alignment
    RTS
    DC.W    $0000
