;------------------------------------------------------------------------------
; DECOMP TARGETS kybd input-device initialization foothold module boundary
; SOURCE: modules/groups/a/v/kybd.s
; PURPOSE:
;   Seed a hybrid replacement boundary for the KYBD module now that the
;   restored SAS/C lane covers KYBD_InitializeInputDevices with a zero-byte
;   semantic diff in the current checkout. The hybrid build still delegates to
;   the canonical asm module for now; future passes can replace additional
;   routines here without touching the root include graph again.
;------------------------------------------------------------------------------

    include "modules/groups/a/v/kybd.s"
