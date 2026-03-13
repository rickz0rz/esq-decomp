;------------------------------------------------------------------------------
; DECOMP TARGETS script4 banner/inset/highlight helper module boundary
; SOURCE: modules/groups/b/a/script4.s
; PURPOSE:
;   Seed hybrid replacement boundary for the SCRIPT4 module now that its
;   restored SAS/C lanes cover the current non-JMPTBL banner-char, inset-text,
;   and highlight-effect helper set with zero-byte semantic diffs in the
;   maintained checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/script4.s"
