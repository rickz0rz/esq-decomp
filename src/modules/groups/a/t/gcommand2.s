    XDEF    GCOMMAND_FindPathSeparator


;------------------------------------------------------------------------------
; FUNC: GCOMMAND_FindPathSeparator   (Return a pointer to the final path separator (':' or '/') in the buffer.)
; ARGS:
;   stack +4: pathPtr (via 8(A5))
; RET:
;   D0: pointer to char after final ':' or '/', else start of string
; CLOBBERS:
;   D0/D1/D7/A0/A3/A5
; CALLS:
;   (none)
; READS:
;   bytes from pathPtr
; WRITES:
;   -4(A5) temporary cursor
; DESC:
;   Return a pointer to the final path separator (':' or '/') in the buffer.
; NOTES:
;   Scans to NUL, then walks backward until a separator is found.
;------------------------------------------------------------------------------
GCOMMAND_FindPathSeparator:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L A3,A0

.lab_0D5A:
    TST.B   (A0)+
    BNE.S   .lab_0D5A

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D7
    TST.L   D7
    BEQ.S   .lab_0D5F

    MOVEA.L A3,A0
    ADDA.L  D7,A0
    SUBQ.L  #1,A0
    MOVE.L  A0,-4(A5)

.lab_0D5B:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    MOVEQ   #':',D1
    CMP.B   D1,D0
    BEQ.S   .lab_0D5C

    MOVEQ   #'/',D1
    CMP.B   D1,D0
    BNE.S   .lab_0D5D

.lab_0D5C:
    ADDQ.L  #1,-4(A5)
    BRA.S   .return

.lab_0D5D:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BEQ.S   .lab_0D5E

    SUBQ.L  #1,-4(A5)

.lab_0D5E:
    SUBQ.L  #1,D7
    BNE.S   .lab_0D5B

    BRA.S   .return

.lab_0D5F:
    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)

.return:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======