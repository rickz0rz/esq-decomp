;------------------------------------------------------------------------------
; DECOMP TARGETS unknown14 handle-open helper module boundary
; SOURCE: modules/submodules/unknown14.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN14 now that the restored
;   SAS/C lane covers HANDLE_OpenFromModeString with a zero-byte semantic diff
;   in the maintained sweep. The hybrid build still delegates to the canonical
;   asm module for now; future passes can replace this helper here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown14.s"
