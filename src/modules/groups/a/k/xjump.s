LAB_07C4:
    JMP     LAB_14B1

LAB_07C5:
    JMP     LAB_184F

JMP_TBL_PARSE_INI:
    JMP     PARSE_INI

LAB_07C7:
    JMP     LAB_16F7

LAB_07C8:
    JMP     GCOMMAND_GetBannerChar

LAB_07C9:
    JMP     LAB_0B4E

LAB_07CA:
    JMP     LAB_1487

LAB_07CB:
    JMP     LAB_142E

LAB_07CC:
    JMP     SCRIPT_DeassertCtrlLineNow

LAB_07CD:
    JMP     ESQ_SetCopperEffect_Default

LAB_07CE:
    JMP     ESQ_SetCopperEffect_Custom

ED2_JMP_TBL_CLEANUP_RenderAlignedStatusScreen:
LAB_07CF:
    JMP     CLEANUP_RenderAlignedStatusScreen

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000

;!======

LAB_07D0:
    JMP     ESQ_SetCopperEffect_AllOn

LAB_07D1:
    JMP     SCRIPT_AssertCtrlLineNow

LAB_07D2:
    JMP     LAB_1837

LAB_07D3:
    JMP     GCOMMAND_CopyGfxToWorkIfAvailable

    MOVEQ   #97,D0
    RTS

;!======

    ; Alignment
    ALIGN_WORD
