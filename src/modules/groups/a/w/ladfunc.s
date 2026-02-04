;------------------------------------------------------------------------------
; FUNC: LADFUNC_UpdateHighlightState   (UpdateHighlightState)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0
; CALLS:
;   (none)
; READS:
;   LAB_1BC4, LAB_2251, LAB_2270
; WRITES:
;   WDISP_HighlightActive, WDISP_HighlightIndex, [A3] fields
; DESC:
;   Clears highlight state and walks banner rectangles to mark the active one.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46) via compare against 46.
;------------------------------------------------------------------------------
; Mark banner rectangles that should be highlighted based on the current cursor slot.
LADFUNC_UpdateHighlightState:
    MOVEM.L D7/A3,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,WDISP_HighlightActive
    MOVE.W  D0,WDISP_HighlightIndex
    MOVE.B  LAB_1BC4,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .done

    MOVEQ   #0,D7

.rect_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    CLR.W   4(A3)
    MOVE.W  LAB_2270,D0
    MOVE.W  (A3),D1
    CMP.W   D0,D1
    BGT.S   .next_rect

    MOVE.W  2(A3),D1
    CMP.W   D0,D1
    BLT.S   .next_rect

    TST.L   6(A3)
    BEQ.S   .next_rect

    MOVEQ   #1,D0
    MOVE.W  D0,4(A3)
    MOVE.W  D0,WDISP_HighlightActive

.next_rect:
    ADDQ.L  #1,D7
    BRA.S   .rect_loop

.done:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_AllocBannerRectEntries   (Allocate banner rect entries??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/D7/A0-A1 ??
; CALLS:
;   NEWGRID_JMPTBL_AllocateMemory
; READS:
;   LAB_2251, GLOB_STR_LADFUNC_C_1
; WRITES:
;   LAB_2251 (entry pointers)
; DESC:
;   Allocates 14-byte structs for each banner rectangle slot.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
LADFUNC_AllocBannerRectEntries:
LAB_0E09:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.alloc_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     14.W
    PEA     116.W
    PEA     GLOB_STR_LADFUNC_C_1
    MOVE.L  A0,20(A7)
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 4(A7),A0
    MOVE.L  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   .alloc_loop

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_FreeBannerRectEntries   (Free banner rect entries??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/D6-D7/A0-A2 ??
; CALLS:
;   LAB_0B44, NEWGRID_JMPTBL_DeallocateMemory
; READS:
;   LAB_2251, GLOB_STR_LADFUNC_C_2, GLOB_STR_LADFUNC_C_3
; WRITES:
;   LAB_2251 (entry pointers)
; DESC:
;   Frees per-entry buffers (if present) and the entry structs themselves.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
LADFUNC_FreeBannerRectEntries:
LAB_0E0C:
    MOVEM.L D6-D7/A2,-(A7)
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.W   .done

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   .next_entry

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   6(A2)
    BEQ.S   .no_text

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

.find_null:
    TST.B   (A0)+
    BNE.S   .find_null

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    CLR.L   -(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    BRA.S   .after_len

.no_text:
    MOVEQ   #0,D6

.after_len:
    TST.L   D6
    BLE.S   .after_free_text

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   10(A2)
    BEQ.S   .after_free_text

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     147.W
    PEA     GLOB_STR_LADFUNC_C_2
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.after_free_text:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    PEA     14.W
    MOVE.L  (A0),-(A7)
    PEA     150.W
    PEA     GLOB_STR_LADFUNC_C_3
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    CLR.L   (A0)

.next_entry:
    ADDQ.L  #1,D7
    BRA.W   .entry_loop

.done:
    MOVEM.L (A7)+,D6-D7/A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_ClearBannerRectEntries   (Clear banner rect entries??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/D7/A0-A3 ??
; CALLS:
;   (none)
; READS:
;   LAB_2251, LAB_1DCD
; WRITES:
;   LAB_2251 entry fields, LAB_21FB, LAB_2291, LAB_2265, LAB_2293,
;   WDISP_HighlightActive, WDISP_HighlightIndex
; DESC:
;   Clears entry fields and resets highlight/row-count globals.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
LADFUNC_ClearBannerRectEntries:
LAB_0E14:
    MOVEM.L D7/A3,-(A7)
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.W   D0,D7
    BGE.S   .after_loop

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A3
    MOVEQ   #0,D0
    MOVE.W  D0,(A3)
    MOVE.W  D0,2(A3)
    MOVE.W  D0,4(A3)
    SUBA.L  A0,A0
    MOVE.L  A0,6(A3)
    MOVE.L  A0,10(A3)
    ADDQ.W  #1,D7
    BRA.S   .entry_loop

.after_loop:
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2291
    MOVE.W  D0,LAB_2265
    MOVE.W  D0,LAB_2293
    MOVE.W  D0,WDISP_HighlightActive
    MOVE.W  D0,WDISP_HighlightIndex
    MOVEQ   #0,D0
    MOVE.B  LAB_1DCD,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,LAB_21FB
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_RebuildEntryTextBuffers   (Rebuild entry text buffers??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0/D6-D7/A0-A2 ??
; CALLS:
;   LAB_0B44, NEWGRID_JMPTBL_DeallocateMemory
; READS:
;   LAB_2251, GLOB_STR_LADFUNC_C_4
; WRITES:
;   entry buffers via LAB_2251
; DESC:
;   Recomputes per-entry text buffers for banner rectangles.
; NOTES:
;   Loop count is 47 iterations (D7 from 0..46).
;------------------------------------------------------------------------------
LADFUNC_RebuildEntryTextBuffers:
LAB_0E17:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2,-(A7)
    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.W   D0,D7
    BGE.W   .done

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   .next_entry

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   6(A2)
    BEQ.W   .next_entry

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

.scan_text:
    TST.B   (A0)+
    BNE.S   .scan_text

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    TST.L   D6
    BLE.S   .update_entry

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    TST.L   10(A2)
    BEQ.S   .update_entry

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     212.W
    PEA     GLOB_STR_LADFUNC_C_4
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.update_entry:
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    CLR.L   -(A7)
    MOVE.L  A2,24(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVEA.L 16(A7),A0
    MOVE.L  D0,6(A0)

.next_entry:
    ADDQ.W  #1,D7
    BRA.W   .entry_loop

.done:
    BSR.W   LAB_0E14

    MOVEM.L (A7)+,D6-D7/A2
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_UpdateHighlightCycle   (Update highlight cycle??)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1 ??
; CALLS:
;   JMPTBL_MATH_DivS32_3, LADFUNC_BuildHighlightLinesFromText
; READS:
;   WDISP_HighlightActive, LAB_2291, LAB_2292, LAB_2265, LAB_2251
; WRITES:
;   LAB_2265, LAB_2291
; DESC:
;   Advances the highlighted entry when active and refreshes the display.
; NOTES:
;   Resets LAB_2291 from LAB_2292 when the countdown underflows.
;------------------------------------------------------------------------------
LADFUNC_UpdateHighlightCycle:
    MOVE.W  WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   .maybe_reset

    MOVE.W  LAB_2291,D0
    BLE.S   .maybe_reset

.find_next_highlight:
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVE.W  D1,LAB_2265
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #1,D0
    CMP.W   4(A1),D0
    BNE.S   .find_next_highlight

    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    BSR.W   LADFUNC_BuildHighlightLinesFromText

    ADDQ.W  #4,A7
    MOVE.W  LAB_2291,D0
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVE.W  D1,LAB_2291

.maybe_reset:
    MOVE.W  WDISP_HighlightActive,D0
    SUBQ.W  #1,D0
    BNE.S   .return

    MOVE.W  LAB_2291,D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BGE.S   .return

    MOVE.W  LAB_2292,LAB_2291

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_BuildHighlightLinesFromText   (Build highlight lines from text??)
; ARGS:
;   stack +4: const u8* textPtr ??
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   GROUP_AW_JMPTBL_LAB_0552, _LVOTextLength
; READS:
;   LAB_2254, LAB_225A, LAB_225B, GLOB_REF_RASTPORT_1
; WRITES:
;   LAB_2254, LAB_225A, LAB_225B, stack buffer (-89)
; DESC:
;   Splits a text string into displayable segments and populates line buffers.
; NOTES:
;   Treats bytes 24/25/26 as control codes and hard line breaks.
;------------------------------------------------------------------------------
LADFUNC_BuildHighlightLinesFromText:
LAB_0E20:
    LINK.W  A5,#-92
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ADD.L   D0,D0
    LEA     LAB_225B,A0
    ADDA.L  D0,A0
    MOVE.W  #4,(A0)
    MOVE.W  LAB_2254,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2254
    MOVEQ   #20,D0
    CMP.W   D0,D1
    BCS.S   .init_parse

    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2254

.init_parse:
    MOVEQ   #0,D6
    MOVE.L  #624,D7
    MOVE.B  (A3),D5
    MOVEQ   #24,D0
    CMP.B   D0,D5
    BEQ.S   .skip_control_prefix

    MOVEQ   #25,D0
    CMP.B   D0,D5
    BEQ.S   .skip_control_prefix

    MOVEQ   #26,D0
    CMP.B   D0,D5
    BNE.S   .next_char

.skip_control_prefix:
    ADDQ.L  #1,A3

.next_char:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-7(A5)
    TST.B   D0
    BEQ.W   .flush_final

    MOVEQ   #13,D1
    CMP.B   D1,D0
    BEQ.S   .next_char

    MOVEQ   #10,D1
    CMP.B   D1,D0
    BNE.S   .check_flush_or_control

    BRA.S   .next_char

.check_flush_or_control:
    TST.L   D7
    BLE.S   .flush_segment

    MOVEQ   #24,D1
    CMP.B   D1,D0
    BEQ.S   .flush_segment

    MOVEQ   #25,D1
    CMP.B   D1,D0
    BEQ.S   .flush_segment

    MOVEQ   #26,D1
    CMP.B   D1,D0
    BNE.S   .append_char

.flush_segment:
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    CLR.B   -89(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    PEA     -89(A5)
    JSR     GROUP_AW_JMPTBL_LAB_0552(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ASL.L   #2,D0
    LEA     LAB_225A,A0
    ADDA.L  D0,A0
    LEA     -89(A5),A1
    MOVEA.L (A0),A2

.copy_segment:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_segment

    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ADD.L   D0,D0
    LEA     LAB_225B,A0
    ADDA.L  D0,A0
    MOVEQ   #0,D0
    MOVE.W  D0,(A0)
    MOVE.W  LAB_2254,D1
    MOVE.L  D1,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,LAB_2254
    MOVEQ   #20,D1
    CMP.W   D1,D2
    BCS.S   .segment_done

    MOVE.W  D0,LAB_2254

.segment_done:
    MOVE.L  D0,D6
    MOVE.L  #624,D7
    MOVE.B  -7(A5),D5
    BRA.W   .next_char

.append_char:
    MOVE.L  D6,D1
    ADDQ.W  #1,D6
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.B  D0,-89(A5,D2.L)
    MOVEA.L GLOB_REF_RASTPORT_1,A1
    LEA     -7(A5),A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    SUB.L   D0,D7
    BRA.W   .next_char

.flush_final:
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    CLR.B   -89(A5,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    PEA     -89(A5)
    JSR     GROUP_AW_JMPTBL_LAB_0552(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ASL.L   #2,D0
    LEA     LAB_225A,A0
    ADDA.L  D0,A0
    LEA     -89(A5),A1
    MOVEA.L (A0),A2

.copy_final:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_final

    MOVEQ   #0,D0
    MOVE.W  LAB_2254,D0
    ADD.L   D0,D0
    LEA     LAB_225B,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  D0,(A1)
    MOVE.W  LAB_2254,D1
    MOVE.L  D1,D2
    ADDQ.W  #1,D2
    MOVE.W  D2,LAB_2254
    MOVEQ   #20,D1
    CMP.W   D1,D2
    BCS.S   .advance_slot

    MOVE.W  D0,LAB_2254

.advance_slot:
    MOVEQ   #0,D2
    MOVE.W  LAB_2254,D2
    ADD.L   D2,D2
    ADDA.L  D2,A0
    MOVE.W  #4,(A0)
    MOVE.W  LAB_2254,D2
    MOVE.L  D2,D3
    ADDQ.W  #1,D3
    MOVE.W  D3,LAB_2254
    CMP.W   D1,D3
    BCS.S   .return

    MOVE.W  D0,LAB_2254

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_ParseHexDigit   (Parse hex digit??)
; ARGS:
;   stack +4: u8 char ??
; RET:
;   D0: u8 value (0..15) or 0 if invalid ??
; CLOBBERS:
;   D0/D7/A0-A1 ??
; CALLS:
;   (none)
; READS:
;   LAB_21A8
; WRITES:
;   (none)
; DESC:
;   Converts an ASCII hex digit into a numeric value.
; NOTES:
;   Uses LAB_21A8 flags to classify digits/letters.
;------------------------------------------------------------------------------
LADFUNC_ParseHexDigit:
LAB_0E2D:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     LAB_21A8,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .check_alpha

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    BRA.S   .return

.check_alpha:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.S   .return_zero

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .alpha_offset

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .apply_alpha_bias

.alpha_offset:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

.apply_alpha_bias:
    MOVEQ   #55,D1
    SUB.L   D1,D0
    BRA.S   .return

.return_zero:
    MOVEQ   #0,D0

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_ParseBannerEntryData   (Parse banner entry data??)
; ARGS:
;   stack +4: u8 entryKind ??
;   stack +8: const u8* streamPtr ??
; RET:
;   D0: u16 success flag (0/1) ??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LADFUNC_ParseHexDigit, LAB_0EE5, LAB_0EE6, LAB_0EE7, LAB_0AC6, LAB_0B44,
;   NEWGRID_JMPTBL_AllocateMemory, NEWGRID_JMPTBL_DeallocateMemory,
;   GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper, LADFUNC_UpdateHighlightState
; READS:
;   LAB_1BC4, LAB_1FBF, LAB_1FC0, LAB_2251, LAB_2293, LAB_2299
; WRITES:
;   LAB_2293, LAB_2251 entry buffers, WDISP_HighlightActive
; DESC:
;   Parses an encoded entry record and updates entry buffers and metadata.
; NOTES:
;   Control code 3 appears to change attributes via hex nibbles.
;------------------------------------------------------------------------------
LADFUNC_ParseBannerEntryData:
LAB_0E33:
    LINK.W  A5,#-416
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVE.B  11(A5),D7
    MOVEA.L 12(A5),A3
    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    ADDQ.W  #8,A7
    MOVE.B  (A3)+,D5
    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.B  D0,-413(A5)
    MOVEQ   #73,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .check_entry_prefix

    MOVEQ   #76,D0
    CMP.B   D0,D7
    BEQ.S   .maybe_refresh

    MOVEQ   #116,D0
    CMP.B   D0,D7
    BNE.S   .return_zero

.maybe_refresh:
    MOVE.W  LAB_2299,D0
    SUBQ.W  #1,D0
    BNE.S   .return_zero

    MOVE.B  LAB_1BC4,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FBF
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return_zero

    BSR.W   LADFUNC_RebuildEntryTextBuffers

.return_zero:
    MOVEQ   #0,D0
    BRA.W   .return

.check_entry_prefix:
    MOVEQ   #76,D0
    CMP.B   D0,D7
    BEQ.S   .check_allowed_entry

    MOVEQ   #116,D0
    CMP.B   D0,D7
    BNE.S   .return_zero_local2

.check_allowed_entry:
    MOVE.B  LAB_1BC4,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     LAB_1FC0
    JSR     GROUP_AS_JMPTBL_UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return_zero_local

    MOVEQ   #46,D0
    CMP.B   D0,D5
    BCC.S   .return_zero_local

    MOVE.W  LAB_2293,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,LAB_2293
    MOVEQ   #46,D0
    CMP.W   D0,D1
    BLT.S   .setup_entry

.return_zero_local:
    MOVEQ   #0,D0
    BRA.W   .return

.setup_entry:
    SUBQ.B  #1,D5
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     LAB_2251,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A2
    BRA.S   .init_entry_buffers

.return_zero_local2:
    MOVEQ   #0,D0
    BRA.W   .return

.init_entry_buffers:
    MOVE.W  #1,(A2)
    MOVE.W  #$30,2(A2)
    MOVEQ   #0,D6
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     304.W
    PEA     367.W
    PEA     GLOB_STR_LADFUNC_C_5
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-412(A5)
    BEQ.W   .return_zero_local3

.parse_loop:
    MOVE.B  (A3)+,D4
    TST.B   D4
    BEQ.W   .finish_parse

    CMPI.W  #$190,D6
    BGE.W   .finish_parse

    MOVEQ   #3,D0
    CMP.B   D0,D4
    BNE.S   .check_set_fields

    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LADFUNC_ParseHexDigit

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    CMP.B   D0,D4
    BCS.S   .parse_second_nibble

    MOVEQ   #7,D0
    CMP.B   D0,D4
    BHI.S   .parse_second_nibble

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVEQ   #0,D1
    MOVE.B  -413(A5),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE6

    ADDQ.W  #8,A7
    MOVE.B  D0,-413(A5)

.parse_second_nibble:
    MOVE.B  (A3)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LADFUNC_ParseHexDigit

    ADDQ.W  #4,A7
    MOVE.L  D0,D4
    MOVEQ   #0,D0
    CMP.B   D0,D4
    BCS.S   .parse_loop

    MOVEQ   #7,D0
    CMP.B   D0,D4
    BHI.S   .parse_loop

    MOVEQ   #0,D0
    MOVE.B  -413(A5),D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE7

    ADDQ.W  #8,A7
    MOVE.B  D0,-413(A5)
    BRA.S   .parse_loop

.check_set_fields:
    MOVEQ   #20,D0
    CMP.B   D0,D4
    BNE.S   .emit_char

    MOVEQ   #0,D0
    MOVE.B  (A3)+,D0
    MOVE.W  D0,(A2)
    MOVEQ   #0,D1
    MOVE.B  (A3)+,D1
    MOVE.W  D1,2(A2)
    MOVE.W  (A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     LAB_0AC6(PC)

    MOVE.B  D0,D1
    EXT.W   D1
    MOVE.W  D1,(A2)
    MOVE.W  2(A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    JSR     LAB_0AC6(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,D1
    EXT.W   D1
    MOVE.W  D1,2(A2)
    BRA.W   .parse_loop

.emit_char:
    MOVEA.L -412(A5),A0
    MOVE.B  -413(A5),0(A0,D6.W)
    MOVE.L  D6,D0
    ADDQ.W  #1,D6
    LEA     -407(A5),A0
    ADDA.W  D0,A0
    MOVE.B  D4,(A0)
    BRA.W   .parse_loop

.finish_parse:
    LEA     -407(A5),A0
    MOVEA.L A0,A1
    ADDA.W  D6,A1
    CLR.B   (A1)
    MOVE.L  6(A2),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,6(A2)
    TST.L   10(A2)
    BEQ.S   .alloc_attr_buffer

    PEA     304.W
    MOVE.L  10(A2),-(A7)
    PEA     412.W
    PEA     GLOB_STR_LADFUNC_C_6
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.alloc_attr_buffer:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     413.W
    PEA     GLOB_STR_LADFUNC_C_7
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,10(A2)
    TST.L   D0
    BEQ.S   .free_temp

    MOVE.L  D6,D1
    EXT.L   D1
    MOVEA.L -412(A5),A0
    MOVEA.L D0,A1
    BRA.S   .copy_attr_next

.copy_attr_loop:
    MOVE.B  (A0)+,(A1)+

.copy_attr_next:
    SUBQ.L  #1,D1
    BCC.S   .copy_attr_loop

.free_temp:
    PEA     304.W
    MOVE.L  -412(A5),-(A7)
    PEA     416.W
    PEA     GLOB_STR_LADFUNC_C_8
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    BSR.W   LADFUNC_UpdateHighlightState

    LEA     16(A7),A7
    BRA.S   .return_one

.return_zero_local3:
    MOVEQ   #0,D0
    BRA.S   .return

.return_one:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_SaveTextAdsToFile   (Save text ads to file??)
; ARGS:
;   (none)
; RET:
;   D0: 0/(-1) status ??
; CLOBBERS:
;   D0-D7/A0-A1 ??
; CALLS:
;   LAB_0EE5, GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer,
;   LAB_0F96, LAB_0F97, LAB_0F98, GROUP_AW_JMPTBL_WDISP_SPrintf
; READS:
;   LAB_1B9F, LAB_1FB6, LAB_1FC5, LAB_1FC6, LAB_2251, LAB_2320
; WRITES:
;   LAB_1B9F, LAB_2320
; DESC:
;   Encodes entry text/attribute data and writes it to a file.
; NOTES:
;   Emits attribute changes using LAB_1FC5 and terminates entries with LAB_1FC6.
;------------------------------------------------------------------------------
LADFUNC_SaveTextAdsToFile:
LAB_0E48:
    LINK.W  A5,#-36
    MOVEM.L D4-D7,-(A7)
    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    ADDQ.W  #8,A7
    MOVE.B  D0,-25(A5)
    TST.L   LAB_1B9F
    BNE.S   .open_file

    MOVEQ   #0,D0
    BRA.W   .return

.open_file:
    CLR.L   LAB_1B9F
    CLR.B   -15(A5)
    PEA     MODE_NEWFILE.W
    PEA     LAB_1FB6
    JSR     GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_2320
    TST.L   D0
    BNE.S   .start_entry_loop

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F
    MOVEQ   #-1,D0
    BRA.W   .return

.start_entry_loop:
    MOVEQ   #0,D6

.entry_loop:
    MOVEQ   #46,D0
    CMP.W   D0,D6
    BGE.W   .close_file

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.W  (A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F96(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  2(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F96(PC)

    LEA     12(A7),A7
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BNE.S   .use_entry_text

    LEA     -15(A5),A1
    MOVE.L  A1,-8(A5)
    BRA.S   .text_ptr_ready

.use_entry_text:
    MOVEA.L 6(A0),A0
    MOVE.L  A0,-8(A5)

.text_ptr_ready:
    MOVEA.L -8(A5),A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D7
    MOVEQ   #0,D4
    MOVE.L  D4,D5

.segment_loop:
    CMP.L   D7,D5
    BGE.W   .write_linebreak

    CMP.L   D4,D7
    BEQ.S   .flush_segment

    MOVEA.L -4(A5),A1
    MOVEA.L 10(A1),A0
    ADDA.L  D4,A0
    MOVE.B  (A0),D0
    MOVE.B  -25(A5),D1
    CMP.B   D1,D0
    BEQ.S   .next_char

.flush_segment:
    TST.L   D4
    BLE.S   .update_attr

    MOVEQ   #0,D0
    MOVE.B  -25(A5),D0
    MOVE.L  D0,-(A7)
    PEA     3.W
    PEA     LAB_1FC5
    PEA     -35(A5)
    JSR     GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     -35(A5),A0
    MOVEA.L A0,A1

.fmt_len_loop:
    TST.B   (A1)+
    BNE.S   .fmt_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F97(PC)

    MOVEA.L -8(A5),A0
    ADDA.L  D5,A0
    MOVE.L  D4,D0
    SUB.L   D5,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F97(PC)

    LEA     32(A7),A7
    MOVE.L  D4,D5

.update_attr:
    CMP.L   D7,D5
    BGE.S   .next_char

    MOVEA.L -4(A5),A1
    MOVEA.L 10(A1),A0
    ADDA.L  D4,A0
    MOVE.B  (A0),-25(A5)

.next_char:
    ADDQ.L  #1,D4
    BRA.W   .segment_loop

.write_linebreak:
    PEA     1.W
    PEA     LAB_1FC6
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F97(PC)

    LEA     12(A7),A7
    ADDQ.W  #1,D6
    BRA.W   .entry_loop

.close_file:
    MOVE.L  LAB_2320,-(A7)
    JSR     LAB_0F98(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,LAB_1B9F

.return:
    MOVEM.L -52(A5),D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_LoadTextAdsFromFile   (Load text ads from file??)
; ARGS:
;   (none)
; RET:
;   D0: 0 on success, -1 on failure ??
; CLOBBERS:
;   D0-D7/A0-A1 ??
; CALLS:
;   LAB_0EE5, LAB_0F9B, LAB_0F95, LAB_0F94, LADFUNC_ParseHexDigit,
;   LAB_0EE6, LAB_0EE7, NEWGRID_JMPTBL_AllocateMemory,
;   NEWGRID_JMPTBL_DeallocateMemory, LADFUNC_RebuildEntryTextBuffers
; READS:
;   GLOB_REF_LONG_FILE_SCRATCH, LAB_21BC, LAB_2251
; WRITES:
;   Entry text/attr buffers (6/10 offsets), LAB_21BC scratch ptr ??
; DESC:
;   Reads encoded entry data and rebuilds per-entry text and attribute buffers.
; NOTES:
;   Control code 3 carries hex nibbles that update the attribute byte.
;------------------------------------------------------------------------------
LADFUNC_LoadTextAdsFromFile:
LAB_0E57:
    LINK.W  A5,#-40
    MOVEM.L D2/D4-D7,-(A7)

    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    PEA     LAB_1FB6
    MOVE.B  D0,-29(A5)
    JSR     LAB_0F9B(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .file_opened

    MOVEQ   #-1,D0
    BRA.W   .return

.file_opened:
    MOVE.L  GLOB_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  LAB_21BC,-12(A5)
    BSR.W   LADFUNC_RebuildEntryTextBuffers

    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.W   .free_file_buffer

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    JSR     LAB_0F95(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  D0,(A0)
    JSR     LAB_0F95(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  D0,2(A0)
    JSR     LAB_0F94(PC)

    MOVEA.L D0,A0

.scan_encoded_end:
    TST.B   (A0)+
    BNE.S   .scan_encoded_end

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D4
    MOVE.L  D0,-34(A5)
    MOVE.L  D0,-8(A5)

.measure_text_len:
    TST.L   D4
    BLE.S   .alloc_or_free

    MOVEA.L -34(A5),A0
    TST.B   (A0)
    BEQ.S   .alloc_or_free

    MOVEQ   #3,D0
    CMP.B   (A0),D0
    BNE.S   .advance_len_ptr

    SUBQ.L  #3,D4
    ADDQ.L  #2,-34(A5)

.advance_len_ptr:
    ADDQ.L  #1,-34(A5)
    BRA.S   .measure_text_len

.alloc_or_free:
    TST.L   D4
    BLE.W   .free_existing_buffers

    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     591.W
    PEA     GLOB_STR_LADFUNC_C_9
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,6(A0)
    TST.L   D0
    BNE.S   .alloc_attr_buffer

    MOVEQ   #-1,D0
    BRA.W   .return

.alloc_attr_buffer:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D4,-(A7)
    PEA     600.W
    PEA     GLOB_STR_LADFUNC_C_10
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,10(A0)
    BNE.S   .decode_loop

    MOVEQ   #-1,D0
    BRA.W   .return

.decode_loop:
    MOVEQ   #0,D5
    MOVE.L  -8(A5),-34(A5)

.decode_loop_next:
    CMP.L   D4,D5
    BGE.W   .finish_entry

    MOVEA.L -34(A5),A0
    TST.B   (A0)
    BEQ.W   .finish_entry

    MOVE.B  (A0),D0
    MOVEQ   #3,D1
    CMP.B   D1,D0
    BNE.S   .emit_char

    ADDQ.L  #1,-34(A5)
    MOVEA.L -34(A5),A0
    MOVE.B  (A0)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-34(A5)
    BSR.W   LADFUNC_ParseHexDigit

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.B  -29(A5),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_0EE6

    MOVE.L  -34(A5),-34(A5)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L -34(A5),A0
    MOVE.B  (A0),D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.B  D0,-29(A5)
    MOVE.L  D1,28(A7)
    BSR.W   LADFUNC_ParseHexDigit

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  28(A7),-(A7)
    BSR.W   LAB_0EE7

    LEA     12(A7),A7
    MOVE.B  D0,-29(A5)
    BRA.S   .advance_decode_ptr

.emit_char:
    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D5,A0
    MOVE.B  D0,(A0)
    MOVEA.L 10(A1),A0
    ADDA.L  D5,A0
    ADDQ.L  #1,D5
    MOVE.B  -29(A5),(A0)

.advance_decode_ptr:
    ADDQ.L  #1,-34(A5)
    BRA.W   .decode_loop_next

.finish_entry:
    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    MOVEA.L A0,A1
    ADDA.L  D5,A1
    CLR.B   (A1)
    BRA.S   .next_entry

.free_existing_buffers:
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BEQ.S   .next_entry

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0

.scan_existing_len:
    TST.B   (A0)+
    BNE.S   .scan_existing_len

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D4
    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A1),-(A7)
    PEA     638.W
    PEA     GLOB_STR_LADFUNC_C_11
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7
    SUBA.L  A0,A0
    MOVEA.L -4(A5),A1
    MOVE.L  A0,6(A1)
    TST.L   10(A1)
    BEQ.S   .next_entry

    MOVE.L  D4,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     642.W
    PEA     GLOB_STR_LADFUNC_C_12
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    CLR.L   10(A0)

.next_entry:
    ADDQ.L  #1,D7
    BRA.W   .entry_loop

.free_file_buffer:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     653.W
    PEA     GLOB_STR_LADFUNC_C_13
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    MOVEQ   #0,D0

.return:
    MOVEM.L -60(A5),D2/D4-D7

    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_DisplayTextPackedPens   (Display text with packed pens??)
; ARGS:
;   stack +4: RastPort* rp ??
;   stack +8: u16 x ??
;   stack +12: u16 y ??
;   stack +16: u8 packedPens (hi=BPen, lo=APen) ??
;   stack +20: const u8* textPtr ??
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/D5-D7/A1-A3/A6 ??
; CALLS:
;   LAB_0EE9, LAB_0EE8, _LVOSetAPen, _LVOSetBPen, JMPTBL_DISPLIB_DisplayTextAtPosition_3
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none)
; DESC:
;   Sets APen/BPen from packed nibble and draws text at position.
; NOTES:
;   Packed pen byte uses low nibble for APen and high nibble for BPen.
;------------------------------------------------------------------------------
LADFUNC_DisplayTextPackedPens:
LAB_0E69:
    MOVEM.L D5-D7/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  28(A7),D7
    MOVE.L  32(A7),D6
    MOVE.B  39(A7),D5
    MOVEA.L 40(A7),A2
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE9

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  D0,(A7)
    BSR.W   LAB_0EE8

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A3,A1
    MOVE.L  D1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetBPen(A6)

    MOVE.L  A2,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     JMPTBL_DISPLIB_DisplayTextAtPosition_3(PC)

    LEA     16(A7),A7
    MOVEM.L (A7)+,D5-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_DrawEntryLineWithAttrs   (Draw entry line with attributes??)
; ARGS:
;   stack +4: struct* uiCtx ?? (A3)
;   stack +8: u16 lineIndex ?? (D7)
;   stack +12: const u8* textPtr ?? (A2)
;   stack +16: const u8* attrPtr ?? (A5+20)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   _LVOTextLength, NEWGRID_JMPTBL_MATH_Mulu32, JMPTBL_MATH_DivS32_3,
;   NEWGRID_JMPTBL_AllocateMemory, NEWGRID_JMPTBL_DeallocateMemory,
;   LADFUNC_DisplayTextPackedPens
; READS:
;   GLOB_STR_SINGLE_SPACE_1, LAB_21FB
; WRITES:
;   (none)
; DESC:
;   Splits a line into attribute runs and renders them centered within bounds.
; NOTES:
;   Control codes 24/25/26 affect leading alignment/attributes.
;------------------------------------------------------------------------------
LADFUNC_DrawEntryLineWithAttrs:
LAB_0E6A:
    LINK.W  A5,#-44
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVEQ   #0,D6
    MOVEA.L A3,A1
    LEA     GLOB_STR_SINGLE_SPACE_1,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-26(A5)
    MOVE.L  #624,D0
    MOVE.L  -26(A5),D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVE.L  D0,-22(A5)
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BLE.S   .cap_columns

    MOVE.L  D1,-22(A5)

.cap_columns:
    MOVE.L  -22(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     712.W
    PEA     GLOB_STR_LADFUNC_C_14
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .return

    MOVE.B  (A2),D1
    MOVEQ   #24,D2
    CMP.B   D2,D1
    BEQ.S   .control_prefix

    MOVEQ   #25,D2
    CMP.B   D2,D1
    BEQ.S   .control_prefix

    MOVEQ   #26,D2
    CMP.B   D2,D1
    BNE.S   .text_ptr_ready

.control_prefix:
    MOVE.L  D1,D6
    MOVEA.L 20(A5),A0
    MOVE.B  (A0)+,D5
    ADDQ.L  #1,A2
    MOVE.L  A0,20(A5)

.text_ptr_ready:
    MOVEA.L A2,A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,-10(A5)
    MOVE.L  -22(A5),D1
    CMPA.L  D1,A0
    BLE.S   .length_ready

    MOVE.L  D1,-10(A5)

.length_ready:
    MOVE.L  -10(A5),D2
    MOVE.L  D1,D3
    SUB.L   D2,D3
    MOVEM.L D3,-30(A5)
    BLE.S   .prepare_offsets

    TST.B   D6
    BNE.S   .prepare_offsets

    MOVEA.L 20(A5),A0
    MOVE.B  0(A0,D2.L),D5

.prepare_offsets:
    MOVEA.L 4(A3),A0
    MOVEQ   #0,D2
    MOVE.W  (A0),D2
    ASL.L   #3,D2
    MOVE.L  -26(A5),D0
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D2
    TST.L   D2
    BPL.S   .x_offset_ready

    ADDQ.L  #1,D2

.x_offset_ready:
    ASR.L   #1,D2
    MOVEA.L 52(A3),A1
    MOVEQ   #0,D0
    MOVE.W  20(A1),D0
    MOVE.L  LAB_21FB,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.W  2(A0),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .y_offset_ready

    ADDQ.L  #1,D1

.y_offset_ready:
    ASR.L   #1,D1
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D4
    MOVE.W  20(A1),D4
    MOVE.L  D1,-38(A5)
    MOVE.L  D4,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,-38(A5)
    MOVE.L  D2,-34(A5)
    BGE.S   .clamp_x

    MOVEQ   #0,D0
    MOVE.L  D0,-34(A5)

.clamp_x:
    MOVE.L  -38(A5),D0
    TST.L   D0
    BPL.S   .clamp_y

    MOVEQ   #0,D0
    MOVE.L  D0,-38(A5)

.clamp_y:
    MOVEQ   #24,D0
    CMP.B   D0,D6
    BNE.S   .indent_for_26

    MOVEQ   #2,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .indent_ready

.indent_for_26:
    MOVEQ   #26,D0
    CMP.B   D0,D6
    BNE.S   .indent_default

    MOVEQ   #1,D0
    MOVE.L  D0,-14(A5)
    BRA.S   .indent_ready

.indent_default:
    MOVEQ   #0,D0
    MOVE.L  D0,-14(A5)

.indent_ready:
    TST.L   -14(A5)
    BEQ.S   .after_indent_draw

    TST.L   D3
    BEQ.S   .after_indent_draw

    MOVE.L  D3,D0
    MOVE.L  -14(A5),D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVEQ   #32,D1
    MOVEA.L -4(A5),A0
    BRA.S   .indent_fill_next

.indent_fill_loop:
    MOVE.B  D1,(A0)+

.indent_fill_next:
    SUBQ.L  #1,D0
    BCC.S   .indent_fill_loop

    MOVE.L  -30(A5),D0
    MOVE.L  -14(A5),D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVEA.L -4(A5),A0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LADFUNC_DisplayTextPackedPens

    LEA     20(A7),A7
    MOVE.L  -30(A5),D0
    MOVE.L  -14(A5),D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVE.L  -26(A5),D1
    MOVE.L  D0,32(A7)
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,-34(A5)
    MOVE.L  32(A7),D0
    SUB.L   D0,-30(A5)

.after_indent_draw:
    CLR.L   -14(A5)

.segment_loop:
    MOVE.L  -14(A5),D0
    CMP.L   -10(A5),D0
    BGE.W   .tail_spaces

    CLR.L   -18(A5)

.segment_scan:
    MOVE.L  -14(A5),D0
    MOVE.L  -18(A5),D1
    MOVE.L  D1,D2
    ADD.L   D0,D2
    CMP.L   -10(A5),D2
    BGE.S   .emit_segment

    MOVEA.L 20(A5),A0
    MOVE.B  0(A0,D0.L),D3
    CMP.B   0(A0,D2.L),D3
    BNE.S   .emit_segment

    ADD.L   D1,D0
    MOVEA.L -4(A5),A0
    MOVE.B  0(A2,D0.L),0(A0,D1.L)
    ADDQ.L  #1,-18(A5)
    BRA.S   .segment_scan

.emit_segment:
    MOVEA.L -4(A5),A0
    MOVE.L  -18(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVEA.L 20(A5),A1
    MOVE.L  -14(A5),D1
    MOVE.B  0(A1,D1.L),D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LADFUNC_DisplayTextPackedPens

    LEA     20(A7),A7
    MOVE.L  -26(A5),D0
    MOVE.L  -18(A5),D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,-34(A5)
    MOVE.L  -18(A5),D0
    ADD.L   D0,-14(A5)
    BRA.W   .segment_loop

.tail_spaces:
    TST.L   -30(A5)
    BEQ.S   .free_buffer

    MOVE.L  -30(A5),D0
    MOVEQ   #32,D1
    MOVEA.L -4(A5),A0
    BRA.S   .tail_fill_next

.tail_fill_loop:
    MOVE.B  D1,(A0)+

.tail_fill_next:
    SUBQ.L  #1,D0
    BCC.S   .tail_fill_loop

    MOVEA.L -4(A5),A0
    MOVE.L  -30(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -38(A5),-(A7)
    MOVE.L  -34(A5),-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LADFUNC_DisplayTextPackedPens

    LEA     20(A7),A7

.free_buffer:
    MOVE.L  -22(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     824.W
    PEA     GLOB_STR_LADFUNC_C_15
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_DrawEntryPreview   (Draw entry preview??)
; ARGS:
;   stack +4: u16 entryIndex ?? (D7)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A0-A3/A6 ??
; CALLS:
;   GROUP_AW_JMPTBL_LAB_183E, _LVOSetFont, _LVOTextLength,
;   JMPTBL_MATH_DivS32_3, NEWGRID_JMPTBL_AllocateMemory,
;   NEWGRID_JMPTBL_DeallocateMemory, _LVOSetDrMd, _LVOSetRast,
;   GROUP_AW_JMPTBL_LAB_0A49, GROUP_AW_JMPTBL_LAB_0A48,
;   LAB_0EE8, LADFUNC_DrawEntryLineWithAttrs
; READS:
;   LAB_2251, LAB_1FB8..LAB_1FBA, LAB_21FB, GLOB_HANDLE_H26F_FONT,
;   GLOB_HANDLE_PREVUEC_FONT
; WRITES:
;   LAB_2295..LAB_2297, LAB_22AB, LAB_2216
; DESC:
;   Builds line buffers and renders a preview for the selected entry.
; NOTES:
;   Splits text/attr streams on newline/control markers (24/25/26).
;------------------------------------------------------------------------------
LADFUNC_DrawEntryPreview:
LAB_0E83:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVE.L  8(A5),D7
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     GROUP_AW_JMPTBL_LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    MOVEA.L D0,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_H26F_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    LEA     GLOB_STR_SINGLE_SPACE_2,A0
    MOVEQ   #1,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,44(A7)
    MOVE.L  #624,D0
    MOVE.L  44(A7),D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVE.L  D0,D6
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D0,-(A7)
    PEA     857.W
    PEA     GLOB_STR_LADFUNC_C_16
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  D6,-(A7)
    PEA     858.W
    PEA     GLOB_STR_LADFUNC_C_17
    MOVE.L  D0,-4(A5)
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     36(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   -4(A5)
    BEQ.W   .cleanup

    TST.L   D0
    BEQ.W   .cleanup

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  6(A2),-8(A5)
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  10(A1),-12(A5)
    CLR.W   LAB_22AB
    JSR     GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    JSR     GROUP_AW_JMPTBL_LAB_0A49(PC)

    MOVEQ   #0,D4

.copy_default_palette:
    MOVEQ   #24,D0
    CMP.L   D0,D4
    BGE.S   .palette_ready

    LEA     LAB_2295,A0
    ADDA.L  D4,A0
    LEA     LAB_1FB8,A1
    ADDA.L  D4,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D4
    BRA.S   .copy_default_palette

.palette_ready:
    MOVEA.L -8(A5),A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D5
    MOVEQ   #0,D0
    MOVEA.L -12(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0EE8

    ADDQ.W  #4,A7
    MOVEQ   #0,D4
    MOVE.B  D0,D4
    MOVE.L  D4,D0
    LSL.L   #2,D0
    SUB.L   D4,D0
    LEA     LAB_1FB8,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2295
    LEA     LAB_1FB9,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2296
    LEA     LAB_1FBA,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2297
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVE.L  D4,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,D4
    MOVE.L  D0,-32(A5)
    MOVE.L  D0,-36(A5)

.row_loop:
    CMP.L   LAB_21FB,D4
    BGE.W   .after_rows

.row_char_loop:
    MOVE.L  -32(A5),D0
    CMP.L   D5,D0
    BGE.W   .render_line

    MOVE.L  -36(A5),D1
    CMP.L   D6,D1
    BGE.W   .render_line

    MOVEA.L -8(A5),A0
    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #10,D3
    CMP.B   D3,D2
    BEQ.S   .skip_linebreak

    MOVEQ   #13,D3
    CMP.B   D3,D2
    BNE.S   .handle_line_start

.skip_linebreak:
    ADDQ.L  #1,-32(A5)
    BRA.S   .row_char_loop

.handle_line_start:
    TST.L   D1
    BNE.S   .handle_control

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .handle_control

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   .handle_control

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BEQ.S   .handle_control

    MOVEA.L -4(A5),A1
    MOVE.B  D3,0(A1,D1.L)
    ADDQ.L  #1,-36(A5)
    MOVEA.L -12(A5),A2
    MOVEA.L -16(A5),A3
    MOVE.B  0(A2,D0.L),0(A3,D1.L)
    BRA.S   .row_char_loop

.handle_control:
    TST.L   D1
    BLE.S   .copy_char

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .render_line

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   .render_line

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   .copy_char

    BRA.S   .render_line

.copy_char:
    MOVEA.L -12(A5),A1
    MOVEA.L -16(A5),A2
    MOVE.B  0(A1,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-36(A5)
    ADDQ.L  #1,-32(A5)
    MOVEA.L -4(A5),A1
    MOVE.B  0(A0,D0.L),0(A1,D1.L)
    BRA.W   .row_char_loop

.render_line:
    MOVEA.L -4(A5),A0
    MOVE.L  -36(A5),D0
    CLR.B   0(A0,D0.L)
    MOVEA.L LAB_2216,A1
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A1
    MOVE.L  -16(A5),-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  A1,-(A7)
    BSR.W   LADFUNC_DrawEntryLineWithAttrs

    LEA     16(A7),A7
    ADDQ.L  #1,D4
    CLR.L   -36(A5)
    BRA.W   .row_loop

.after_rows:
    JSR     GROUP_AW_JMPTBL_LAB_0A48(PC)

.cleanup:
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVEA.L A0,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    TST.L   -4(A5)
    BEQ.S   .free_attr_buf

    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     926.W
    PEA     GLOB_STR_LADFUNC_C_18
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_attr_buf:
    TST.L   -16(A5)
    BEQ.S   .return

    MOVE.L  D6,-(A7)
    MOVE.L  -16(A5),-(A7)
    PEA     928.W
    PEA     GLOB_STR_LADFUNC_C_19
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_ReflowEntryBuffers   (Reflow entry buffers??)
; ARGS:
;   stack +4: u8* outText ??
;   stack +8: u8* outAttr ??
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   NEWGRID_JMPTBL_AllocateMemory, NEWGRID_JMPTBL_DeallocateMemory,
;   JMPTBL_MATH_DivS32_3
; READS:
;   LAB_21FB
; WRITES:
;   outText/outAttr buffers
; DESC:
;   Copies and reflows entry text/attr buffers into fixed-width rows.
; NOTES:
;   Honors control bytes 24/25/26 and line breaks.
;------------------------------------------------------------------------------
LADFUNC_ReflowEntryBuffers:
LAB_0E92:
    LINK.W  A5,#-120
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,-116(A5)
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1025.W
    PEA     GLOB_STR_LADFUNC_C_20
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  -116(A5),-(A7)
    PEA     1026.W
    PEA     GLOB_STR_LADFUNC_C_21
    MOVE.L  D0,-6(A5)
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-10(A5)
    TST.L   -6(A5)
    BEQ.W   .cleanup

    TST.L   D0
    BEQ.W   .cleanup

    MOVEA.L A3,A0
    MOVEA.L -6(A5),A1

.copy_text_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_text_loop

    MOVE.L  -116(A5),D0
    MOVEA.L A2,A0
    MOVEA.L -10(A5),A1
    BRA.S   .copy_attr_next

.copy_attr_loop:
    MOVE.B  (A0)+,(A1)+

.copy_attr_next:
    SUBQ.L  #1,D0
    BCC.S   .copy_attr_loop

    MOVEQ   #0,D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    MOVE.L  D0,-100(A5)
    MOVE.L  D0,-104(A5)
    MOVE.L  D0,-112(A5)

.row_loop:
    CMP.L   LAB_21FB,D5
    BGE.W   .finish_all

.scan_row:
    MOVEA.L -6(A5),A0
    MOVE.L  -100(A5),D0
    TST.B   0(A0,D0.L)
    BEQ.W   .finalize_line

    MOVE.L  -104(A5),D1
    MOVEQ   #40,D2
    CMP.L   D2,D1
    BGE.W   .finalize_line

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #10,D3
    CMP.B   D3,D2
    BEQ.S   .skip_linebreak

    MOVEQ   #13,D3
    CMP.B   D3,D2
    BNE.S   .check_control_start

.skip_linebreak:
    ADDQ.L  #1,-100(A5)
    BRA.S   .scan_row

.check_control_start:
    TST.B   D7
    BNE.S   .check_control_mid

    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .set_control_mode

    MOVEQ   #25,D4
    CMP.B   D4,D2
    BEQ.S   .set_control_mode

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   .set_default_mode

.set_control_mode:
    MOVE.B  0(A0,D0.L),D7
    ADDQ.L  #1,-100(A5)
    MOVEA.L -10(A5),A1
    MOVE.B  0(A1,D0.L),D6
    BRA.S   .scan_row

.set_default_mode:
    MOVE.L  D4,D7
    MOVEA.L -10(A5),A1
    MOVE.B  0(A1,D0.L),D6
    BRA.S   .scan_row

.check_control_mid:
    MOVE.B  0(A0,D0.L),D2
    MOVEQ   #24,D3
    CMP.B   D3,D2
    BEQ.S   .finalize_line

    MOVEQ   #25,D3
    CMP.B   D3,D2
    BEQ.S   .finalize_line

    MOVEQ   #26,D2
    CMP.B   0(A0,D0.L),D2
    BNE.S   .emit_char_to_line

    BRA.S   .finalize_line

.emit_char_to_line:
    MOVE.B  0(A0,D0.L),-51(A5,D1.L)
    ADDQ.L  #1,-104(A5)
    ADDQ.L  #1,-100(A5)
    MOVEA.L -10(A5),A0
    MOVE.B  0(A0,D0.L),-91(A5,D1.L)
    BRA.W   .scan_row

.finalize_line:
    MOVE.L  -104(A5),D0
    CLR.B   -51(A5,D0.L)
    LEA     -51(A5),A0
    MOVEA.L A0,A1

.scan_line_len:
    TST.B   (A1)+
    BNE.S   .scan_line_len

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVEM.L D1,-120(A5)
    MOVEQ   #24,D0
    CMP.B   D0,D7
    BNE.S   .indent_for_26

    MOVEQ   #2,D0
    MOVE.L  D0,-104(A5)
    BRA.S   .indent_ready

.indent_for_26:
    MOVEQ   #26,D0
    CMP.B   D0,D7
    BNE.S   .indent_default

    MOVEQ   #1,D0
    MOVE.L  D0,-104(A5)
    BRA.S   .indent_ready

.indent_default:
    MOVEQ   #0,D0
    MOVE.L  D0,-104(A5)

.indent_ready:
    MOVE.L  -104(A5),D0
    TST.L   D0
    BLE.S   .copy_line_to_output

    TST.L   D1
    BLE.S   .copy_line_to_output

    CLR.L   -108(A5)

.indent_loop:
    MOVE.L  -120(A5),D0
    MOVE.L  -104(A5),D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    MOVE.L  -108(A5),D1
    CMP.L   D0,D1
    BGE.S   .after_indent

    MOVE.L  -112(A5),D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVE.B  D6,0(A2,D0.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   .indent_loop

.after_indent:
    MOVE.L  -120(A5),D0
    MOVE.L  -104(A5),D1
    JSR     JMPTBL_MATH_DivS32_3(PC)

    SUB.L   D0,-120(A5)

.copy_line_to_output:
    CLR.L   -108(A5)

.copy_line_loop:
    MOVE.L  -108(A5),D0
    TST.B   -51(A5,D0.L)
    BEQ.S   .tail_spaces

    MOVE.L  -112(A5),D1
    MOVE.B  -51(A5,D0.L),0(A3,D1.L)
    MOVE.B  -91(A5,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   .copy_line_loop

.tail_spaces:
    MOVE.L  -120(A5),D0
    TST.L   D0
    BLE.S   .next_row

    CLR.L   -108(A5)

.tail_space_loop:
    MOVE.L  -108(A5),D0
    CMP.L   -120(A5),D0
    BGE.S   .next_row

    MOVE.L  -112(A5),D0
    MOVE.B  #$20,0(A3,D0.L)
    MOVE.B  D6,0(A2,D0.L)
    ADDQ.L  #1,-108(A5)
    ADDQ.L  #1,-112(A5)
    BRA.S   .tail_space_loop

.next_row:
    ADDQ.L  #1,D5
    CLR.L   -104(A5)
    MOVEQ   #0,D7
    BRA.W   .row_loop

.finish_all:
    MOVE.L  -112(A5),D0
    CLR.B   0(A3,D0.L)

.cleanup:
    TST.L   -6(A5)
    BEQ.S   .free_attr

    MOVE.L  -116(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -6(A5),-(A7)
    PEA     1146.W
    PEA     GLOB_STR_LADFUNC_C_22
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.free_attr:
    TST.L   -10(A5)
    BEQ.S   .return

    MOVE.L  -116(A5),-(A7)
    MOVE.L  -10(A5),-(A7)
    PEA     1148.W
    PEA     GLOB_STR_LADFUNC_C_23
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC_BuildEntryBuffersOrDefault   (Build entry buffers or defaults??)
; ARGS:
;   stack +4: u16 entryIndex ?? (D7)
;   stack +8: u8* outText ??
;   stack +12: u8* outAttr ??
; RET:
;   (none)
; CLOBBERS:
;   D0-D7/A0-A6 ??
; CALLS:
;   NEWGRID_JMPTBL_MATH_Mulu32, LAB_0EE5, LADFUNC_ReflowEntryBuffers
; READS:
;   LAB_2251, LAB_21FB
; WRITES:
;   outText/outAttr buffers
; DESC:
;   Copies entry text/attrs if present; otherwise fills defaults and reflows.
; NOTES:
;   Uses packed nibble from LAB_0EE5 for default attribute fill.
;------------------------------------------------------------------------------
LADFUNC_BuildEntryBuffersOrDefault:
LAB_0EAF:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A2-A3/A6,-(A7)
    MOVE.L  32(A7),D7
    MOVEA.L 36(A7),A3
    MOVEA.L 40(A7),A2
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   6(A1)
    BNE.S   .copy_existing_buffers

    MOVE.L  LAB_21FB,D0
    MOVEQ   #40,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #32,D1
    MOVEA.L A3,A0
    BRA.S   .fill_text_next

.fill_text_loop:
    MOVE.B  D1,(A0)+

.fill_text_next:
    SUBQ.L  #1,D0
    BCC.S   .fill_text_loop

    MOVE.L  LAB_21FB,D0
    MOVEQ   #40,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    CLR.B   0(A3,D0.L)
    PEA     1.W
    PEA     2.W
    BSR.W   LAB_0EE5

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  LAB_21FB,D0
    MOVE.L  D1,20(A7)
    MOVEQ   #40,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  20(A7),D1
    MOVEA.L A2,A0
    BRA.S   .fill_attr_next

.fill_attr_loop:
    MOVE.B  D1,(A0)+

.fill_attr_next:
    SUBQ.L  #1,D0
    BCC.S   .fill_attr_loop

    BRA.S   .return

.copy_existing_buffers:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0
    MOVEA.L A3,A6

.copy_text_loop:
    MOVE.B  (A0)+,(A6)+
    BNE.S   .copy_text_loop

    MOVEA.L A3,A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    MOVEA.L 10(A1),A0
    MOVEA.L A2,A6
    BRA.S   .copy_attr_next2

.copy_attr_loop2:
    MOVE.B  (A0)+,(A6)+

.copy_attr_next2:
    SUBQ.L  #1,D0
    BCC.S   .copy_attr_loop2

    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LADFUNC_ReflowEntryBuffers

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0EBA:
    LINK.W  A5,#-108
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVEA.L A3,A0

LAB_0EBB:
    TST.B   (A0)+
    BNE.S   LAB_0EBB

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVE.L  D0,-108(A5)
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     1214.W
    PEA     GLOB_STR_LADFUNC_C_24
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),(A7)
    MOVE.L  -108(A5),-(A7)
    PEA     1215.W
    PEA     GLOB_STR_LADFUNC_C_25
    MOVE.L  D0,-6(A5)
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     28(A7),A7
    MOVE.L  D0,-10(A5)
    TST.L   -6(A5)
    BEQ.W   LAB_0ED8

    TST.L   D0
    BEQ.W   LAB_0ED8

    MOVEA.L A3,A0
    MOVEA.L -6(A5),A1

LAB_0EBC:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0EBC

    MOVE.L  -108(A5),D0
    MOVEA.L A2,A0
    MOVEA.L -10(A5),A1
    BRA.S   LAB_0EBE

LAB_0EBD:
    MOVE.B  (A0)+,(A1)+

LAB_0EBE:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EBD

    MOVEQ   #0,D0
    MOVE.L  D0,D5
    MOVE.L  D0,-104(A5)

LAB_0EBF:
    CMP.L   LAB_21FB,D5
    BGE.W   LAB_0ED7

    MOVE.L  D5,D0
    MOVEQ   #40,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -6(A5),A0
    ADDA.L  D0,A0
    PEA     40.W
    MOVE.L  A0,-(A7)
    PEA     -51(A5)
    JSR     LAB_0EF2(PC)

    LEA     12(A7),A7
    CLR.B   -11(A5)
    LEA     -51(A5),A0
    MOVEA.L A0,A1

LAB_0EC0:
    TST.B   (A1)+
    BNE.S   LAB_0EC0

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D5,D0
    MOVEQ   #40,D1
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVEA.L -10(A5),A0
    ADDA.L  D0,A0
    MOVE.L  A1,-100(A5)
    MOVE.L  A1,D0
    LEA     -91(A5),A1
    BRA.S   LAB_0EC2

LAB_0EC1:
    MOVE.B  (A0)+,(A1)+

LAB_0EC2:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EC1

    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   LAB_0EC7

    LEA     -51(A5),A0
    ADDA.L  D0,A0
    SUB.L   D0,D1
    MOVEQ   #32,D0
    BRA.S   LAB_0EC4

LAB_0EC3:
    MOVE.B  D0,(A0)+

LAB_0EC4:
    SUBQ.L  #1,D1
    BCC.S   LAB_0EC3

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #0,D1
    MOVE.B  -92(A5,D0.L),D1
    MOVEQ   #40,D2
    SUB.L   D0,D2
    BRA.S   LAB_0EC6

LAB_0EC5:
    MOVE.B  D1,(A0)+

LAB_0EC6:
    SUBQ.L  #1,D2
    BCC.S   LAB_0EC5

LAB_0EC7:
    MOVE.B  -51(A5),D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   LAB_0EC9

    MOVE.B  -12(A5),D0
    CMP.B   D1,D0
    BNE.S   LAB_0EC8

    MOVEQ   #24,D7
    BRA.S   LAB_0ECA

LAB_0EC8:
    MOVEQ   #26,D7
    BRA.S   LAB_0ECA

LAB_0EC9:
    MOVEQ   #25,D7

LAB_0ECA:
    MOVE.B  D7,D0
    EXT.W   D0
    SUBI.W  #$18,D0
    BEQ.S   LAB_0ECB

    SUBQ.W  #1,D0
    BEQ.W   LAB_0ECE

    SUBQ.W  #1,D0
    BEQ.W   LAB_0ED1

    BRA.W   LAB_0ED4

LAB_0ECB:
    MOVE.B  -91(A5),D6
    CLR.L   -100(A5)

LAB_0ECC:
    MOVE.L  -100(A5),D0
    MOVEQ   #20,D1
    CMP.L   D1,D0
    BGE.S   LAB_0ECD

    MOVEQ   #32,D1
    CMP.B   -51(A5,D0.L),D1
    BNE.S   LAB_0ECD

    MOVEQ   #39,D2
    MOVE.L  D2,D3
    SUB.L   D0,D3
    CMP.B   -51(A5,D3.L),D1
    BNE.S   LAB_0ECD

    MOVE.B  -91(A5,D0.L),D1
    CMP.B   D6,D1
    BNE.S   LAB_0ECD

    SUB.L   D0,D2
    MOVE.B  -91(A5,D2.L),D0
    CMP.B   D6,D0
    BNE.S   LAB_0ECD

    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ECC

LAB_0ECD:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.W   LAB_0ED4

    MOVEQ   #40,D1
    MOVE.L  D1,D2
    SUB.L   D0,D2
    CLR.B   -51(A5,D2.L)
    LEA     -51(A5),A0
    ADDA.L  D0,A0
    ADD.L   D0,D0
    SUB.L   D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    ADD.L   D0,D0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    PEA     -91(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7
    BRA.W   LAB_0ED4

LAB_0ECE:
    MOVE.B  -52(A5),D6
    CLR.L   -100(A5)

LAB_0ECF:
    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   LAB_0ED0

    MOVEQ   #39,D1
    SUB.L   D0,D1
    MOVEQ   #32,D0
    CMP.B   -51(A5,D1.L),D0
    BNE.S   LAB_0ED0

    MOVE.B  -91(A5,D1.L),D0
    CMP.B   D6,D0
    BNE.S   LAB_0ED0

    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ECF

LAB_0ED0:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.S   LAB_0ED4

    MOVEQ   #40,D1
    SUB.L   D0,D1
    CLR.B   -51(A5,D1.L)
    BRA.S   LAB_0ED4

LAB_0ED1:
    MOVE.B  -91(A5),D6
    CLR.L   -100(A5)

LAB_0ED2:
    MOVE.L  -100(A5),D0
    MOVEQ   #40,D1
    CMP.L   D1,D0
    BGE.S   LAB_0ED3

    MOVEQ   #32,D1
    CMP.B   -51(A5,D0.L),D1
    BNE.S   LAB_0ED3

    MOVE.B  -91(A5,D0.L),D0
    CMP.B   D6,D0
    BNE.S   LAB_0ED3

    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ED2

LAB_0ED3:
    MOVE.L  -100(A5),D0
    TST.L   D0
    BLE.S   LAB_0ED4

    LEA     -51(A5),A0
    ADDA.L  D0,A0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-(A7)
    PEA     -51(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     -91(A5),A0
    MOVE.L  -100(A5),D0
    ADDA.L  D0,A0
    MOVEQ   #40,D1
    SUB.L   D0,D1
    MOVE.L  D1,(A7)
    PEA     -91(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AW_JMPTBL_MEM_Move(PC)

    LEA     20(A7),A7

LAB_0ED4:
    MOVE.L  -104(A5),D0
    MOVE.B  D7,0(A3,D0.L)
    ADDQ.L  #1,-104(A5)
    MOVE.B  D6,0(A2,D0.L)
    CLR.L   -100(A5)

LAB_0ED5:
    MOVE.L  -100(A5),D0
    TST.B   -51(A5,D0.L)
    BEQ.S   LAB_0ED6

    MOVE.L  -104(A5),D1
    MOVE.B  -51(A5,D0.L),0(A3,D1.L)
    ADDQ.L  #1,-104(A5)
    MOVE.B  -91(A5,D0.L),0(A2,D1.L)
    ADDQ.L  #1,-100(A5)
    BRA.S   LAB_0ED5

LAB_0ED6:
    ADDQ.L  #1,D5
    BRA.W   LAB_0EBF

LAB_0ED7:
    MOVE.L  -104(A5),D0
    CLR.B   0(A3,D0.L)

LAB_0ED8:
    TST.L   -6(A5)
    BEQ.S   LAB_0ED9

    MOVE.L  -108(A5),D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -6(A5),-(A7)
    PEA     1322.W
    PEA     GLOB_STR_LADFUNC_C_26
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0ED9:
    TST.L   -10(A5)
    BEQ.S   LAB_0EDA

    MOVE.L  -108(A5),-(A7)
    MOVE.L  -10(A5),-(A7)
    PEA     1324.W
    PEA     GLOB_STR_LADFUNC_C_27
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0EDA:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

LAB_0EDB:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A2-A3/A6,-(A7)
    MOVE.L  36(A7),D7
    MOVEA.L 40(A7),A3
    MOVEA.L 44(A7),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0EBA

    ADDQ.W  #8,A7
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BNE.S   LAB_0EDC

    ADDA.L  D0,A0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     14.W
    PEA     1362.W
    PEA     GLOB_STR_LADFUNC_C_28
    MOVE.L  A0,36(A7)
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.S   LAB_0EDC

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    MOVEQ   #0,D1
    MOVE.W  D1,(A6)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    MOVE.W  D1,2(A6)

LAB_0EDC:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   (A1)
    BEQ.W   LAB_0EE4

    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   6(A6)
    BEQ.S   LAB_0EDE

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

LAB_0EDD:
    TST.B   (A0)+
    BNE.S   LAB_0EDD

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    BRA.S   LAB_0EDF

LAB_0EDE:
    MOVEQ   #0,D6

LAB_0EDF:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  6(A1),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A6,32(A7)
    JSR     LAB_0B44(PC)

    ADDQ.W  #8,A7
    MOVEA.L 24(A7),A0
    MOVE.L  D0,6(A0)
    TST.L   D6
    BEQ.S   LAB_0EE0

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   10(A6)
    BEQ.S   LAB_0EE0

    MOVE.L  D7,D0
    ASL.L   #2,D0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     1386.W
    PEA     GLOB_STR_LADFUNC_C_29
    JSR     NEWGRID_JMPTBL_DeallocateMemory(PC)

    LEA     16(A7),A7

LAB_0EE0:
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L 6(A1),A0

LAB_0EE1:
    TST.B   (A0)+
    BNE.S   LAB_0EE1

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D6,-(A7)
    PEA     1389.W
    PEA     GLOB_STR_LADFUNC_C_30
    MOVE.L  A1,36(A7)
    JSR     NEWGRID_JMPTBL_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L 20(A7),A0
    MOVE.L  D0,10(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A6
    TST.L   10(A6)
    BEQ.S   LAB_0EE4

    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    MOVEA.L A2,A0
    MOVEA.L 10(A1),A6
    BRA.S   LAB_0EE3

LAB_0EE2:
    MOVE.B  (A0)+,(A6)+

LAB_0EE3:
    SUBQ.L  #1,D0
    BCC.S   LAB_0EE2

LAB_0EE4:
    MOVEM.L (A7)+,D6-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

LAB_0EE5:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    ASL.L   #4,D0
    MOVEQ   #0,D2
    MOVE.B  D6,D2
    AND.L   D1,D2
    OR.L    D2,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

LAB_0EE6:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    ASL.L   #4,D0
    MOVEQ   #0,D2
    MOVE.B  D6,D2
    AND.L   D1,D2
    OR.L    D2,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

LAB_0EE7:
    MOVEM.L D2/D6-D7,-(A7)
    MOVE.B  19(A7),D7
    MOVE.B  23(A7),D6
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVEQ   #15,D2
    AND.L   D2,D1
    OR.L    D1,D0
    MOVEM.L (A7)+,D2/D6-D7
    RTS

;!======

LAB_0EE8:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    ASR.L   #4,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

LAB_0EE9:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVE.L  D7,D0
    ANDI.B  #$f,D0
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
