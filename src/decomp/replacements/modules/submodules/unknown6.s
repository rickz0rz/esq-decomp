;------------------------------------------------------------------------------
; DECOMP TARGETS unknown6 string append helper module boundary
; SOURCE: modules/submodules/unknown6.s
; PURPOSE:
;   Object-level hybrid replacement for UNKNOWN6 now that the restored SAS/C
;   lane covers STRING_AppendAtNull. This replacement now carries the module
;   body directly instead of delegating back to the canonical asm include.
;------------------------------------------------------------------------------

    XDEF    STRING_AppendAtNull

;------------------------------------------------------------------------------
; FUNC: STRING_AppendAtNull   (Append a NUL-terminated string to another.)
; ARGS:
;   stack +4: A0 = destination buffer (NUL-terminated)
;   stack +8: A1 = source buffer (NUL-terminated)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0-A1
; DESC:
;   Walks A0 to its terminating NUL, then copies bytes from A1 through NUL.
;------------------------------------------------------------------------------
STRING_AppendAtNull:
    MOVEA.L 8(A7),A1
    MOVEA.L 4(A7),A0
    MOVE.L  A0,D0

.find_null:
    TST.B   (A0)+
    BNE.S   .find_null

    SUBQ.L  #1,A0

.copy_until_null:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .copy_until_null

    RTS

;!======

    ; Alignment
    ALIGN_WORD
