;------------------------------------------------------------------------------
; DECOMP TARGETS script3 playback/search/banner helper module boundary
; SOURCE: modules/groups/b/a/script3.s
; PURPOSE:
;   Seed hybrid replacement boundary for the SCRIPT3 module now that its
;   restored SAS/C lanes cover the current non-JMPTBL playback, search-text,
;   and banner-transition helper set with zero-byte semantic diffs in the
;   maintained checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/script3.s"
