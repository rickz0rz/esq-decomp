;------------------------------------------------------------------------------
; DECOMP TARGETS ctasks asynchronous task helper module boundary
; SOURCE: modules/groups/a/f/ctasks.s
; PURPOSE:
;   Seed hybrid replacement boundary for the CTASKS module now that the
;   restored SAS/C lane covers the module's non-JMPTBL task lifecycle helpers
;   in the maintained sweep. The hybrid build still delegates to the canonical
;   asm module for now; future passes can replace individual routines here
;   without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/f/ctasks.s"
