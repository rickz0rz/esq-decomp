;------------------------------------------------------------------------------
; DECOMP TARGETS disptext layout/selection helper module boundary
; SOURCE: modules/groups/a/i/disptext.s
; PURPOSE:
;   Seed hybrid replacement boundary for the DISPTEXT module now that the
;   restored SAS/C lane covers the module's non-JMPTBL export set in the
;   current checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/i/disptext.s"
