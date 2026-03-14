;------------------------------------------------------------------------------
; DECOMP TARGETS unknown9 octal formatter helper module boundary
; SOURCE: modules/submodules/unknown9.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN9 now that the restored
;   SAS/C lane covers FORMAT_U32ToOctalString in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown9.s"
