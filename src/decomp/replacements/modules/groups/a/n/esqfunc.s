;------------------------------------------------------------------------------
; DECOMP TARGETS ESQFUNC status/clock/ui service module boundary
; SOURCE: modules/groups/a/n/esqfunc.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ESQFUNC module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL status, clock,
;   and UI service helpers in the maintained sweep. The hybrid build still
;   delegates to the canonical asm module for now; future passes can replace
;   individual routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/n/esqfunc.s"
