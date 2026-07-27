    XDEF    _GCOMMAND_LoadMplexTemplate

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_LoadMplexTemplate   (Load the Digital_Mplex template and stage it in _GCOMMAND_MplexListingsTemplatePtr/_GCOMMAND_MplexAtTemplatePtr.)
; ARGS:
;   stack +8: arg_1 (via 12(A5))
;   stack +12: arg_2 (via 16(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D7
; CALLS:
;   _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _GROUP_AS_JMPTBL_STR_FindCharPtr, _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _ESQPARS_ReplaceOwnedString, _NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _LVOCopyMem
; READS:
;   AbsExecBase, _Global_REF_LONG_FILE_SCRATCH, _Global_STR_GCOMMAND_C_2, _GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad, _GCOMMAND_FMT_PCT_T_MplexTemplateLoad, _Global_PTR_WORK_BUFFER, _GCOMMAND_DigitalMplexEnabledFlag, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr, return
; WRITES:
;   _Global_PTR_WORK_BUFFER, _GCOMMAND_MplexListingsTemplatePtr, _GCOMMAND_MplexAtTemplatePtr
; DESC:
;   Load the Digital_Mplex template and stage it in _GCOMMAND_MplexListingsTemplatePtr/_GCOMMAND_MplexAtTemplatePtr.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_GCOMMAND_LoadMplexTemplate:
    LINK.W  A5,#-16
    MOVE.L  D7,-(A7)
    PEA     _GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    ADDQ.W  #4,A7
    ADDQ.L  #1,D0
    BEQ.W   .return

    MOVEA.L _Global_PTR_WORK_BUFFER,A0
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D7
    MOVE.L  A0,-4(A5)
    LEA     _GCOMMAND_DigitalMplexEnabledFlag,A1
    MOVEQ   #52,D0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

    MOVEQ   #52,D0
    ADD.L   D0,_Global_PTR_WORK_BUFFER
    SUBA.L  A0,A0
    MOVE.L  A0,_GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  A0,_GCOMMAND_MplexAtTemplatePtr
    PEA     18.W
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _GROUP_AS_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-12(A5)
    TST.L   D0
    BEQ.S   .template_merge

    MOVEA.L D0,A0
    TST.B   (A0)
    BEQ.S   .template_merge

    CLR.B   (A0)+
    MOVE.L  A0,-12(A5)

.template_merge:
    ; Merge template strings into workspace buffers.
    MOVE.L  _GCOMMAND_MplexAtTemplatePtr,-(A7)
    MOVE.L  _Global_PTR_WORK_BUFFER,-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_MplexAtTemplatePtr
    MOVE.L  _GCOMMAND_MplexListingsTemplatePtr,(A7)
    MOVE.L  -12(A5),-(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,_GCOMMAND_MplexListingsTemplatePtr
    MOVE.L  D7,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     575.W
    PEA     _Global_STR_GCOMMAND_C_2
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    CLR.L   -16(A5)
    TST.L   _GCOMMAND_MplexAtTemplatePtr
    BEQ.S   .check_suffix_slot

    MOVEA.L _GCOMMAND_MplexAtTemplatePtr,A0
    TST.B   (A0)
    BEQ.S   .check_suffix_slot

    PEA     _GCOMMAND_FMT_PCT_T_MplexTemplateLoad
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-16(A5)

.check_suffix_slot:
    ; If the marker substring exists, force the following byte to 's'.
    TST.L   -16(A5)
    BEQ.S   .return

    MOVEA.L -16(A5),A0
    TST.B   (A0)
    BEQ.S   .return

    MOVE.B  #$73,1(A0)

.return:
    MOVEQ   #1,D0
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======