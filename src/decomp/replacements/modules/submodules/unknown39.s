;------------------------------------------------------------------------------
; DECOMP TARGETS unknown39 graphics blit helper module boundary
; SOURCE: modules/submodules/unknown39.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN39 now that the restored
;   SAS/C lane covers GRAPHICS_BltBitMapRastPort in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown39.s"
