;------------------------------------------------------------------------------
; DECOMP TARGETS unknown16 buffered close helper module boundary
; SOURCE: modules/submodules/unknown16.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN16 now that the restored
;   SAS/C lane covers BUFFER_FlushAllAndCloseWithCode in the current checkout.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace this helper here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown16.s"
