    XDEF    _ESQSHARED_ApplyProgramTitleTextFilters


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_ApplyProgramTitleTextFilters   (Apply chained program-title token filters)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A3/A7/D7
; CALLS:
;   _ESQSHARED_CompressClosedCaptionedTag, _ESQSHARED_NormalizeInStereoTag, _ESQSHARED_ReplaceMovieRatingToken, _ESQSHARED_ReplaceTvRatingToken
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Runs closed-caption, stereo-tag, movie-rating, and TV-rating normalization
;   passes over a program title buffer.
; NOTES:
;   Delegates to four focused helper transforms in fixed order.
;------------------------------------------------------------------------------
_ESQSHARED_ApplyProgramTitleTextFilters:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  16(A7),D7
    MOVE.L  A3,-(A7)
    BSR.W   _ESQSHARED_CompressClosedCaptionedTag

    MOVE.L  D7,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _ESQSHARED_NormalizeInStereoTag

    MOVE.L  A3,(A7)
    BSR.W   _ESQSHARED_ReplaceMovieRatingToken

    MOVE.L  A3,(A7)
    BSR.W   _ESQSHARED_ReplaceTvRatingToken

    ADDQ.W  #8,A7
    MOVEM.L (A7)+,D7/A3
    RTS

;!======