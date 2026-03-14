;------------------------------------------------------------------------------
; DECOMP TARGETS unknown13 callback formatter helper module boundary
; SOURCE: modules/submodules/unknown13.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN13 now that the GCC
;   promotion lanes for FORMAT_CallbackWriteChar and
;   FORMAT_FormatToCallbackBuffer resolve to zero semantic diffs in the
;   current checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace these helpers here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown13.s"
