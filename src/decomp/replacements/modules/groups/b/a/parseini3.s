;------------------------------------------------------------------------------
; DECOMP TARGETS parseini3 clock/error helper module boundary
; SOURCE: modules/groups/b/a/parseini3.s
; PURPOSE:
;   Seed hybrid replacement boundary for the PARSEINI3 module now that the
;   restored SAS/C lane covers the module's non-JMPTBL export set in the
;   current checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/parseini3.s"
