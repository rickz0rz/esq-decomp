;------------------------------------------------------------------------------
; DECOMP TARGETS ESQSHARED entry/default/title helper module boundary
; SOURCE: modules/groups/a/p/esqshared.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ESQSHARED module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL entry/default,
;   title-filter, and selection-code helper foothold in this checkout. The
;   hybrid build still delegates to the canonical asm module for now; future
;   passes can replace individual routines here without touching the root
;   include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/p/esqshared.s"
