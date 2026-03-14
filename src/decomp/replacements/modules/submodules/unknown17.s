;------------------------------------------------------------------------------
; DECOMP TARGETS unknown17 DOS write-with-error helper module boundary
; SOURCE: modules/submodules/unknown17.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN17 now that the restored
;   SAS/C lane covers DOS_WriteWithErrorState in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown17.s"
