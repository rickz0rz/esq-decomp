;------------------------------------------------------------------------------
; DECOMP TARGETS _main/a/a ESQ startup/shutdown helper module boundary
; SOURCE: modules/groups/_main/a/a.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the primary _main startup/shutdown
;   module now that the restored SAS/C lane covers ESQ_StartupEntry,
;   ESQ_ReturnWithStackCode, and ESQ_ShutdownAndReturn in the current
;   checkout. The hybrid build still delegates to the canonical asm module
;   for now; future passes can swap object-level replacements here without
;   another root include-graph edit.
;------------------------------------------------------------------------------

    include "modules/groups/_main/a/a.s"
