OVERRIDE_INTUITION_FUNCS:
    MOVE.L  A2,-(A7)

    ; overriding the AutoRequest function in intuition.library
    ; to point to LAB_0F9F(PC) storing the old version in GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVOAutoRequest,A0
    LEA     LAB_0F9F(PC),A2
    MOVE.L  A2,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOSetFunction(A6)

    MOVE.L  D0,GLOB_REF_BACKED_UP_INTUITION_AUTOREQUEST

    ; overriding the ItemAddress function in intuition.library
    ; to point to LAB_0FA0(PC) storing the old version in GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT
    MOVEA.L GLOB_REF_INTUITION_LIBRARY,A1
    MOVEA.W #_LVODisplayAlert,A0
    LEA     LAB_0FA0(PC),A2
    MOVE.L  A2,D0
    JSR     _LVOSetFunction(A6)

    MOVE.L  D0,GLOB_REF_BACKED_UP_INTUITION_DISPLAYALERT

    MOVEA.L (A7)+,A2
    RTS

;!======

LAB_0F9F:
    MOVE.L  A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVEQ   #0,D0
    MOVEA.L (A7)+,A4
    RTS

;!======

LAB_0FA0:
    LINK.W  A5,#-4
    MOVEM.L D7/A4,-(A7)
    LEA     GLOB_REF_LONG_FILE_SCRATCH,A4
    MOVEQ   #0,D7

LAB_0FA1:
    CMPI.L  #$f4240,D7
    BGE.S   LAB_0FA2

    ADDQ.L  #1,D7
    BRA.S   LAB_0FA1

LAB_0FA2:
    JSR     LAB_0FA3(PC)

    MOVEQ   #0,D0
    MOVEM.L (A7)+,D7/A4
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

LAB_0FA3:
    JMP     ESQ_ColdReboot

;!======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    DC.W    $0000
