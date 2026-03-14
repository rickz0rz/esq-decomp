;------------------------------------------------------------------------------
; DECOMP TARGETS unknown26 indexed DOS write helper module boundary
; SOURCE: modules/submodules/unknown26.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN26 now that the restored
;   SAS/C lane covers DOS_WriteByIndex in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown26.s"
