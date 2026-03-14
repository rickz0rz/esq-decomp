;------------------------------------------------------------------------------
; DECOMP TARGETS unknown5 string helper foothold module boundary
; SOURCE: modules/submodules/unknown5.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN5 now that the restored
;   SAS/C lane covers the module's current non-JMPTBL helper foothold,
;   including STRING_AppendN, STRING_CompareN, STRING_CompareNoCase,
;   STRING_CompareNoCaseN, and STRING_CopyPadNul.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown5.s"
