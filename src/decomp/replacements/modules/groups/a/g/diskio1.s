;------------------------------------------------------------------------------
; DECOMP TARGETS diskio1 compact dump/flag helper module boundary
; SOURCE: modules/groups/a/g/diskio1.s
; PURPOSE:
;   Seed hybrid replacement boundary for the DISKIO1 module now that the
;   restored SAS/C lane covers its current non-JMPTBL compact dump/flag helper
;   set in the maintained sweep. The hybrid build still delegates to the
;   canonical asm module for now; future passes can replace individual routines
;   here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/g/diskio1.s"
