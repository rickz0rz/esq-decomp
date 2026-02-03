LAB_07C4:
    JMP     LAB_14B1

LAB_07C5:
    JMP     LAB_184F

GROUP_AK_JMPTBL_PARSEINI_ParseConfigBuffer:
    JMP     PARSEINI_ParseConfigBuffer

LAB_07C7:
    JMP     LAB_16F7

GROUP_AK_JMPTBL_GCOMMAND_GetBannerChar:
    JMP     GCOMMAND_GetBannerChar

LAB_07C9:
    JMP     LAB_0B4E

LAB_07CA:
    JMP     LAB_1487

LAB_07CB:
    JMP     LAB_142E

GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow:
    JMP     SCRIPT_DeassertCtrlLineNow

GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default:
    JMP     ESQ_SetCopperEffect_Default

GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Custom:
    JMP     ESQ_SetCopperEffect_Custom

GROUP_AK_JMPTBL_CLEANUP_RenderAlignedStatusScreen:
    JMP     CLEANUP_RenderAlignedStatusScreen

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000