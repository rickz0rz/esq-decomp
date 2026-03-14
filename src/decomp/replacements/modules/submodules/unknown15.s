;------------------------------------------------------------------------------
; DECOMP TARGETS unknown15 stream line-reader helper module boundary
; SOURCE: modules/submodules/unknown15.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN15 now that the restored
;   SAS/C lane covers STREAM_ReadLineWithLimit with a zero-byte semantic diff
;   in the maintained sweep. The hybrid build still delegates to the canonical
;   asm module for now; future passes can replace this helper here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown15.s"
