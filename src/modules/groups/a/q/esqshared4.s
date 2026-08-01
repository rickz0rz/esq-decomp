
    ; Dead code
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  _ESQSHARED_BannerColorModeWord,D0
    BSR.S   _ESQSHARED4_ResetBannerColorSweepState

    MOVE.W  #$62,_ESQPARS2_BannerColorStepCounter
    MOVE.W  #0,_ESQPARS2_BannerSweepEntryGuardCounter
    MOVE.W  #0,_ESQPARS2_BannerSweepDelayCounter
    LEA     _ESQ_CopperListBannerA,A4
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    BSR.W   ESQSHARED4_ApplyBannerColorStep

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======

    ; Dead code.
    MOVEM.L D0-D1/A0-A4,-(A7)
    MOVE.W  _ESQSHARED_BannerColorModeWord,D0
    BSR.S   _ESQSHARED4_ResetBannerColorSweepState

    MOVE.W  #$62,_ESQPARS2_BannerColorStepCounter
    MOVE.W  #1,_ESQPARS2_BannerSweepEntryGuardCounter
    BSR.W   _ESQSHARED4_ResetBannerColorToStart

    MOVEM.L (A7)+,D0-D1/A0-A4
    RTS

;!======