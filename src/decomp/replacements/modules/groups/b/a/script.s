;------------------------------------------------------------------------------
; DECOMP TARGETS script buffer helper module boundary
; SOURCE: modules/groups/b/a/script.s
; PURPOSE:
;   Seed the hybrid replacement boundary for the SCRIPT module now that its
;   restored SAS/C lane covers the current non-JMPTBL buffer allocation,
;   deallocation, and token-index helper set with zero-byte semantic diffs in
;   the current checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/script.s"
