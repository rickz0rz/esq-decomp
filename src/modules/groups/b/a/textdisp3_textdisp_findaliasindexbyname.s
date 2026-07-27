    XDEF    _TEXTDISP_FindAliasIndexByName


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_FindAliasIndexByName   (Find alias index for entry name)
; ARGS:
;   stack +8: entryPtr (A3)
; RET:
;   D0: alias index (0.._TEXTDISP_AliasCount-1) or -1 if not found
; CLOBBERS:
;   D0/D7/A0-A3
; CALLS:
;   _STRING_CompareNoCaseN
; READS:
;   _TEXTDISP_AliasCount, _TEXTDISP_AliasPtrTable
; DESC:
;   Compares entry name (offset +12) against alias table entries.
; NOTES:
;   Copies the entry name to a stack buffer before comparison.
;------------------------------------------------------------------------------
_TEXTDISP_FindAliasIndexByName:
    LINK.W  A5,#-24
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    LEA     12(A3),A0
    LEA     -21(A5),A1

.copy_name:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_name

    MOVEQ   #0,D7

.loop_aliases:
    MOVE.W  _TEXTDISP_AliasCount,D0
    CMP.W   D0,D7
    BGE.S   .not_found

    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_AliasPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVEA.L (A2),A0

.measure_alias:
    TST.B   (A0)+
    BNE.S   .measure_alias

    SUBQ.L  #1,A0
    SUBA.L  (A2),A0
    MOVE.L  A0,-(A7)
    MOVE.L  (A2),-(A7)
    PEA     -21(A5)
    JSR     _STRING_CompareNoCaseN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .next_alias

    MOVE.L  D7,D0
    BRA.S   .return

.next_alias:
    ADDQ.W  #1,D7
    BRA.S   .loop_aliases

.not_found:
    MOVEQ   #-1,D0

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======