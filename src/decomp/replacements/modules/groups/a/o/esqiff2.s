;------------------------------------------------------------------------------
; DECOMP TARGETS ESQIFF2 serial/status ingest helper module boundary
; SOURCE: modules/groups/a/o/esqiff2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ESQIFF2 module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL serial/status
;   ingest helpers in the maintained sweep. The hybrid build still delegates to
;   the canonical asm module for now; future passes can replace individual
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/o/esqiff2.s"
