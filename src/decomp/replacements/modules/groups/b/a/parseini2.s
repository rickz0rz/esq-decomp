;------------------------------------------------------------------------------
; DECOMP TARGETS parseini2 clock/date rtc helper module boundary
; SOURCE: modules/groups/b/a/parseini2.s
; PURPOSE:
;   Seed hybrid replacement boundary for the PARSEINI2 module now that the
;   restored SAS/C lane covers the module's non-JMPTBL export set in the
;   current checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/parseini2.s"
