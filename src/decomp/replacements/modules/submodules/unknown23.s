;------------------------------------------------------------------------------
; DECOMP TARGETS unknown23 handle index helper module boundary
; SOURCE: modules/submodules/unknown23.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN23 now that the restored
;   SAS/C lane covers HANDLE_GetEntryByIndex in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown23.s"
