;------------------------------------------------------------------------------
; DECOMP TARGETS unknown27 secondary formatter buffer helper module boundary
; SOURCE: modules/submodules/unknown27.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN27 now that the GCC
;   promotion lanes for FORMAT_Buffer2WriteChar and FORMAT_FormatToBuffer2
;   resolve to zero semantic diffs in the current checkout. The hybrid build
;   still delegates to the canonical asm module for now; future passes can
;   replace these helpers here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown27.s"
