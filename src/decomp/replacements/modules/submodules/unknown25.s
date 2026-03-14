;------------------------------------------------------------------------------
; DECOMP TARGETS unknown25 owned-struct allocation helper module boundary
; SOURCE: modules/submodules/unknown25.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN25 now that the GCC
;   promotion lanes for STRUCT_AllocWithOwner and
;   STRUCT_FreeWithSizeField resolve to zero semantic diffs in the current
;   checkout. The hybrid build still delegates to the canonical asm module
;   for now; future passes can replace these helpers here without touching
;   the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown25.s"
