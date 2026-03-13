;------------------------------------------------------------------------------
; DECOMP TARGETS flib log append helper module boundary
; SOURCE: modules/groups/a/r/flib.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the FLIB module now that the
;   restored SAS/C lane covers its current non-JMPTBL log-append helper
;   exports in this checkout. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/r/flib.s"
