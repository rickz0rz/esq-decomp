; Create a string, null padded to the next word.
Str macro
    DC.B	\1
    CNOP 0,2
endm

; Create a null-terminated string, null padded to the next word.
NStr macro
    DC.B	\1,0
    CNOP 0,2
endm

; Create a null-terminated 2-parametr string, null padded to the next word.
NStr2 macro
    DC.B	\1,\2,0
    CNOP 0,2
endm

