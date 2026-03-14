;------------------------------------------------------------------------------
; DECOMP TARGET passthrough hybrid module boundary
; SOURCE: modules/groups/a/j/xjump.s
; PURPOSE:
;   Seed a hybrid replacement boundary for this module now that the current
;   checkout's restored compare lanes are green enough for boundary mapping.
;   The hybrid build still delegates to the canonical asm module for now;
;   future promotion passes can replace routines here without another root
;   include-graph edit.
;------------------------------------------------------------------------------

    include "modules/groups/a/j/xjump.s"
