;------------------------------------------------------------------------------
; DECOMP TARGETS esqpars serial-parser/state persistence helper module boundary
; SOURCE: modules/groups/a/o/esqpars.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ESQPARS module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL parser/state
;   helpers in this checkout. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/o/esqpars.s"
