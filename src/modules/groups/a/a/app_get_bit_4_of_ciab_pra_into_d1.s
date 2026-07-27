    XDEF    _GET_BIT_4_OF_CIAB_PRA_INTO_D1


;------------------------------------------------------------------------------
; FUNC: _GET_BIT_4_OF_CIAB_PRA_INTO_D1   (GetCiabPraBit4)
; ARGS:
;   (none)
; RET:
;   D1: $FF if CIAB_PRA bit 4 is 0, else 0
; CLOBBERS:
;   D1, A5
; CALLS:
;   (none)
; READS:
;   CIAB_PRA
; WRITES:
;   (none)
; DESC:
;   Reads CIAB_PRA and returns an inverted boolean for bit 4 in D1.
;------------------------------------------------------------------------------
_GET_BIT_4_OF_CIAB_PRA_INTO_D1:
    MOVEQ   #0,D1           ; Copy 0 into D1 to clear all bytes
    MOVEA.L #CIAB_PRA,A5    ; Copy the address of CIAB_PRA into A5
    MOVE.B  (A5),D1         ; Get contents of the least significant byte at A5 and copy into D1
    BTST    #4,D1           ; Test bit 4, set Z to true if it's 0
    SEQ     D1              ; SEQ sets D1 to $FF when Z=1, otherwise 0
    RTS

;!======