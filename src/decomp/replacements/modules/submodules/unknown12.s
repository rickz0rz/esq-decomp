;------------------------------------------------------------------------------
; DECOMP TARGETS unknown12 free-list allocator helper module boundary
; SOURCE: modules/submodules/unknown12.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN12 now that the restored
;   SAS/C lane covers ALLOC_AllocFromFreeList in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown12.s"
