;------------------------------------------------------------------------------
; DECOMP TARGETS unknown4 uppercase helper module boundary
; SOURCE: modules/submodules/unknown4.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN4 now that the restored
;   SAS/C lane covers STRING_ToUpperInPlace with a zero-byte semantic diff in
;   the maintained sweep. The hybrid build still delegates to the canonical
;   asm module for now; future passes can replace this helper here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown4.s"
