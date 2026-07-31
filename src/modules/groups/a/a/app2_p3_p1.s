
;------------------------------------------------------------------------------
; FUNC: _ESQ_DecCopperListsAltSkipIndex4   (DecCopperListsAltSkipIndex4uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   _ESQ_DecColorStep
; READS:
;   _ESQ_BannerPaletteWordsA, _ESQ_BannerPaletteWordsB
; WRITES:
;   _ESQ_BannerPaletteWordsA, _ESQ_BannerPaletteWordsB
; DESC:
;   Decrements color components for entries in the alternate copper lists,
;   skipping the entry at byte offset 4.
; NOTES:
;   Skips when D5 == 4.
;   Nothing calls this block. It carried no label, so the extract for the
;   preceding _ESQ_NoOp_006A ran on into it and reported that 2-byte stub as
;   58 bytes. The label below is byte-neutral and makes the two separate
;   again. It is deliberately not XDEF'd: no other module refers to it.
;------------------------------------------------------------------------------
_ESQ_DecCopperListsAltSkipIndex4:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     _ESQ_BannerPaletteWordsA,A2
    LEA     _ESQ_BannerPaletteWordsB,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_loop:
    CMPI.W  #4,D5
    BEQ.W   .skip_index4

    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.skip_index4:
    ADDQ.W  #4,D5
    DBF     D4,.update_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======