;------------------------------------------------------------------------------
; DECOMP TARGETS gcommand2 helper foothold module boundary
; SOURCE: modules/groups/a/t/gcommand2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the GCOMMAND2 module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL helper foothold
;   (`GCOMMAND_CopyGfxToWorkIfAvailable`, `GCOMMAND_FindPathSeparator`) in this
;   checkout. The hybrid build still delegates to the canonical asm module for
;   now; future passes can replace individual routines here without touching
;   the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/t/gcommand2.s"
