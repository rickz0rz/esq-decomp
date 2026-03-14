;------------------------------------------------------------------------------
; DECOMP TARGETS textdisp source-config/text selection module boundary
; SOURCE: modules/groups/b/a/textdisp.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the TEXTDISP module now that the
;   current checkout has restored SAS/C coverage for the module's current
;   non-JMPTBL source-config, selection, and text-format helper set in the
;   maintained sweep. The hybrid build still delegates to the canonical asm
;   module for now; future passes can replace individual routines here without
;   touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/b/a/textdisp.s"
