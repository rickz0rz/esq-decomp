;------------------------------------------------------------------------------
; DECOMP TARGETS displib text/layout helper module boundary
; SOURCE: modules/groups/a/i/displib.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the DISPLIB module now that the
;   restored SAS/C lane covers the module's non-JMPTBL text/layout helper set
;   in the current checkout. The hybrid build still delegates to the canonical
;   asm module for now; future passes can replace individual routines here
;   without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/i/displib.s"
