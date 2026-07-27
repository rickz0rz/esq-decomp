    XDEF    _ESQ_BumpColorTowardTargets


;------------------------------------------------------------------------------
; FUNC: _ESQ_BumpColorTowardTargets   (BumpColorTowardTargetsuncertain)
; ARGS:
;   D0.w: color value (packed nibbles, likely RGB)
;   A1: pointer to 3-byte target stream (advances by 3)
; RET:
;   D0.w: adjusted color value
; CLOBBERS:
;   D0-D3, A1
; CALLS:
;   (none)
; READS:
;   (A1)+
; WRITES:
;   (none)
; DESC:
;   Adjusts each color component based on a per-component target byte.
; NOTES:
;   Component layout and adjustment direction are inferred.
;------------------------------------------------------------------------------
_ESQ_BumpColorTowardTargets:
    MOVE.W  D0,D1
    MOVE.W  D0,D2
    ANDI.W  #$f00,D1
    ANDI.W  #$f0,D2
    ANDI.W  #15,D0
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    LSL.W   #8,D3
    CMP.W   D3,D1
    BEQ.S   .after_red

    ADDI.W  #$100,D1

.after_red:
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    LSL.W   #4,D3
    CMP.W   D3,D2
    BEQ.S   .after_green

    ADDI.W  #16,D2

.after_green:
    MOVEQ   #0,D3
    MOVE.B  (A1)+,D3
    CMP.W   D3,D0
    BEQ.S   .return

    ADDI.W  #1,D0

.return:
    ADD.W   D1,D0
    ADD.W   D2,D0
    RTS

;!======