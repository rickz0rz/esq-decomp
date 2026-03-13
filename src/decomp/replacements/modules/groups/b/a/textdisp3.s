;------------------------------------------------------------------------------
; DECOMP TARGETS textdisp3 text/layout helper module boundary
; SOURCE: modules/groups/b/a/textdisp3.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the TEXTDISP3 module now that the
;   current checkout has restored SAS/C coverage for a useful slice of the
;   module's non-JMPTBL text/layout helpers. The hybrid build still delegates
;   to the canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/textdisp3.s"
