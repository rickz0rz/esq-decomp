    XDEF    _NEWGRID_FindNextFlaggedEntry


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_FindNextFlaggedEntry   (Find next entry with flags)
; ARGS:
;   stack +8: D7 = mode selector
;   stack +12: D6 = start index
; RET:
;   D0: entry index or -1
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode
; READS:
;   _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_PrimaryGroupEntryCount
; DESC:
;   Scans forward for an entry with matching flag bits when enabled.
; NOTES:
;   Returns -1 if no matching entry is found.
;------------------------------------------------------------------------------
_NEWGRID_FindNextFlaggedEntry:
    LINK.W  A5,#-8
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEQ   #0,D5
    MOVE.L  D7,D0
    SUBQ.L  #3,D0
    BEQ.S   .case_reset

    SUBQ.L  #1,D0
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

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .return

.scan_loop:
    TST.L   D5
    BNE.S   .scan_done

    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .scan_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .advance_index

    MOVEA.L D0,A0
    BTST    #0,47(A0)
    BEQ.S   .advance_index

    BTST    #7,40(A0)
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