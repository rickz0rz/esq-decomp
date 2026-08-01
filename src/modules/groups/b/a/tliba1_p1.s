    XDEF    _TLIBA1_DrawFormattedTextBlock
    XDEF    _TLIBA1_DrawInlineStyledText



;------------------------------------------------------------------------------
; FUNC: _TLIBA1_DrawInlineStyledText   (Render one text line with inline style markers)
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
;   _TLIBA1_DrawTextWithInsetSegments, _TLIBA1_ParseStyleCodeChar, _MEM_Move,
;   _TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble, _TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble, _STR_FindCharPtr,
;   _UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition, _LVOTextLength
; READS:
;   _Global_REF_GRAPHICS_LIBRARY, _CLOCK_AlignedInsetRenderGateFlag, _CLEANUP_AlignedInsetNibblePrimary, _CLEANUP_AlignedInsetNibbleSecondary, ff, if_eq_1780, if_eq_1787, if_ne_1773, return_1788
; WRITES:
;   _CLOCK_AlignedInsetRenderGateFlag
; DESC:
;   Parses inline marker sequences and chooses framed/plain drawing paths for a
;   single rendered text row.
; NOTES:
;   Updates _CLOCK_AlignedInsetRenderGateFlag gating flag after framed draw path.
;------------------------------------------------------------------------------
_TLIBA1_DrawInlineStyledText:
    LINK.W  A5,#-24
    MOVEM.L D2-D3/D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVEA.L 20(A5),A2
    MOVEQ   #0,D0
    MOVE.L  D0,-18(A5)
    MOVE.L  D0,-14(A5)
    TST.B   _CLOCK_AlignedInsetRenderGateFlag
    BEQ.S   .if_eq_1772

    PEA     19.W
    MOVE.L  A2,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .if_eq_1772

    PEA     20.W
    MOVE.L  A2,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .if_eq_1772

    MOVEQ   #0,D0
    MOVE.B  _CLEANUP_AlignedInsetNibbleSecondary,D0
    MOVEQ   #0,D1
    MOVE.B  _CLEANUP_AlignedInsetNibblePrimary,D1
    MOVE.L  A2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _TLIBA1_DrawTextWithInsetSegments

    LEA     24(A7),A7
    CLR.B   _CLOCK_AlignedInsetRenderGateFlag
    BRA.W   .return_1788

.if_eq_1772:
    PEA     30.W
    MOVE.L  A2,-(A7)
    JSR     _STR_FindCharPtr(PC)

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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    ADD.L   D0,-14(A5)
    CMPI.L  #$2,-22(A5)
    BLE.S   .if_le_1776

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  1(A0),D0
    MOVE.L  D0,-(A7)
    BSR.W   _TLIBA1_ParseStyleCodeChar

    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  2(A0),D1
    MOVE.L  D1,(A7)
    MOVE.B  D0,-10(A5)
    BSR.W   _TLIBA1_ParseStyleCodeChar

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
    JSR     _MEM_Move(PC)

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
    JSR     _MEM_Move(PC)

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
    JSR     _MEM_Move(PC)

    LEA     20(A7),A7
    MOVEA.L -4(A5),A0
    ADDQ.L  #1,A0
    MOVE.L  -22(A5),D0
    SUBQ.L  #3,D0
    MOVEA.L A3,A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    JSR     _STR_FindCharPtr(PC)

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
    BSR.W   _TLIBA1_DrawTextWithInsetSegments

    LEA     24(A7),A7
    BRA.W   .return_1788

.if_eq_1780:
    PEA     23.W
    MOVE.L  A2,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .if_eq_1787

    MOVEA.L D0,A0
    MOVE.B  #$13,(A0)+
    MOVE.L  A0,-4(A5)
    MOVEA.L A3,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    JSR     _TLIBA1_JMPTBL_LADFUNC_ExtractHighNibble(PC)

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
    JSR     _TLIBA1_JMPTBL_LADFUNC_ExtractLowNibble(PC)

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
    BSR.W   _TLIBA1_DrawTextWithInsetSegments

    LEA     24(A7),A7
    BRA.S   .return_1788

.if_eq_1787:
    MOVE.L  A2,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _UNKNOWN_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.return_1788:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _TLIBA1_DrawFormattedTextBlock   (Layout and draw a multi-line formatted block)
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
;   _TLIBA1_DrawInlineStyledText, _MATH_DivS32, _MATH_Mulu32, _MEMORY_AllocateMemory,
;   _MEMORY_DeallocateMemory, _LVOSetAPen, _LVOSetFont, _LVOTextLength
; READS:
;   _Global_HANDLE_PREVUE_FONT, _Global_REF_GRAPHICS_LIBRARY, _Global_STR_TLIBA1_C_3, _CLOCK_AlignedInsetRenderGateFlag, _TLIBA1_STR_TLIBA1_DOT_C, _CLEANUP_AlignedInsetNibblePrimary, _TEXTDISP_LinePenOverrideEnabledFlag, MEMF_CLEAR, MEMF_PUBLIC, if_eq_178F, if_eq_1792, if_eq_1794, if_eq_1798, if_eq_1799, if_ge_17A6, loop_179C, return_17A7, skip_179A, skip_179B
; WRITES:
;   (none observed)
; DESC:
;   Tokenizes source text into render runs, computes per-line offsets/fonts,
;   then renders each line with _TLIBA1_DrawInlineStyledText.
; NOTES:
;   Uses a temporary 10-byte record table per emitted line.
;------------------------------------------------------------------------------
_TLIBA1_DrawFormattedTextBlock:
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
    JSR     _MATH_Mulu32(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     2115.W
    PEA     _Global_STR_TLIBA1_C_3
    JSR     _MEMORY_AllocateMemory(PC)

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
    MOVEA.L _Global_HANDLE_PREVUE_FONT,A0
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
    JSR     _MATH_DivS32(PC)

    MOVE.B  25(A3),-21(A5)
    MOVE.L  52(A3),-26(A5)
    CLR.W   -12(A5)
    MOVE.W  D0,-30(A5)
    MOVE.W  D0,-34(A5)

.loop_179C:
    MOVE.W  -12(A5),D0
    CMP.W   -18(A5),D0
    BGE.W   .if_ge_17A6

    TST.W   _TEXTDISP_LinePenOverrideEnabledFlag
    BEQ.S   .if_eq_179D

    MULS    #10,D0
    MOVEA.L -4(A5),A0
    MOVE.W  0(A0,D0.L),D1
    EXT.L   D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

.if_eq_179D:
    MOVE.W  -12(A5),D0
    MULS    #10,D0
    MOVEA.L -4(A5),A0
    TST.W   4(A0,D0.L)
    BEQ.S   .if_eq_179E

    MOVEA.L A3,A1
    MOVEA.L _Global_HANDLE_PREVUE_FONT,A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    BRA.S   .skip_179F

.if_eq_179E:
    MOVEA.L A3,A1
    MOVEA.L -26(A5),A0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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

    TST.B   _CLOCK_AlignedInsetRenderGateFlag
    BEQ.S   .if_eq_17A1

    MOVEQ   #0,D1
    MOVE.B  _CLEANUP_AlignedInsetNibblePrimary,D1
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
    BSR.W   _TLIBA1_DrawInlineStyledText

    LEA     16(A7),A7
    ADDQ.W  #1,-12(A5)
    BRA.W   .loop_179C

.if_ge_17A6:
    MOVE.B  -21(A5),D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A3,A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEA.L -26(A5),A0
    JSR     _LVOSetFont(A6)

    TST.L   -4(A5)
    BEQ.S   .return_17A7

    MOVE.W  -18(A5),D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     _MATH_Mulu32(PC)

    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     2385.W
    PEA     _TLIBA1_STR_TLIBA1_DOT_C
    JSR     _MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return_17A7:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======