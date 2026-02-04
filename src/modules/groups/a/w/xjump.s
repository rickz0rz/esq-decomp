GROUP_AW_JMPTBL_LAB_183E:
    JMP     LAB_183E

GROUP_AW_JMPTBL_LAB_0552:
    JMP     LAB_0552

GROUP_AW_JMPTBL_LAB_0A48:
    JMP     LAB_0A48

GROUP_AW_JMPTBL_LAB_0A49:
    JMP     LAB_0A49

JMPTBL_DISPLIB_DisplayTextAtPosition_3:
    JMP     DISPLIB_DisplayTextAtPosition

GROUP_AW_JMPTBL_MEM_Move:
    JMP     MEM_Move

GROUP_AW_JMPTBL_WDISP_SPrintf:
    JMP     WDISP_SPrintf

GROUP_AW_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight:
    JMP     ESQ_SetCopperEffect_OffDisableHighlight

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

LAB_0EF2:
    JMP     STRING_CopyPadNul