;------------------------------------------------------------------------------
; DECOMP TARGETS newgrid1 secondary grid rendering/helper module boundary
; SOURCE: modules/groups/b/a/newgrid1.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the NEWGRID1 module now that the
;   current checkout has restored SAS/C coverage for the module's current
;   non-JMPTBL grid-drawing, scan, and schedule-state helper set in the
;   maintained sweep. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/newgrid1.s"
