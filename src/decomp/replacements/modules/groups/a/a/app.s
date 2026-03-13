;------------------------------------------------------------------------------
; DECOMP TARGETS app ESQ serial/control helper module boundary
; SOURCE: modules/groups/a/a/app.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the APP module now that the
;   restored SAS/C lane covers the module's non-JMPTBL ESQ serial/control
;   helper set in the current checkout. The hybrid build still delegates to
;   the canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/a/app.s"
