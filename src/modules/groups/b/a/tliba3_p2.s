
    ; Dead code.
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    MOVE.L  D7,D0
    MOVEQ   #77,D1
    ADD.L   D1,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayRuntimeTable,A0
    ADDA.L  D0,A0
    MOVE.W  2(A0),D0
    MOVE.L  (A7)+,D7
    RTS

;!======