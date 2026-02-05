;------------------------------------------------------------------------------
; FUNC: TEXTDISP_ResetSelectionAndRefresh   (Reset selection + refresh)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1
; CALLS:
;   LAB_14B1, JMPTBL_LAB_0A7C
; READS:
;   (none)
; WRITES:
;   LAB_2364
; DESC:
;   Resets selection state and triggers a refresh helper.
; NOTES:
;   Uses helper LAB_14B1 with constant 3 and clears LAB_2364.
;------------------------------------------------------------------------------
TEXTDISP_ResetSelectionAndRefresh:
LAB_167D:
    PEA     3.W
    JSR     LAB_14B1(PC)

    MOVE.W  #(-1),LAB_2364
    CLR.L   (A7)
    JSR     JMPTBL_LAB_0A7C(PC)

    ADDQ.W  #4,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_SetRastForMode   (Set rast + palette for mode)
; ARGS:
;   stack +8: modeIndex (word)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7/A0-A1/A6
; CALLS:
;   GROUPD_JMPTBL_LAB_0A49, LAB_183E, _LVOSetRast
; READS:
;   LAB_2295-2297, GLOB_REF_RASTPORT_2, GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   LAB_2216, LAB_2295-2297, LAB_22AB
; DESC:
;   Allocates/sets the working rastport and updates palette bytes based on mode.
; NOTES:
;   Mode 0 uses args (3,0,0); nonzero uses (4,0,7).
;------------------------------------------------------------------------------
TEXTDISP_SetRastForMode:
LAB_167E:
    MOVEM.L D2/D7,-(A7)
    MOVE.W  14(A7),D7
    CLR.W   LAB_22AB
    JSR     GROUPD_JMPTBL_LAB_0A49(PC)

    TST.W   D7
    BNE.S   .mode_nonzero

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     3.W
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    BRA.S   .return

.mode_nonzero:
    PEA     4.W
    CLR.L   -(A7)
    PEA     7.W
    JSR     LAB_183E(PC)

    LEA     12(A7),A7
    MOVE.L  D0,LAB_2216
    MOVE.L  D7,D1
    MOVEQ   #3,D2
    MULS    D2,D1
    LEA     LAB_2295,A0
    ADDA.L  D1,A0
    MOVE.B  (A0),LAB_2295
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     LAB_2296,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2296
    MOVE.L  D7,D0
    MULS    D2,D0
    LEA     LAB_2297,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),LAB_2297
    MOVEA.L LAB_2216,A0
    ADDA.W  #((GLOB_REF_RASTPORT_2-LAB_2216)+2),A0
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEA.L A0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_DrawNextEntryPreview   (Draw next preview entry)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0-A1
; CALLS:
;   MATH_DivS32, JMPTBL_LADFUNC_DrawEntryPreview
; READS:
;   LAB_2251, LAB_2265
; WRITES:
;   LAB_2265
; DESC:
;   Advances the entry index until a valid slot is found, then draws a preview.
; NOTES:
;   Wraps via division by 46.
;------------------------------------------------------------------------------
TEXTDISP_DrawNextEntryPreview:
LAB_1681:
.loop:
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     LAB_2251,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #1,D0
    CMP.W   4(A1),D0
    BEQ.S   .found_entry

    MOVE.W  LAB_2265,D0
    EXT.L   D0
    ADDQ.L  #1,D0
    MOVEQ   #46,D1
    JSR     MATH_DivS32(PC)

    MOVE.W  D1,LAB_2265
    BRA.S   .loop

.found_entry:
    MOVE.W  LAB_2265,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     JMPTBL_LADFUNC_DrawEntryPreview(PC)

    ADDQ.W  #4,A7
    MOVE.W  LAB_2265,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,LAB_2265
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_UpdateHighlightOrPreview   (Update highlight/preview)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2/D7
; CALLS:
;   JMPTBL_LAB_0A7C, TEXTDISP_DrawNextEntryPreview, TEXTDISP_ResetSelectionAndRefresh
; READS:
;   LAB_1FE6/1FE8/1FE9, LAB_1DD6, WDISP_HighlightActive
; WRITES:
;   (none)
; DESC:
;   Chooses between refresh/preview paths based on mode flags and highlight state.
; NOTES:
;   Uses LAB_1DD6 == 'N' (78) gate.
;------------------------------------------------------------------------------
TEXTDISP_UpdateHighlightOrPreview:
LAB_1683:
    MOVEM.L D2/D7,-(A7)
    MOVEQ   #1,D0
    CMP.L   LAB_1FE6,D0
    BNE.S   .mode_not_one

    MOVE.L  LAB_1FE8,D1
    MOVEQ   #-1,D2
    CMP.L   D2,D1
    BNE.S   .mode_index_selected

    MOVE.L  LAB_1FE9,D1

.mode_index_selected:
    MOVE.L  D1,D7
    MOVE.B  LAB_1DD6,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .check_highlight_for_mode3

    MOVEQ   #2,D1
    CMP.L   D1,D7
    BNE.S   .check_highlight_for_mode3

    MOVE.L  D0,-(A7)
    JSR     JMPTBL_LAB_0A7C(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.check_highlight_for_mode3:
    MOVE.W  WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   .do_reset_selection

    MOVEQ   #3,D1
    CMP.L   D1,D7
    BNE.S   .do_reset_selection

    BSR.W   TEXTDISP_DrawNextEntryPreview

    BRA.S   .return

.do_reset_selection:
    BSR.W   TEXTDISP_ResetSelectionAndRefresh

    BRA.S   .return

.mode_not_one:
    MOVE.B  LAB_1DD6,D1
    MOVEQ   #78,D2
    CMP.B   D2,D1
    BEQ.S   .mode_char_is_n

    MOVE.L  D0,-(A7)
    JSR     JMPTBL_LAB_0A7C(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.mode_char_is_n:
    MOVE.W  WDISP_HighlightActive,D1
    SUBQ.W  #1,D1
    BNE.S   .do_reset_selection_alt

    BSR.W   TEXTDISP_DrawNextEntryPreview

    BRA.S   .return

.do_reset_selection_alt:
    BSR.W   TEXTDISP_ResetSelectionAndRefresh

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_InitRastAndResetFlag   (Init rast + reset flag)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0
; CALLS:
;   LAB_183E, GROUPD_JMPTBL_LAB_0A45
; READS:
;   (none)
; WRITES:
;   LAB_2216, LAB_22AB
; DESC:
;   Allocates/sets the working rastport then resets LAB_22AB.
; NOTES:
;   Unlabeled entry in original binary; added for documentation.
;------------------------------------------------------------------------------
TEXTDISP_InitRastAndResetFlag:
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     LAB_183E(PC)

    MOVE.L  D0,LAB_2216
    JSR     GROUPD_JMPTBL_LAB_0A45(PC)

    LEA     12(A7),A7
    CLR.W   LAB_22AB
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: TEXTDISP_TickDisplayState   (Tick display/control state)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D2
; CALLS:
;   JMPTBL_LAB_0F78, SCRIPT_AssertCtrlLineIfEnabled, TEXTDISP_UpdateHighlightOrPreview,
;   TEXTDISP_ResetSelectionAndRefresh, JMPTBL_LAB_0A8E
; READS:
;   LAB_1DF4, LAB_2263, LAB_2346, LAB_1DDE, LAB_1DDF, LAB_1FE9, LAB_234A
; WRITES:
;   LAB_2363, LAB_22A5, LAB_1DDF, LAB_1DDE, LAB_234A
; DESC:
;   Updates internal display/control counters and triggers refresh/preview steps.
; NOTES:
;   Uses LAB_234A as a timer for periodic refresh.
;------------------------------------------------------------------------------
TEXTDISP_TickDisplayState:
LAB_168B:
    MOVE.L  D2,-(A7)
    MOVEQ   #0,D0
    MOVE.W  D0,LAB_2363
    TST.W   LAB_1DF4
    BNE.W   .return

    TST.W   LAB_2263
    BNE.W   .tick_refresh_timer

    MOVE.W  LAB_2346,D1
    SUBQ.W  #2,D1
    BEQ.S   .tick_refresh_timer

    MOVE.W  LAB_1DDE,D1
    BEQ.S   .handle_refresh_timer

    MOVE.W  LAB_1DDF,D2
    BEQ.S   .handle_refresh_timer

    MOVE.W  D0,LAB_1DDF
    MOVE.W  LAB_1DDE,D0
    SUBQ.W  #3,D0
    BEQ.S   .assert_ctrl_and_refresh

    MOVE.W  LAB_1DDE,D0
    SUBQ.W  #2,D0
    BNE.S   .clear_pending_mode

.assert_ctrl_and_refresh:
    JSR     JMPTBL_LAB_0F78(PC)

    MOVE.W  D0,LAB_22A5
    JSR     SCRIPT_AssertCtrlLineIfEnabled(PC)

    BSR.W   TEXTDISP_UpdateHighlightOrPreview

    BRA.S   .decrement_delay_counter

.clear_pending_mode:
    MOVEQ   #-1,D0
    CMP.L   LAB_1FE9,D0
    BEQ.S   .decrement_delay_counter

    MOVE.L  D0,LAB_1FE9

.decrement_delay_counter:
    MOVE.W  LAB_1DDE,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .handle_refresh_timer

    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_1DDE

.handle_refresh_timer:
    MOVE.W  LAB_234A,D0
    CMPI.W  #$b4,D0
    BLT.S   .dispatch_update

    CLR.W   LAB_234A
    BSR.W   TEXTDISP_ResetSelectionAndRefresh

    BRA.S   .dispatch_update

.tick_refresh_timer:
    MOVE.W  LAB_234A,D0
    ADDQ.W  #1,D0
    BEQ.S   .dispatch_update

    CLR.W   LAB_234A

.dispatch_update:
    JSR     JMPTBL_LAB_0A8E(PC)

.return:
    MOVE.L  (A7)+,D2
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_0F78   (JumpStub_LAB_0F78)
; ARGS:
;   see LAB_0F78)
; RET:
;   see LAB_0F78)
; CLOBBERS:
;   see LAB_0F78)
; CALLS:
;   LAB_0F78
; DESC:
;   Jump stub to LAB_0F78.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_0F78:
LAB_1693:
    JMP     LAB_0F78

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LADFUNC_DrawEntryPreview   (JumpStub_LADFUNC_DrawEntryPreview)
; ARGS:
;   see LADFUNC_DrawEntryPreview)
; RET:
;   see LADFUNC_DrawEntryPreview)
; CLOBBERS:
;   see LADFUNC_DrawEntryPreview)
; CALLS:
;   LADFUNC_DrawEntryPreview
; DESC:
;   Jump stub to LADFUNC_DrawEntryPreview.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LADFUNC_DrawEntryPreview:
LAB_1694:
    JMP     LADFUNC_DrawEntryPreview

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_0A8E   (JumpStub_LAB_0A8E)
; ARGS:
;   see LAB_0A8E)
; RET:
;   see LAB_0A8E)
; CLOBBERS:
;   see LAB_0A8E)
; CALLS:
;   LAB_0A8E
; DESC:
;   Jump stub to LAB_0A8E.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_0A8E:
LAB_1695:
    JMP     LAB_0A8E

;------------------------------------------------------------------------------
; FUNC: JMPTBL_LAB_0A7C   (JumpStub_LAB_0A7C)
; ARGS:
;   see LAB_0A7C)
; RET:
;   see LAB_0A7C)
; CLOBBERS:
;   see LAB_0A7C)
; CALLS:
;   LAB_0A7C
; DESC:
;   Jump stub to LAB_0A7C.
; NOTES:
;   Callable entry point.
;------------------------------------------------------------------------------
JMPTBL_LAB_0A7C:
LAB_1696:
    JMP     LAB_0A7C
