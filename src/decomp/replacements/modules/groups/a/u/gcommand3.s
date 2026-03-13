;------------------------------------------------------------------------------
; DECOMP TARGETS gcommand3 banner/highlight helper module boundary
; SOURCE: modules/groups/a/u/gcommand3.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the GCOMMAND3 module now that the
;   restored SAS/C lane covers the module's non-JMPTBL banner/highlight helper
;   set in the current checkout. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/u/gcommand3.s"
