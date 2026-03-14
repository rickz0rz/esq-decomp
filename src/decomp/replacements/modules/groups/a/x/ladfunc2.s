;------------------------------------------------------------------------------
; DECOMP TARGETS LADFUNC2 escaped-string helper module boundary
; SOURCE: modules/groups/a/x/ladfunc2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the LADFUNC2 module now that the
;   restored SAS/C lane covers the module's current escaped-string helper and
;   return-stub slice in the maintained sweep. The hybrid build still delegates
;   to the canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/x/ladfunc2.s"
