    XDEF    _NEWGRID_FindNextEntryWithFlags
    XDEF    _NEWGRID_HandleGridEditorState


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_HandleGridEditorState   (Handle editor state transitions)
; ARGS:
;   stack +4: A3 = target view/rastport context
;   stack +8: D7 = layout pen/config value
;   stack +12: D6 = row pen/config value
;   stack +16: A2 = source text/template pointer
; RET:
;   D0: state (_NEWGRID_GridEditorWorkflowState)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_DrawGridFrameAndRows, _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer, _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount, _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams
; READS:
;   _NEWGRID_GridEditorWorkflowState
; WRITES:
;   _NEWGRID_GridEditorWorkflowState, 32(A3)
; DESC:
;   Drives a small state machine for editor-related redraw paths.
; NOTES:
;   For state 4, source text (A2) is forwarded to
;   _DISPTEXT_LayoutAndAppendToBuffer, which tolerates NULL/empty strings.
;------------------------------------------------------------------------------
_NEWGRID_HandleGridEditorState:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.L  24(A7),D7
    MOVE.L  28(A7),D6
    MOVEA.L 32(A7),A2
    MOVE.L  A3,D0
    BNE.S   .state_dispatch_check

    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.state_dispatch_check:
    MOVE.L  _NEWGRID_GridEditorWorkflowState,D0
    SUBQ.L  #4,D0
    BEQ.S   .state4_draw

    SUBQ.L  #1,D0
    BEQ.S   .state5_frame_only

    BRA.S   .force_state4

.state4_draw:
    MOVE.L  D7,-(A7)
    PEA     20.W
    PEA     612.W
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_SetLayoutParams(PC)

    LEA     60(A3),A0
    ; A2 may be NULL; downstream layout helper performs NULL/empty checks.
    MOVE.L  A2,(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_LayoutAndAppendToBuffer(PC)

    CLR.L   (A7)
    JSR     _NEWGRID2_JMPTBL_DISPTEXT_ComputeVisibleLineCount(PC)

    MOVE.L  D0,32(A3)
    MOVE.L  D6,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameAndRows

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .state4_set_state5

    MOVEQ   #4,D0
    BRA.S   .state4_store_state

.state4_set_state5:
    MOVEQ   #5,D0

.state4_store_state:
    MOVE.L  D0,_NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.state5_frame_only:
    MOVEQ   #-1,D0
    MOVE.L  D0,32(A3)
    MOVE.L  D6,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrameAndRows

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .state5_keep_state5

    MOVEQ   #4,D0
    BRA.S   .state5_store_state

.state5_keep_state5:
    MOVEQ   #5,D0

.state5_store_state:
    MOVE.L  D0,_NEWGRID_GridEditorWorkflowState
    BRA.S   .return_state

.force_state4:
    MOVEQ   #4,D0
    MOVE.L  D0,_NEWGRID_GridEditorWorkflowState

.return_state:
    MOVE.L  _NEWGRID_GridEditorWorkflowState,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_FindNextEntryWithFlags   (Find entry with bit2/bit7 set)
; ARGS:
;   stack +8: D7 = scan mode selector (`0=reset`, `4=start+1`; others invalid)
;   stack +12: D6 = start index (entry scan cursor)
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag
; DESC:
;   Scans primary entries and returns the first entry index whose direct entry
;   flags satisfy both bit tests used by the secondary workflow prefilter.
;   Returns `-1` when no eligible entry exists.
; NOTES:
;   This helper does not inspect selector metadata tables; it only evaluates
;   the fetched entry record itself.
;------------------------------------------------------------------------------
_NEWGRID_FindNextEntryWithFlags:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    TST.L   D0
    BEQ.S   .case_reset

    SUBQ.L  #4,D0
    BEQ.S   .case_increment

    BRA.S   .set_invalid

.case_reset:
    MOVEQ   #0,D6
    BRA.S   .check_loop

.case_increment:
    ADDQ.L  #1,D6
    BRA.S   .check_loop

.set_invalid:
    MOVEQ   #1,D5

.check_loop:
    TST.L   D5
    BNE.S   .return

.scan_loop:
    TST.L   D5
    BNE.S   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .scan_done

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .scan_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .advance_index

    MOVEA.L D0,A0
    BTST    #2,47(A0)                     ; A0+47 = entry flags byte (bit2 required)
    BEQ.S   .advance_index

    BTST    #7,40(A0)                     ; A0+40 = entry marker/status byte (bit7 required)
    BEQ.S   .advance_index

    MOVEQ   #1,D5
    BRA.S   .scan_loop

.advance_index:
    ADDQ.L  #1,D6
    BRA.S   .scan_loop

.scan_done:
    TST.L   D5
    BNE.S   .return

    MOVEQ   #-1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======