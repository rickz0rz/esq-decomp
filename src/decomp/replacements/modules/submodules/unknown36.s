;------------------------------------------------------------------------------
; DECOMP TARGETS unknown36 abort-request helper module boundary
; SOURCE: modules/submodules/unknown36.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN36 now that the GCC
;   promotion lanes for UNKNOWN36_FinalizeRequest and
;   UNKNOWN36_ShowAbortRequester resolve to zero semantic diffs in the
;   current checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace these helpers here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown36.s"
