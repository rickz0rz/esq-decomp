;------------------------------------------------------------------------------
; DECOMP TARGETS esqiff external-asset/weather/copper helper module boundary
; SOURCE: modules/groups/a/n/esqiff.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ESQIFF module now that the
;   restored SAS/C lane covers the module's non-JMPTBL external-asset,
;   weather-overlay, and copper-animation helper set in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/n/esqiff.s"
