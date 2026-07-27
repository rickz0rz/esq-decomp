    XDEF    _ESQSHARED_ReplaceMovieRatingToken


; Possibly the code that replaces the strings of TV ratings like (TV-G) into
; a corresponding character in the font
;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_ReplaceMovieRatingToken   (Replace movie-rating token with glyph marker)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A5/A6/A7/D0/D5/D6/D7
; CALLS:
;   _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, _Global_TBL_MOVIE_RATINGS, _ESQPARS2_MovieRatingTokenGlyphMap
; WRITES:
;   (none observed)
; DESC:
;   Scans movie-rating token table, replaces first match with a one-byte glyph
;   code, and compacts the string tail over the consumed token text.
; NOTES:
;   Stops after first successful replacement.
;------------------------------------------------------------------------------
_ESQSHARED_ReplaceMovieRatingToken:
    LINK.W  A5,#-16
    MOVEM.L D5-D7/A2-A3,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3

    MOVEQ   #0,D5
    MOVEQ   #0,D7

.lab_0C3D:
    MOVEQ   #7,D0
    CMP.L   D0,D7
    BGE.S   .return

    TST.W   D5
    BNE.S   .return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _Global_TBL_MOVIE_RATINGS,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .lab_0C40

    LEA     _ESQPARS2_MovieRatingTokenGlyphMap,A0
    ADDA.L  D7,A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A1
    MOVE.B  D0,(A1)+
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _Global_TBL_MOVIE_RATINGS,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2

.lab_0C3E:
    TST.B   (A2)+
    BNE.S   .lab_0C3E

    SUBQ.L  #1,A2
    SUBA.L  (A0),A2
    MOVE.L  A2,D0
    MOVE.L  D0,D6
    SUBQ.L  #1,D6
    MOVE.L  A1,-4(A5)
    ADDA.L  D6,A1
    MOVEA.L A1,A0

.lab_0C3F:
    TST.B   (A0)+
    BNE.S   .lab_0C3F

    SUBQ.L  #1,A0
    SUBA.L  A1,A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #1,D5

.lab_0C40:
    ADDQ.L  #1,D7
    BRA.S   .lab_0C3D

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======