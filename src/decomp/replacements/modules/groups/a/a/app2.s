;------------------------------------------------------------------------------
; DECOMP TARGETS app2 ESQ utility/helper module boundary
; SOURCE: modules/groups/a/a/app2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the APP2 module now that the
;   restored SAS/C lane covers the module's non-JMPTBL ESQ helper set in the
;   current checkout. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/a/app2.s"
