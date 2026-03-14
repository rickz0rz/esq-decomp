;------------------------------------------------------------------------------
; DECOMP TARGETS TEXTDISP2 preview/highlight helper module boundary
; SOURCE: modules/groups/b/a/textdisp2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the TEXTDISP2 module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL preview,
;   selection-refresh, and display-state helpers in local compare lanes.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/textdisp2.s"
