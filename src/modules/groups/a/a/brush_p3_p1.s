    XDEF    BRUSH_SelectBrushByLabel


; Select a brush by its string label, updating _BRUSH_SelectedNode.
;------------------------------------------------------------------------------
; FUNC: BRUSH_SelectBrushByLabel   (Routine at BRUSH_SelectBrushByLabel)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A3/A5/A7
; CALLS:
;   _BRUSH_FindBrushByPredicate, GROUP_AA_JMPTBL_STRING_CompareN, _GROUP_AG_JMPTBL_STRING_CopyPadNul
; READS:
;   BRUSH_LabelScratch, _BRUSH_SelectedNode, BRUSH_STR_ALIAS_CODE_00, BRUSH_STR_ALIAS_CODE_11, BRUSH_STR_ALIAS_CODE_DT, BRUSH_STR_FALLBACK_DITHER, _ESQIFF_BrushIniListHead
; WRITES:
;   BRUSH_ScriptPrimarySelection, BRUSH_ScriptSecondarySelection, _BRUSH_SelectedNode
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_SelectBrushByLabel:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L A3,A0
    LEA     BRUSH_LabelScratch,A1

.lab_0196:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .lab_0196

    MOVE.L  _ESQIFF_BrushIniListHead,-4(A5)
    CLR.L   _BRUSH_SelectedNode
    PEA     2.W
    PEA     BRUSH_STR_ALIAS_CODE_00
    MOVE.L  A3,-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_0197

    PEA     2.W
    PEA     BRUSH_STR_ALIAS_CODE_11
    MOVE.L  A3,-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_0197

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    BRA.S   .lab_0198

.lab_0197:
    PEA     2.W
    PEA     BRUSH_STR_ALIAS_CODE_DT
    PEA     -7(A5)
    JSR     _GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7

.lab_0198:
    CLR.B   -5(A5)

.lab_0199:
    TST.L   -4(A5)
    BEQ.S   .lab_019B

    MOVEA.L -4(A5),A0
    ADDA.W  #$21,A0
    PEA     2.W
    PEA     -7(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .lab_019A

    MOVE.L  -4(A5),_BRUSH_SelectedNode

.lab_019A:
    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .lab_0199

.lab_019B:
    TST.L   _BRUSH_SelectedNode
    BNE.S   .lab_019C

    PEA     _ESQIFF_BrushIniListHead
    PEA     BRUSH_STR_FALLBACK_DITHER
    BSR.W   _BRUSH_FindBrushByPredicate

    ADDQ.W  #8,A7
    MOVE.L  D0,_BRUSH_SelectedNode

.lab_019C:
    MOVEA.L _BRUSH_SelectedNode,A0
    MOVE.L  A0,BRUSH_ScriptPrimarySelection   ; expose latest selection to script subsystem
    MOVE.L  A0,BRUSH_ScriptSecondarySelection ; and remember it as the fallback option
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======