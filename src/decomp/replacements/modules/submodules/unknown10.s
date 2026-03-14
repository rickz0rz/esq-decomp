;------------------------------------------------------------------------------
; DECOMP TARGETS unknown10 format/parse/open helper foothold module boundary
; SOURCE: modules/submodules/unknown10.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN10 now that the restored
;   SAS/C lane covers a useful set of non-JMPTBL helpers in this module,
;   including FORMAT_U32ToHexString, PARSE_ReadSignedLong,
;   PARSE_ReadSignedLong_NoBranch, HANDLE_OpenEntryWithFlags,
;   UNKNOWN10_PrintfPutcToBuffer, and WDISP_SPrintf.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown10.s"
