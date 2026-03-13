;------------------------------------------------------------------------------
; DECOMP TARGETS gcommand main gcommand parser/template helper module boundary
; SOURCE: modules/groups/a/s/gcommand.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the main GCOMMAND module now that
;   the restored SAS/C lane covers the module's current non-JMPTBL parser and
;   template-loading helper set in this checkout. The hybrid build still
;   delegates to the canonical asm module for now; future passes can replace
;   individual routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/s/gcommand.s"
