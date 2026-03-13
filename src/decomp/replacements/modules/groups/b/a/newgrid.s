;------------------------------------------------------------------------------
; DECOMP TARGETS newgrid primary grid rendering/input module boundary
; SOURCE: modules/groups/b/a/newgrid.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the NEWGRID module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL grid rendering,
;   selection, and resource-management helper set in the maintained sweep.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/newgrid.s"
