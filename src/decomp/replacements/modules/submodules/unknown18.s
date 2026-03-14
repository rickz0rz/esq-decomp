;------------------------------------------------------------------------------
; DECOMP TARGETS unknown18 DOS seek-with-error helper module boundary
; SOURCE: modules/submodules/unknown18.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN18 now that the restored
;   SAS/C lane covers DOS_SeekWithErrorState in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown18.s"
