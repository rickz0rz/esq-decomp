;------------------------------------------------------------------------------
; DECOMP TARGETS unknown40 battery-clock / DOS wrapper module boundary
; SOURCE: modules/submodules/unknown40.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the UNKNOWN40 submodule now that the
;   restored SAS/C lane covers the current non-JMPTBL battery-clock and DOS
;   wrapper helpers in the maintained sweep. The hybrid build still delegates
;   to the canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown40.s"
