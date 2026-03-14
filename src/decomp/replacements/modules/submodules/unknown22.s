;------------------------------------------------------------------------------
; DECOMP TARGETS unknown22 arithmetic/msgport helper foothold module boundary
; SOURCE: modules/submodules/unknown22.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN22 now that the restored
;   SAS/C lane covers the module's current non-JMPTBL helper foothold,
;   including ALLOCATE_AllocAndInitializeIOStdReq,
;   DOS_CloseWithSignalCheck, MATH_DivS32, MATH_DivU32,
;   MATH_Mulu32, and SIGNAL_CreateMsgPortWithSignal.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown22.s"
