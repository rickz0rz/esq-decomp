;------------------------------------------------------------------------------
; DECOMP TARGETS esq main startup/init module boundary
; SOURCE: modules/groups/a/m/esq.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the ESQ main startup/init module now
;   that the restored SAS/C lane covers `ESQ_MainInitAndRun` in the current
;   checkout. The hybrid build still delegates to the canonical asm module for
;   now; future passes can replace individual routines here without touching
;   the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/m/esq.s"
