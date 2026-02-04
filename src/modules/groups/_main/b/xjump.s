JMPTBL_DOS_Delay:
    JMP     DOS_Delay

JMPTBL_STREAM_BufferedWriteString:
    JMP     STREAM_BufferedWriteString

PREVUE_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

JMPTBL_BUFFER_FlushAllAndCloseWithCode_1:
    JMP     BUFFER_FlushAllAndCloseWithCode

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000