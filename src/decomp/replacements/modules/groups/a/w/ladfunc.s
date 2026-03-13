;------------------------------------------------------------------------------
; DECOMP TARGETS LADFUNC text-ad/highlight helper module boundary
; SOURCE: modules/groups/a/w/ladfunc.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the LADFUNC module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL text-ad,
;   highlight, and packed-pen helpers in the maintained sweep. The hybrid
;   build still delegates to the canonical asm module for now; future passes
;   can replace individual routines here without touching the root include
;   graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/w/ladfunc.s"
