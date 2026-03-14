;------------------------------------------------------------------------------
; DECOMP TARGET passthrough hybrid module boundary
; SOURCE: modules/groups/a/j/disptext2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the DATETIME conversion/format
;   helper module now that the current checkout's restored non-JMPTBL compare
;   lanes are green enough for boundary mapping. The hybrid build still
;   delegates to the canonical asm module for now; future promotion passes can
;   replace routines here without another root include-graph edit.
;------------------------------------------------------------------------------

    include "modules/groups/a/j/disptext2.s"
