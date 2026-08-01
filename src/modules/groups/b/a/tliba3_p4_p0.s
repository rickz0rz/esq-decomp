
    LINK.W  A5,#-80

    MOVE.L  _TLIBA1_CurrentViewModeIndex,-(A7)
    PEA     _Global_STR_VM_ARRAY_1
    PEA     -80(A5)
    JSR     _WDISP_SPrintf(PC)

    MOVE.L  _TLIBA1_CurrentViewModeIndex,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -80(A5)
    BSR.W   _TLIBA3_FormatPatternRegisterDump

    UNLK    A5
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-84
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7

.lab_1851:              ; maybe this is the entry point and it's getting removed by a few bytes?
    MOVEQ   #9,D0       ; or is this just being calculated weirdly?
    CMP.L   D0,D7
    BGE.S   .return

    MOVE.L  D7,-(A7)
    PEA     _Global_STR_VM_ARRAY_2
    PEA     -84(A5)
    JSR     _WDISP_SPrintf(PC)

    MOVE.L  D7,D0
    MOVEQ   #76,D1
    JSR     _MATH_Mulu32(PC)

    LEA     _TLIBA3_VmArrayPatternTable,A0
    ADDA.L  D0,A0
    MOVE.L  A0,(A7)
    PEA     -84(A5)
    BSR.W   _TLIBA3_FormatPatternRegisterDump

    PEA     _TLIBA1_STR_PatternDumpLoopNewline
    JSR     _FORMAT_RawDoFmtWithScratchBuffer(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D7
    BRA.S   .lab_1851

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======