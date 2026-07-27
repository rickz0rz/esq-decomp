    XDEF    _GCOMMAND_ResetBannerFadeState

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ResetBannerFadeState   (One-shot banner fade-state reset and rebuild gate)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, A7
; CALLS:
;   _GCOMMAND_BuildBannerTables
; READS:
;   _GCOMMAND_BannerFadeResetPendingFlag
; WRITES:
;   _GCOMMAND_BannerFadeResetPendingFlag, _ESQSHARED4_InterleaveCopyBaseOffset, _ESQSHARED4_InterleaveCopyTailOffsetReset
; DESC:
;   Resets banner fade parameters when the pending flag is set.
; NOTES:
;   Initializes _ESQSHARED4_InterleaveCopyBaseOffset/_ESQSHARED4_InterleaveCopyTailOffsetReset with fixed offsets after calling
;   _GCOMMAND_BuildBannerTables.
;------------------------------------------------------------------------------
_GCOMMAND_ResetBannerFadeState:
    TST.W   _GCOMMAND_BannerFadeResetPendingFlag
    BEQ.S   .lab_0DEA

    CLR.W   _GCOMMAND_BannerFadeResetPendingFlag
    CLR.L   -(A7)
    MOVE.L  #$80fe,-(A7)
    PEA     128.W
    BSR.W   _GCOMMAND_BuildBannerTables

    LEA     12(A7),A7
    MOVEQ   #64,D0
    ADD.L   D0,D0
    MOVE.L  D0,_ESQSHARED4_InterleaveCopyBaseOffset
    ADDI.L  #$264,D0
    MOVE.L  D0,_ESQSHARED4_InterleaveCopyTailOffsetReset

.lab_0DEA:
    RTS

;!======