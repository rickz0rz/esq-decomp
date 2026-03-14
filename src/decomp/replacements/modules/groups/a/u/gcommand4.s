;------------------------------------------------------------------------------
; DECOMP TARGETS gcommand4 brush-result helper foothold module boundary
; SOURCE: modules/groups/a/u/gcommand4.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the GCOMMAND4 module now that the
;   restored SAS/C lane covers GCOMMAND_SaveBrushResult with a zero-byte
;   semantic diff in the current checkout. The hybrid build still delegates to
;   the canonical asm module for now; future passes can replace additional
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/u/gcommand4.s"
