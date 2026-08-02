    XDEF    _GCOMMAND_LoadPPV3Template

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_LoadPPV3Template   (Load the Digital_PPV3 template into the working buffer tables.)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D5/D6/D7
; CALLS:
;   _GCOMMAND_LoadPPVTemplate, _GROUP_AS_JMPTBL_STR_FindCharPtr, _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _LVOCopyMem, _LVODeleteFile
; READS:
;   AbsExecBase, _Global_REF_DOS_LIBRARY_2, _Global_REF_LONG_FILE_SCRATCH, _Global_STR_GCOMMAND_C_3, _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad, _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad, _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete, _Global_PTR_WORK_BUFFER, _GCOMMAND_DigitalPpvEnabledFlag, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr, return
; WRITES:
;   _Global_PTR_WORK_BUFFER, _GCOMMAND_PPVListingsTemplatePtr, _GCOMMAND_PPVPeriodTemplatePtr
; DESC:
;   Load the Digital_PPV3 template into the working buffer tables.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_GCOMMAND_LoadPPV3Template:
    LINK.W  A5,#-20
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D6
    MOVEQ   #0,D5
    PEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .try_fallback_template

    ; Found primary template (Digital_PPV3).
    MOVEQ   #56,D6
    BRA.S   .template_ready

.try_fallback_template:
    ; Fall back to alternate template (Digital_PPV).
    PEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.S   .template_ready

    MOVEQ   #52,D6
    LEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete,A0
    MOVE.L  A0,D1
    MOVEA.L _Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    MOVEQ   #1,D5

.template_ready:
    TST.L   D6
    BEQ.W   .return

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-4(A5)
    MOVE.L  D6,D0
    LEA     _GCOMMAND_DigitalPpvEnabledFlag,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    SUBA.L  A0,A0
    MOVE.L  A0,_GCOMMAND_PPVPeriodTemplatePtr
    MOVE.L  A0,_GCOMMAND_PPVListingsTemplatePtr
    ADD.L   D6,_Global_PTR_WORK_BUFFER
    PEA     18.W
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.S   .buffer_ready

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   .buffer_ready

    ; Split buffer: clear leading byte to terminate the first string.
    CLR.B   (A0)+
    MOVE.L  A0,-8(A5)

.buffer_ready:
    MOVE.L  _GCOMMAND_PPVPeriodTemplatePtr,-(A7)
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_PPVPeriodTemplatePtr
    MOVE.L  _GCOMMAND_PPVListingsTemplatePtr,(A7)
    MOVE.L  -8(A5),-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_PPVListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     993.W
    PEA     _Global_STR_GCOMMAND_C_3
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    TST.L   D5
    BEQ.S   .return

    BSR.W   _GCOMMAND_LoadPPVTemplate

.return:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======