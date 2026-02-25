;------------------------------------------------------------------------------
; DECOMP TARGET 001
; SOURCE: modules/groups/_main/a/xjump.s
; PURPOSE:
;   First active replacement-module canary for the hybrid decomp pipeline.
;   Keep behavior byte-stable while validating replacement wiring.
;------------------------------------------------------------------------------

    XDEF    GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun
    XDEF    GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll
    XDEF    GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook
    XDEF    GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook   (JumpStub_ESQ_MainExitNoOpHook)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_MainExitNoOpHook
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_MainExitNoOpHook.
;------------------------------------------------------------------------------
GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook:
    JMP     ESQ_MainExitNoOpHook

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook   (JumpStub_ESQ_MainEntryNoOpHook)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_MainEntryNoOpHook
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_MainEntryNoOpHook.
;------------------------------------------------------------------------------
GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook:
    JMP     ESQ_MainEntryNoOpHook

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll   (JumpStub_MEMLIST_FreeAll)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   MEMLIST_FreeAll
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to MEMLIST_FreeAll.
;------------------------------------------------------------------------------
GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll:
    JMP     MEMLIST_FreeAll

;------------------------------------------------------------------------------
; FUNC: GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun   (JumpStub_ESQ_ParseCommandLineAndRun)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_ParseCommandLineAndRun
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_ParseCommandLineAndRun.
;------------------------------------------------------------------------------
GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun:
    JMP     ESQ_ParseCommandLineAndRun
