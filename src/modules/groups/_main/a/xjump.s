    XDEF    _GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun
    XDEF    _GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll
    XDEF    _GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook
    XDEF    _GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook

;------------------------------------------------------------------------------
; FUNC: _GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook   (JumpStub_ESQ_MainExitNoOpHook)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_MainExitNoOpHook
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_MainExitNoOpHook.
;------------------------------------------------------------------------------
_GROUP_MAIN_A_JMPTBL_ESQ_MainExitNoOpHook:
    JMP     _ESQ_MainExitNoOpHook

;------------------------------------------------------------------------------
; FUNC: _GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook   (JumpStub_ESQ_MainEntryNoOpHook)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_MainEntryNoOpHook
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_MainEntryNoOpHook.
;------------------------------------------------------------------------------
_GROUP_MAIN_A_JMPTBL_ESQ_MainEntryNoOpHook:
    JMP     _ESQ_MainEntryNoOpHook

;------------------------------------------------------------------------------
; FUNC: _GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll   (JumpStub_MEMLIST_FreeAll)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _MEMLIST_FreeAll
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _MEMLIST_FreeAll.
;------------------------------------------------------------------------------
_GROUP_MAIN_A_JMPTBL_MEMLIST_FreeAll:
    JMP     _MEMLIST_FreeAll

;------------------------------------------------------------------------------
; FUNC: _GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun   (JumpStub_ESQ_ParseCommandLineAndRun)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   _ESQ_ParseCommandLineAndRun
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to _ESQ_ParseCommandLineAndRun.
;------------------------------------------------------------------------------
_GROUP_MAIN_A_JMPTBL_ESQ_ParseCommandLineAndRun:
    JMP     _ESQ_ParseCommandLineAndRun
