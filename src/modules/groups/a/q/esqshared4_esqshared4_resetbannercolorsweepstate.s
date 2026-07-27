    XDEF    _ESQSHARED4_ResetBannerColorSweepState


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_ResetBannerColorSweepState   (Routine at _ESQSHARED4_ResetBannerColorSweepState)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _ESQSHARED4_ResetBannerColorToStart
; READS:
;   _CONFIG_BannerCopperHeadByte, f5, f6
; WRITES:
;   _ESQ_CopperBannerTailListA, _ESQ_CopperBannerTailListB, _ESQPARS2_BannerSweepEntryGuardCounter, _ESQPARS2_BannerTailBiasValue, _ESQPARS2_BannerColorStepCounter
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_ResetBannerColorSweepState:
    MOVEQ   #0,D0
    MOVE.B  #$f6,_ESQ_CopperBannerTailListA
    MOVE.B  #$f6,_ESQ_CopperBannerTailListB
    MOVE.W  #$f5,D0
    ADD.W   _CONFIG_BannerCopperHeadByte,D0
    SUBI.W  #$80,D0
    MOVE.W  D0,_ESQPARS2_BannerTailBiasValue
    MOVE.W  #$62,_ESQPARS2_BannerColorStepCounter
    MOVE.W  #1,_ESQPARS2_BannerSweepEntryGuardCounter
    BSR.W   _ESQSHARED4_ResetBannerColorToStart

    RTS

;!======