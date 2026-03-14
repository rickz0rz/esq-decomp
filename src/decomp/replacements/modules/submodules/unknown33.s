;------------------------------------------------------------------------------
; DECOMP TARGETS unknown33 allocator/search helper module boundary
; SOURCE: modules/submodules/unknown33.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN33 now that the GCC
;   promotion lanes for ALLOC_InsertFreeBlock and STRING_FindSubstring
;   resolve to zero semantic diffs in the current checkout. The hybrid build
;   still delegates to the canonical asm module for now; future passes can
;   replace these helpers here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown33.s"
