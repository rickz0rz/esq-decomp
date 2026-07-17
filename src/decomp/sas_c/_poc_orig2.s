    SECTION text,CODE
    XDEF    _STRING_ToUpperChar     ; SAS/C C callers reference the _-prefixed name

_STRING_ToUpperChar:
    MOVE.L  4(A7),D0
    CMPI.B  #'a',D0
    BLT.S   L_done
    CMPI.B  #'z',D0
    BGT.S   L_done
    SUBI.B  #$20,D0
L_done:
    RTS

    END
