;------------------------------------------------------------------------------
; DECOMP TARGETS diskio2 data-file transfer module boundary
; SOURCE: modules/groups/a/h/diskio2.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the DISKIO2 module now that the
;   restored SAS/C lane covers its current non-JMPTBL data-file transfer,
;   sync, and ini/oinfo helper set in the maintained sweep. The hybrid build
;   still delegates to the canonical asm module for now; future passes can
;   replace individual routines here without touching the root include graph
;   again.
;------------------------------------------------------------------------------

    include "modules/groups/a/h/diskio2.s"
