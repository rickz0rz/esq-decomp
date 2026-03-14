;------------------------------------------------------------------------------
; DECOMP TARGETS unknown21 DOS/file-create and IOStdReq cleanup module boundary
; SOURCE: modules/submodules/unknown21.s
; PURPOSE:
;   Seed a hybrid replacement boundary for UNKNOWN21 now that the restored
;   SAS/C lane covers the module's current non-JMPTBL helper foothold,
;   including IOSTDREQ_Free, IOSTDREQ_CleanupSignalAndMsgport,
;   DOS_OpenNewFileIfMissing, and DOS_DeleteAndRecreateFile.
;   The hybrid build still delegates to the canonical asm module for now;
;   future passes can replace individual routines here without touching the
;   root include graph again.
;------------------------------------------------------------------------------

    include "modules/submodules/unknown21.s"
