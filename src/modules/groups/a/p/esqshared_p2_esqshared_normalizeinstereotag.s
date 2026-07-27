    XDEF    _ESQSHARED_NormalizeInStereoTag
    XDEF    ESQSHARED_NormalizeInStereoTag_Return


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_NormalizeInStereoTag   (Normalize "In Stereo" token placement)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D7
; CALLS:
;   _ESQSHARED_JMPTBL_STR_SkipClass3Chars, _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, _Global_STR_IN_STEREO, ESQSHARED_NormalizeInStereoTag_Return, _WDISP_CharClassTable
; WRITES:
;   (none observed)
; DESC:
;   Replaces "In Stereo" with marker byte 0x91 and either trims trailing spacing
;   or compacts neighboring class-3 separators depending on mode flags.
; NOTES:
;   Behavior branches on bit7 of arg_2.
;------------------------------------------------------------------------------
_ESQSHARED_NormalizeInStereoTag:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    PEA     _Global_STR_IN_STEREO
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   ESQSHARED_NormalizeInStereoTag_Return

    MOVEA.L D0,A0
    MOVE.B  #$91,(A0)
    LEA     9(A0),A1
    MOVE.L  A1,-8(A5)
    BTST    #7,D7
    BNE.S   .lab_0C39

    TST.B   (A1)
    BNE.S   .lab_0C37

.lab_0C36:
    MOVEA.L -4(A5),A0
    CLR.B   (A0)
    SUBQ.L  #1,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BNE.S   .lab_0C36

    BRA.S   ESQSHARED_NormalizeInStereoTag_Return

.lab_0C37:
    MOVE.L  -8(A5),-(A7)
    JSR     _ESQSHARED_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A0

.lab_0C38:
    TST.B   (A0)+
    BNE.S   .lab_0C38

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D1
    ADDQ.L  #1,D1
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    MOVE.L  D1,D0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    BRA.S   ESQSHARED_NormalizeInStereoTag_Return

.lab_0C39:
    ADDQ.L  #1,-4(A5)
    MOVEA.L -8(A5),A0

.lab_0C3A:
    TST.B   (A0)+
    BNE.S   .lab_0C3A

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D0
    ADDQ.L  #1,D0
    MOVEA.L -8(A5),A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_NormalizeInStereoTag_Return   (Return tail for stereo-tag normalizer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for _ESQSHARED_NormalizeInStereoTag.
; NOTES:
;   Restores D7/A3 and frame state.
;------------------------------------------------------------------------------
ESQSHARED_NormalizeInStereoTag_Return:
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======