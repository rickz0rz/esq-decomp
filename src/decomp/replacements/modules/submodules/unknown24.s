;------------------------------------------------------------------------------
; DECOMP TARGETS unknown24 memlist/parse helper foothold module boundary
; SOURCE: modules/submodules/unknown24.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN24 now that the restored
;   SAS/C lane covers the module's current non-JMPTBL helper foothold,
;   including MEMLIST_AllocTracked, MEMLIST_FreeAll,
;   PARSE_ReadSignedLongSkipClass3, and
;   PARSE_ReadSignedLongSkipClass3_Alt.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown24.s"
