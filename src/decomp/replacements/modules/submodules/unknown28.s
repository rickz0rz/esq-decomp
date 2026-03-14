;------------------------------------------------------------------------------
; DECOMP TARGETS unknown28 WDISP callback formatter module boundary
; SOURCE: modules/submodules/unknown28.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN28 now that the restored
;   SAS/C lane covers WDISP_FormatWithCallback in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown28.s"
