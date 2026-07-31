    XDEF    _ESQSHARED4_ProgramDisplayWindowAndCopper



;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_ProgramDisplayWindowAndCopper   (Routine at _ESQSHARED4_ProgramDisplayWindowAndCopper)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/D0
; CALLS:
;   _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp
; READS:
;   BLTDDAT, COPJMP1, DDFSTOP_WIDE, DDFSTRT_WIDE, _ESQ_CopperEffectListA, _ESQ_CopperEffectSwitchWaitWordA, _ESQ_CopperEffectListB, _ESQ_CopperEffectSwitchWaitWordB, VPOSR, ffc5
; WRITES:
;   BLTDDAT, BPL1MOD, BPL2MOD, COP1LCH, DDFSTOP, DDFSTRT, DIWSTOP, DIWSTRT, DMACON, _ESQ_CopperEffectListB_PtrHiWord, _ESQ_CopperEffectListB_PtrLoWord, _ESQ_CopperEffectJumpTargetA_HiWord, _ESQ_CopperEffectJumpTargetA_LoWord, _ESQ_CopperEffectListA_PtrHiWord, _ESQ_CopperEffectListA_PtrLoWord, _ESQ_CopperEffectJumpTargetB_HiWord, _ESQ_CopperEffectJumpTargetB_LoWord
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_ProgramDisplayWindowAndCopper:
    LEA     BLTDDAT,A0
    MOVE.W  #$1761,(DIWSTRT-BLTDDAT)(A0)    ; $17, $61  -> 23, 97
    MOVE.W  #$ffc5,(DIWSTOP-BLTDDAT)(A0)    ; $ff, $c5  -> 255, 197
    MOVE.W  #DDFSTRT_WIDE,(DDFSTRT-BLTDDAT)(A0)
    MOVE.W  #DDFSTOP_WIDE,(DDFSTOP-BLTDDAT)(A0)
    ; $58 = 88
    ; 88 * 8 = 704
    ; SCREEN_WIDTH_BYTES	equ (320/8)
    ; SCREEN_BIT_DEPTH	equ 5
    ; BPL1MOD,SCREEN_WIDTH_BYTES*SCREEN_BIT_DEPTH-SCREEN_WIDTH_BYTES
    ; how is this calculated?
    MOVE.W  #$58,(BPL1MOD-BLTDDAT)(A0)
    MOVE.W  #$58,(BPL2MOD-BLTDDAT)(A0)
    BSR.W   _ESQSHARED4_LoadDefaultPaletteToCopper_NoOp

    LEA     _ESQ_CopperEffectListB,A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_CopperEffectListB_PtrLoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_CopperEffectListB_PtrHiWord
    LEA     _ESQ_CopperEffectListA,A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_CopperEffectListA_PtrLoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_CopperEffectListA_PtrHiWord
    LEA     _ESQ_CopperEffectSwitchWaitWordA,A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_CopperEffectJumpTargetA_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_CopperEffectJumpTargetA_HiWord
    LEA     _ESQ_CopperEffectSwitchWaitWordB,A2
    MOVE.L  A2,D0
    MOVE.W  D0,_ESQ_CopperEffectJumpTargetB_LoWord
    SWAP    D0
    MOVE.W  D0,_ESQ_CopperEffectJumpTargetB_HiWord
    LEA     _ESQ_CopperEffectListB,A2
    MOVE.W  (VPOSR-BLTDDAT)(A0),D0
    BPL.S   .lab_0C81

    LEA     _ESQ_CopperEffectListA,A2

.lab_0C81:
    MOVE.L  A2,(COP1LCH-BLTDDAT)(A0)
    MOVE.W  (COPJMP1-BLTDDAT)(A0),D0
    MOVE.W  #$20,(DMACON-BLTDDAT)(A0)
    MOVE.W  #$8180,(DMACON-BLTDDAT)(A0)
    RTS

;!======