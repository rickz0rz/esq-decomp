    XDEF    _TEXTDISP_ShouldOpenEditorForEntry


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_ShouldOpenEditorForEntry   (Entry eligible for editor)
; ARGS:
;   stack +12: entryPtr (A3)
; RET:
;   D0: 1 if eligible, 0 otherwise
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   _TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor (_NEWGRID_ShouldOpenEditor)
; READS:
;   entry+27, entry+40
; DESC:
;   Returns true when entry flags and editor policy allow opening the editor.
; NOTES:
;   Uses entry flag bits (40/27 offsets).
;------------------------------------------------------------------------------
_TEXTDISP_ShouldOpenEditorForEntry:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return

    BTST    #0,40(A3)
    BEQ.S   .not_selectable

    BTST    #3,40(A3)
    BEQ.S   .not_selectable

    MOVE.L  A3,-(A7)
    JSR     _TEXTDISP_JMPTBL_NEWGRID_ShouldOpenEditor(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .not_selectable

    BTST    #3,27(A3)
    BNE.S   .not_selectable

    MOVEQ   #1,D0
    BRA.S   .set_result

.not_selectable:
    MOVEQ   #0,D0

.set_result:
    MOVE.L  D0,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    RTS

;!======