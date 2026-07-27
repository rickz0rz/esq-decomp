    XDEF    _ED_NextAdNumber


;------------------------------------------------------------------------------
; FUNC: _ED_NextAdNumber   (Advance to next ad numberuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0
; CALLS:
;   _ED_CommitCurrentAdEdits, _ED_LoadCurrentAdIntoBuffers
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _ED_MaxAdNumber
; WRITES:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Commits current edits then advances to the next ad.
; NOTES:
;   No-op if already at _ED_MaxAdNumber.
;------------------------------------------------------------------------------
_ED_NextAdNumber:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   _ED_MaxAdNumber,D0
    BGE.S   .return

    BSR.S   _ED_CommitCurrentAdEdits

    ADDQ.L  #1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BSR.W   _ED_LoadCurrentAdIntoBuffers

.return:
    RTS

;!======