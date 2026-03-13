;------------------------------------------------------------------------------
; DECOMP TARGETS script2 serial control / handshake helper module boundary
; SOURCE: modules/groups/b/a/script2.s
; PURPOSE:
;   Seed hybrid replacement boundary for the SCRIPT2 module now that its
;   restored SAS/C lanes cover the current non-JMPTBL serial control, handshake,
;   and shadow-register helper set with zero-byte semantic diffs in the
;   maintained checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/script2.s"
