    XDEF    _LOCAVAIL_MapFilterTokenCharToClass
    XDEF    LOCAVAIL_MapFilterTokenCharToClass_Return


;------------------------------------------------------------------------------
; FUNC: _LOCAVAIL_MapFilterTokenCharToClass   (Map token character to filter-class index)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1/D6/D7
; CALLS:
;   (none)
; READS:
;   _WDISP_CharClassTable
; WRITES:
;   (none observed)
; DESC:
;   Converts numeric/alphabetic token chars into compact class indices used by
;   filter parsing logic; returns 0 for unsupported characters.
; NOTES:
;   Digits map via `'0'` base; alphabetic classes map via `'7'`-relative base.
;------------------------------------------------------------------------------
_LOCAVAIL_MapFilterTokenCharToClass:
    MOVEM.L D6-D7,-(A7)
    MOVE.B  15(A7),D7
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #2,(A1)
    BEQ.S   .class_is_not_digit

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    MOVEQ   #48,D1
    SUB.L   D1,D6
    BRA.S   LOCAVAIL_MapFilterTokenCharToClass_Return

.class_is_not_digit:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #3,D0
    AND.B   (A1),D0
    TST.B   D0
    BEQ.S   .class_unknown

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .skip_uppercase_fold

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .class_alpha_ready

.skip_uppercase_fold:
    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0

.class_alpha_ready:
    MOVE.L  D0,D6
    MOVEQ   #55,D1
    SUB.L   D1,D6
    BRA.S   LOCAVAIL_MapFilterTokenCharToClass_Return

.class_unknown:
    MOVEQ   #0,D6

;------------------------------------------------------------------------------
; FUNC: LOCAVAIL_MapFilterTokenCharToClass_Return   (Return token character class index)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D6/D7
; CALLS:
;   _NEWGRID_JMPTBL_MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns computed class index from D6.
; NOTES:
;   Class 0 indicates unrecognized token character.
;------------------------------------------------------------------------------
LOCAVAIL_MapFilterTokenCharToClass_Return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======