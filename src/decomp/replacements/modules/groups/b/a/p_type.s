;------------------------------------------------------------------------------
; DECOMP TARGETS p_type promo-id/group-list helper module boundary
; SOURCE: modules/groups/b/a/p_type.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the P_TYPE module now that the
;   restored SAS/C lane covers the module's current non-JMPTBL export set in
;   the maintained checkout. The hybrid build still delegates to the canonical
;   asm module for now; future passes can replace individual routines here
;   without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/p_type.s"
