    XDEF    _GCOMMAND_ShiftBannerCopperRowsDead


; FUNC: _GCOMMAND_ShiftBannerCopperRowsDead   (Dead code: shift banner copper rows)
; DESC:
;   Nothing calls this block. The disassembly gave it no label, so
;   refbytes.py read it as the tail of _GCOMMAND_ClearBannerQueue and reported
;   that function as 390 bytes instead of 36. The label is byte-neutral and
;   needs no XDEF.
_GCOMMAND_ShiftBannerCopperRowsDead:
    ; Dead code.
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D6-D7,-(A7)
    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVE.L  #_ESQ_CopperListBannerB,-8(A5)
    MOVEQ   #0,D7

.lab_0DBF:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.W   .lab_0DC0

    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    ADDQ.L  #1,D7
    BRA.W   .lab_0DBF

.lab_0DC0:
    MOVE.L  _GCOMMAND_BannerPhaseIndexCurrent,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEM.L (A7)+,D2-D3/D6-D7
    UNLK    A5
    RTS

;!======