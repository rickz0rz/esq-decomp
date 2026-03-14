;------------------------------------------------------------------------------
; DECOMP TARGETS ed1 ESC-menu / diagnostics helper foothold module boundary
; SOURCE: modules/groups/a/k/ed1.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ED1 module now that the
;   restored SAS/C lane covers ED1_ClearEscMenuMode with a zero-byte semantic
;   diff in the maintained sweep. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace additional ED1
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/k/ed1.s"
