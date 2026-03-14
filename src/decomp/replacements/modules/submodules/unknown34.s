;------------------------------------------------------------------------------
; DECOMP TARGETS unknown34 MEM/LIST/DOS helper foothold module boundary
; SOURCE: modules/submodules/unknown34.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN34 now that the restored
;   SAS/C lane covers the module's current non-JMPTBL helper foothold,
;   including LIST_InitHeader, MEM_Move, and DOS_ReadByIndex.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown34.s"
