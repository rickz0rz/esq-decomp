;------------------------------------------------------------------------------
; DECOMP TARGETS unknown29 command-line / startup handoff helper module boundary
; SOURCE: modules/submodules/unknown29.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the UNKNOWN29 submodule now that the
;   restored SAS/C lane covers the current non-JMPTBL command-line startup
;   helper ESQ_ParseCommandLineAndRun. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace this routine here
;   without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown29.s"
