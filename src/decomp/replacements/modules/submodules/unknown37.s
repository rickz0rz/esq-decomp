;------------------------------------------------------------------------------
; DECOMP TARGETS unknown37 handle close-by-index helper module boundary
; SOURCE: modules/submodules/unknown37.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN37 now that the restored
;   SAS/C lane covers HANDLE_CloseByIndex in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown37.s"
