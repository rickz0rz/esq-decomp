;------------------------------------------------------------------------------
; DECOMP TARGETS unknown31 buffer allocation helper module boundary
; SOURCE: modules/submodules/unknown31.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN31 now that the restored
;   SAS/C lane covers BUFFER_EnsureAllocated in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown31.s"
