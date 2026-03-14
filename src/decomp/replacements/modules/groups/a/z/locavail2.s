;------------------------------------------------------------------------------
; DECOMP TARGETS locavail2 intuition override helper module boundary
; SOURCE: modules/groups/a/z/locavail2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the LOCAVAIL2 module now that the
;   restored SAS/C lane covers its current non-JMPTBL intuition override
;   helpers in this checkout. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/z/locavail2.s"
