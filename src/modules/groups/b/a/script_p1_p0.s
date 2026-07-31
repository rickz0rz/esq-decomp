    XDEF    _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush
    XDEF    _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer
    XDEF    _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes
    XDEF    _SCRIPT_JMPTBL_MEMORY_AllocateMemory
    XDEF    _SCRIPT_JMPTBL_MEMORY_DeallocateMemory


    ; Alignment
    RTS
    DC.W    $0000

;!======

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_JMPTBL_MEMORY_DeallocateMemory   (Routine at _SCRIPT_JMPTBL_MEMORY_DeallocateMemory)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEMORY_DeallocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT_JMPTBL_MEMORY_DeallocateMemory:
    JMP     _MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes   (Routine at _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_WriteBufferedBytes
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes:
    JMP     _DISKIO_WriteBufferedBytes

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush   (Routine at _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_CloseBufferedFileAndFlush
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush:
    JMP     _DISKIO_CloseBufferedFileAndFlush

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_JMPTBL_MEMORY_AllocateMemory   (Routine at _SCRIPT_JMPTBL_MEMORY_AllocateMemory)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEMORY_AllocateMemory
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT_JMPTBL_MEMORY_AllocateMemory:
    JMP     _MEMORY_AllocateMemory

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer   (Routine at _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _DISKIO_OpenFileWithBuffer
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer:
    JMP     _DISKIO_OpenFileWithBuffer

;======

    ; Alignment
    MOVEQ   #97,D0
    RTS
    DC.W    $0000
