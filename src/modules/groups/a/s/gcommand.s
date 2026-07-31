    XDEF    _GCOMMAND_LoadDefaultTable




;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_LoadDefaultTable   (Load the built-in gcommand table template into the working buffer (_Global_PTR_WORK_BUFFER).)
; ARGS:
;   (none)
; RET:
;   D0: 1 (success flag)
; CLOBBERS:
;   D0/D7/A0/A1/A5/A6
; CALLS:
;   _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _LVOCopyMem, _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   _GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable, _Global_PTR_WORK_BUFFER, _Global_REF_LONG_FILE_SCRATCH, _GCOMMAND_DigitalNicheEnabledFlag, AbsExecBase, _Global_STR_GCOMMAND_C_1
; WRITES:
;   _Global_PTR_WORK_BUFFER, _GCOMMAND_DigitalNicheListingsTemplatePtr, -8(A5)
; DESC:
;   Load the built-in gcommand table template into the working buffer (_Global_PTR_WORK_BUFFER).
; NOTES:
;   Copies a 32-byte template into the active table and frees the prior block.
;------------------------------------------------------------------------------
_GCOMMAND_LoadDefaultTable:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    PEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .return

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-8(A5)
    LEA     _GCOMMAND_DigitalNicheEnabledFlag,A1
    MOVEQ   #32,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #32,D0
    ADD.L   D0,_Global_PTR_WORK_BUFFER
    SUBA.L  A0,A0
    MOVE.L  A0,_GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  A0,-(A7)
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_DigitalNicheListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -8(A5),-(A7)
    PEA     335.W
    PEA     _Global_STR_GCOMMAND_C_1
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7

.return:
    MOVEQ   #1,D0
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======