    XDEF    TLIBA_FindFirstWildcardMatchIndex


;------------------------------------------------------------------------------
; FUNC: TLIBA_FindFirstWildcardMatchIndex   (Find first wildcard match index)
; ARGS:
;   stack +8: wildcardPattern (char *)
; RET:
;   D0: matched index, or -1 if no title matches
; CLOBBERS:
;   D0/D6/D7/A0-A1/A3
; CALLS:
;   _UNKNOWN_JMPTBL_ESQ_WildcardMatch
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   Scans secondary titles and returns the first index whose title wildcard-
;   matches the supplied pattern.
; NOTES:
;   Match is accepted when _ESQ_WildcardMatch returns zero.
;------------------------------------------------------------------------------
TLIBA_FindFirstWildcardMatchIndex:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #-1,D6
    MOVEQ   #0,D7

.loop_17E7:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.S   .return_17E9

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _UNKNOWN_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .if_ne_17E8

    MOVE.L  D7,D6
    BRA.S   .return_17E9

.if_ne_17E8:
    ADDQ.L  #1,D7
    BRA.S   .loop_17E7

.return_17E9:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======