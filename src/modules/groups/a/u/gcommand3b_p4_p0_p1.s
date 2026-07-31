    XDEF    _GCOMMAND_SeedBannerFromPrefs

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_SeedBannerFromPrefs   (Seed banner buffers using values read from preferences.)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   _GCOMMAND_BuildBannerTables
; READS:
;   _CONFIG_BannerCopperHeadByte
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Seed banner buffers using values read from preferences.
; NOTES:
;   Seeds the leading bytes from _CONFIG_BannerCopperHeadByte and applies defaults.
;------------------------------------------------------------------------------

; Seed banner buffers using values read from preferences.
_GCOMMAND_SeedBannerFromPrefs:
    LINK.W  A5,#-4
    MOVE.L  D2,-(A7)
    CLR.L   -(A7)
    MOVE.L  #$80fe,-(A7)
    PEA     128.W
    BSR.W   _GCOMMAND_BuildBannerTables

    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D0
    MOVE.B  D0,1(A0)
    MOVEQ   #-2,D1
    MOVE.W  D1,2(A0)
    MOVE.L  #_ESQ_CopperListBannerB,-4(A5)
    MOVE.W  _CONFIG_BannerCopperHeadByte,D2
    MOVEA.L -4(A5),A0
    MOVE.B  D2,(A0)
    MOVE.B  D0,1(A0)
    MOVE.W  D1,2(A0)
    MOVE.L  -8(A5),D2
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
