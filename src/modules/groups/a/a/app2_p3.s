    XDEF    ESQ_DecCopperListsPrimary
    XDEF    ESQ_NoOp_006A


;------------------------------------------------------------------------------
; FUNC: ESQ_DecCopperListsPrimary   (DecCopperListsPrimaryuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   _ESQ_DecColorStep
; READS:
;   _ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; WRITES:
;   _ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; DESC:
;   Decrements color components for entries in the primary copper lists.
; NOTES:
;   Updates the first 8 entries in both lists, then the next 24 entries only
;   in _ESQ_CopperStatusDigitsA.
;------------------------------------------------------------------------------
ESQ_DecCopperListsPrimary:
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     _ESQ_CopperStatusDigitsA,A2
    LEA     ESQ_CopperStatusDigitsB,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_DecColorStep

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp_006A   (NoOpStub_006A)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   (none)
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   No-op stub that returns immediately.
;------------------------------------------------------------------------------
ESQ_NoOp_006A:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_DecCopperListsAltSkipIndex4   (DecCopperListsAltSkipIndex4uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A2-A3
; CALLS:
;   _ESQ_DecColorStep
; READS:
;   ESQ_BannerPaletteWordsA, ESQ_BannerPaletteWordsB
; WRITES:
;   ESQ_BannerPaletteWordsA, ESQ_BannerPaletteWordsB
; DESC:
;   Decrements color components for entries in the alternate copper lists,
;   skipping the entry at byte offset 4.
; NOTES:
;   Skips when D5 == 4.
;------------------------------------------------------------------------------
    MOVEM.L D2-D5/A2-A3,-(A7)
    LEA     ESQ_BannerPaletteWordsA,A2
    LEA     ESQ_BannerPaletteWordsB,A3
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