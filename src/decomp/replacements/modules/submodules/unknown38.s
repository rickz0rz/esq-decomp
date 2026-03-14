;------------------------------------------------------------------------------
; DECOMP TARGETS unknown38 signal / exit helper module boundary
; SOURCE: modules/submodules/unknown38.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the UNKNOWN38 submodule now that the
;   restored SAS/C lane covers the current non-JMPTBL signal polling helper in
;   the maintained sweep. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace this routine here without touching
;   the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown38.s"
