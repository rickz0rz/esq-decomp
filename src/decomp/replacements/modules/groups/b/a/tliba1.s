;------------------------------------------------------------------------------
; DECOMP TARGETS TLIBA1 formatted-text/status helper module boundary
; SOURCE: modules/groups/b/a/tliba1.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the TLIBA1 module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL formatted-text,
;   clock-format, and style parsing helpers in local compare lanes. The hybrid
;   build still delegates to the canonical asm module for now; future passes
;   can replace individual routines here without touching the root include
;   graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/tliba1.s"
