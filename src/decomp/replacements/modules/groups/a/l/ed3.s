;------------------------------------------------------------------------------
; DECOMP TARGETS ed3 drawing-helper foothold module boundary
; SOURCE: modules/groups/a/l/ed3.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ED3 module now that the
;   restored SAS/C lane covers the paired text/cursor and line/page draw
;   helpers with zero-byte semantic diffs in the current checkout. The hybrid
;   build still delegates to the canonical asm module for now; future passes
;   can replace additional ED3 routines here without touching the root include
;   graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/l/ed3.s"
