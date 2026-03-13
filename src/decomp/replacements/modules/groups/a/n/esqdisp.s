;------------------------------------------------------------------------------
; DECOMP TARGETS ESQDISP status/highlight/grid bridge module boundary
; SOURCE: modules/groups/a/n/esqdisp.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ESQDISP module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL display/status
;   helpers in the maintained sweep. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/n/esqdisp.s"
