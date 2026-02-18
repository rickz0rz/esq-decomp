    XDEF    STRING_ToUpperChar

;------------------------------------------------------------------------------
; FUNC: STRING_ToUpperChar   (Convert lowercase ASCII to uppercase.)
; ARGS:
;   stack +4: char (ASCII)
; RET:
;   D0: uppercase char if 'a'..'z', else original
; CLOBBERS:
;   D0
; DESC:
;   Maps lowercase ASCII letters to uppercase by subtracting 0x20.
;------------------------------------------------------------------------------
STRING_ToUpperChar:
    MOVE.L  4(A7),D0

    CMPI.B  #'a',D0
    BLT.S   .done

    CMPI.B  #'z',D0
    BGT.S   .done

    SUBI.B  #$20,D0

.done:
    RTS

;!======

    ; Alignment
    ALIGN_WORD
