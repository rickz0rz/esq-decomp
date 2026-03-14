;------------------------------------------------------------------------------
; DECOMP TARGETS TLIBA3 view-mode/grid helper module boundary
; SOURCE: modules/groups/b/a/tliba3.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the TLIBA3 module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL view-mode,
;   pattern-table, and scale/overlay helper cluster in local compare lanes.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/tliba3.s"
