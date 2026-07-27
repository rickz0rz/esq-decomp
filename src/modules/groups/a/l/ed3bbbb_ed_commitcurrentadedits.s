    XDEF    _ED_CommitCurrentAdEdits


;------------------------------------------------------------------------------
; FUNC: _ED_CommitCurrentAdEdits   (Commit current ad editsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A7/D0
; CALLS:
;   _GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; WRITES:
;   (none)
; DESC:
;   Commits the current ad buffers to storage.
; NOTES:
;   Calls _GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex with (adNumber-1).
;------------------------------------------------------------------------------
_ED_CommitCurrentAdEdits:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     _ED_EditBufferLive
    PEA     _ED_EditBufferScratch
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_UpdateEntryBuffersForAdIndex(PC)

    LEA     12(A7),A7
    RTS

;!======