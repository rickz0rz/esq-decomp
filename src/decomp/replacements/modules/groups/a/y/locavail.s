;------------------------------------------------------------------------------
; DECOMP TARGETS locavail local-availability filter helper module boundary
; SOURCE: modules/groups/a/y/locavail.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the LOCAVAIL module now that the
;   restored SAS/C lane covers the current non-JMPTBL local-availability
;   filter helpers in this checkout. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/y/locavail.s"
