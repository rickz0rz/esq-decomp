    XDEF    _GCOMMAND_UpdateBannerRowPointers


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_UpdateBannerRowPointers   (Refresh per-row linked pointer words in banner copper table)
; ARGS:
;   stack +4: tablePtr (banner table base)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3, D6-D7, A0-A1, A3
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_BannerRowIndexPrevious, _GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   [tablePtr + index*32 + $2FA], [tablePtr + index*32 + $2FE]
; DESC:
;   Updates pointer words in the banner table based on current/previous indices.
; NOTES:
;   Special-cases _GCOMMAND_BannerRowIndexPrevious == 97 to use the tail entry at offset 3876.
;   Row stride is 32 bytes (`ASL.L #5`); writes pointer words at `+$2FA`/`+$2FE`.
;------------------------------------------------------------------------------
_GCOMMAND_UpdateBannerRowPointers:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  _GCOMMAND_BannerRowIndexPrevious,D0
    MOVE.L  _GCOMMAND_BannerRowIndexCurrent,D1
    CMP.L   D0,D1
    BEQ.W   .return

    ASL.L   #5,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D2
    CLR.W   D2
    SWAP    D2
    MOVE.L  D2,D7
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D0
    MOVE.L  #$ffff,D2
    AND.L   D2,D0
    MOVE.L  D0,D6
    ASL.L   #5,D1
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    CLR.W   D0
    SWAP    D0
    MOVE.L  D1,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D0,0(A3,D3.L)
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    AND.L   D2,D0
    MOVE.L  D1,D3
    ADDI.L  #$2fe,D3
    MOVE.W  D0,0(A3,D3.L)
    MOVE.L  _GCOMMAND_BannerRowIndexPrevious,D0
    MOVEQ   #97,D1
    CMP.L   D1,D0
    BNE.S   .store_prev_ptr

    ASL.L   #5,D0
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    CLR.W   D1
    SWAP    D1
    MOVE.L  D0,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D1,0(A3,D3.L)
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    ANDI.L  #$ffff,D1
    MOVE.L  D0,D2
    ADDI.L  #$2fe,D2
    MOVE.W  D1,0(A3,D2.L)
    BRA.S   .return

.store_prev_ptr:
    ASL.L   #5,D0
    MOVE.L  D0,D1
    ADDI.L  #$2fa,D1
    MOVE.W  D7,0(A3,D1.L)
    MOVE.L  D0,D1
    ADDI.L  #$2fe,D1
    MOVE.W  D6,0(A3,D1.L)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    RTS

;!======