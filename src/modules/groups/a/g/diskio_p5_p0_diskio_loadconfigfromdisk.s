    XDEF    _DISKIO_LoadConfigFromDisk


; Load the configuration
;------------------------------------------------------------------------------
; FUNC: _DISKIO_LoadConfigFromDisk   (Routine at _DISKIO_LoadConfigFromDisk)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D6/D7
; CALLS:
;   _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _DISKIO_LoadFileToWorkBuffer, _DISKIO_ParseConfigBuffer
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_STR_DF0_CONFIG_DAT_2, _Global_STR_DISKIO_C_9, _Global_PTR_WORK_BUFFER
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_LoadConfigFromDisk:
    LINK.W  A5,#-12
    MOVEM.L D6-D7,-(A7)

    PEA     _Global_STR_DF0_CONFIG_DAT_2
    BSR.W   _DISKIO_LoadFileToWorkBuffer

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BNE.S   .lab_041E

    MOVEQ   #-1,D6
    BRA.S   .return

.lab_041E:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-4(A5)
    BSR.W   _DISKIO_ParseConfigBuffer

    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1344.W
    PEA     _Global_STR_DISKIO_C_9
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEQ   #0,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS
