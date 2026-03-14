;------------------------------------------------------------------------------
; DECOMP TARGETS unknown32 handle-close / return helper module boundary
; SOURCE: modules/submodules/unknown32.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the UNKNOWN32 submodule now that the
;   restored SAS/C lane covers the current non-JMPTBL handle teardown helper
;   HANDLE_CloseAllAndReturnWithCode. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace this routine here
;   without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown32.s"
