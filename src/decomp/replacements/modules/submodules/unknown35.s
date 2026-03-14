;------------------------------------------------------------------------------
; DECOMP TARGETS unknown35 handle open-with-mode helper module boundary
; SOURCE: modules/submodules/unknown35.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN35 now that the restored
;   SAS/C lane covers HANDLE_OpenWithMode in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown35.s"
