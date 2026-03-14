;------------------------------------------------------------------------------
; DECOMP TARGETS unknown8 decimal formatter helper module boundary
; SOURCE: modules/submodules/unknown8.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN8 now that the restored
;   SAS/C lane covers FORMAT_U32ToDecimalString in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown8.s"
