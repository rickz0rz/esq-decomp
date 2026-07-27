    XDEF    _ESQSHARED4_SetBannerColorBaseAndLimit


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED4_SetBannerColorBaseAndLimit   (Routine at _ESQSHARED4_SetBannerColorBaseAndLimit)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D1
; CALLS:
;   (none)
; READS:
;   d9
; WRITES:
;   _ESQ_BannerColorClampValueA, _ESQ_BannerColorClampWaitRowA, _ESQ_BannerColorClampValueB, _ESQ_BannerColorClampWaitRowB, _ESQPARS2_BannerColorBaseValue
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ESQSHARED4_SetBannerColorBaseAndLimit:
    MOVE.W  D0,_ESQPARS2_BannerColorBaseValue
    MOVE.W  #$d9,D1
    MOVE.B  D0,_ESQ_BannerColorClampValueA
    MOVE.B  D0,_ESQ_BannerColorClampValueB
    MOVE.B  D1,_ESQ_BannerColorClampWaitRowA
    MOVE.B  D1,_ESQ_BannerColorClampWaitRowB
    RTS

;!======