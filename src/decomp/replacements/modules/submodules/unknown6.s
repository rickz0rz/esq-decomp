;------------------------------------------------------------------------------
; DECOMP TARGETS unknown6 string append helper module boundary
; SOURCE: modules/submodules/unknown6.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN6 now that the restored
;   SAS/C lane covers STRING_AppendAtNull in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown6.s"
