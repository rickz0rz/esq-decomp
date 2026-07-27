    XDEF    ESQ_IncCopperListsTowardsTargets
    XDEF    ESQ_NoOp_0074


;------------------------------------------------------------------------------
; FUNC: ESQ_IncCopperListsTowardsTargets   (IncCopperListsTowardsTargetsuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D6, A1-A3
; CALLS:
;   _ESQ_BumpColorTowardTargets
; READS:
;   _WDISP_PaletteTriplesRBase, _ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; WRITES:
;   _ESQ_CopperStatusDigitsA, ESQ_CopperStatusDigitsB
; DESC:
;   Adjusts copper list colors based on a per-entry target table.
; NOTES:
;   Uses _WDISP_PaletteTriplesRBase as a 3-byte-per-entry target stream.
;------------------------------------------------------------------------------
ESQ_IncCopperListsTowardsTargets:
    MOVEM.L D2-D6/A2-A3,-(A7)
    LEA     _WDISP_PaletteTriplesRBase,A1
    LEA     _ESQ_CopperStatusDigitsA,A2
    LEA     ESQ_CopperStatusDigitsB,A3
    MOVE.W  #0,D5
    MOVEQ   #7,D4

.update_dual_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_dual_loop
    MOVEQ   #23,D4

.update_primary_loop:
    MOVE.W  0(A2,D5.W),D0
    BSR.S   _ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    ADDQ.W  #4,D5
    DBF     D4,.update_primary_loop
    MOVEM.L (A7)+,D2-D6/A2-A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQ_NoOp_0074   (NoOpStub_0074)
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
ESQ_NoOp_0074:
    RTS

;!======

; Orphaned helper? No known callers; only referenced internally.
;------------------------------------------------------------------------------
; FUNC: ESQ_IncCopperListsAltSkipIndex4   (IncCopperListsAltSkipIndex4uncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0, D2-D5, A1-A3
; CALLS:
;   _ESQ_BumpColorTowardTargets
; READS:
;   ESQ_BannerPaletteWordsA, ESQ_BannerPaletteWordsB
; WRITES:
;   ESQ_BannerPaletteWordsA, ESQ_BannerPaletteWordsB
; DESC:
;   Adjusts alternate copper list colors based on the target stream,
;   skipping the entry at byte offset 4.
; NOTES:
;   This block is currently marked unreachable.
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
    BSR.S   _ESQ_BumpColorTowardTargets

    MOVE.W  D0,0(A2,D5.W)
    MOVE.W  D0,0(A3,D5.W)

.skip_index4:
    ADDQ.W  #4,D5
    DBF     D4,.update_loop
    MOVEM.L (A7)+,D2-D5/A2-A3
    RTS

;!======