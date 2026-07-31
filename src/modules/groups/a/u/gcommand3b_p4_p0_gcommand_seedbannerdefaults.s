    XDEF    _GCOMMAND_SeedBannerDefaults

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_SeedBannerDefaults   (Reset banner buffers to the default values embedded in the binary.)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3, A0
; CALLS:
;   _GCOMMAND_BuildBannerTables
; READS:
;   (none)
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Reset banner buffers to the default values embedded in the binary.
; NOTES:
;   Seeds both tables with fixed sentinel bytes and invokes _GCOMMAND_BuildBannerTables.
;------------------------------------------------------------------------------

; Reset banner buffers to the default values embedded in the binary.
_GCOMMAND_SeedBannerDefaults:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)
    PEA     1.W
    MOVE.L  #$fffe,-(A7)
    PEA     32.W
    BSR.W   _GCOMMAND_BuildBannerTables

    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVEQ   #31,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D1
    MOVE.B  D1,1(A0)
    MOVEQ   #-2,D2
    MOVE.W  D2,2(A0)
    MOVEQ   #-8,D3
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVE.L  #_ESQ_CopperListBannerB,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVE.B  D1,1(A0)
    MOVE.W  D2,2(A0)
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======