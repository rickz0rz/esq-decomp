;------------------------------------------------------------------------------
; DECOMP TARGETS diskio buffered file/config I/O module boundary
; SOURCE: modules/groups/a/g/diskio.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the DISKIO module now that the
;   restored SAS/C lane covers its current non-JMPTBL buffered file, config,
;   and drive-probe helper set in the maintained sweep. The hybrid build still
;   delegates to the canonical asm module for now; future passes can replace
;   individual routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/g/diskio.s"
