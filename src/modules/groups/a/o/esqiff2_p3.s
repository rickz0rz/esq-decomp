    XDEF    _ESQIFF2_ShowVersionMismatchOverlay
    XDEF    ESQIFF2_ShowVersionMismatchOverlay_Return


;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ShowVersionMismatchOverlay   (Validate version and draw mismatch overlay)
; ARGS:
;   stack +36: arg_1 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3
; CALLS:
;   _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, _ESQSHARED_JMPTBL_ESQ_WildcardMatch, _GCOMMAND_SeedBannerFromPrefs, _GROUP_AM_JMPTBL_WDISP_SPrintf, _GROUP_AR_JMPTBL_STRING_AppendAtNull, _LVODisable, _LVOEnable, _LVORectFill, _LVOSetAPen
; READS:
;   AbsExecBase, _Global_LONG_PATCH_VERSION_NUMBER, _Global_REF_696_400_BITMAP, _Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _Global_STR_APOSTROPHE, _Global_STR_MAJOR_MINOR_VERSION_1, _Global_STR_MAJOR_MINOR_VERSION_2, ESQIFF2_ShowVersionMismatchOverlay_Return, _ESQIFF_FMT_PCT_S_DOT_PCT_LD, _ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA, _ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD, _ESQIFF_STR_CORRECT_VERSION_IS, _ED_DiagnosticsScreenActive, _Global_UIBusyFlag, _ESQIFF_RecordBufferPtr, lab_0B24
; WRITES:
;   _ESQPARS2_ReadModeFlags, _ED_DiagnosticsScreenActive
; DESC:
;   Compares incoming version text against the local major/minor string and, on
;   mismatch, draws a blocking correction overlay with current/correct versions.
; NOTES:
;   Skips drawing when UI is busy and diagnostics screen is inactive.
;------------------------------------------------------------------------------
_ESQIFF2_ShowVersionMismatchOverlay:
    LINK.W  A5,#-40
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    CLR.B   20(A0)
    MOVE.L  _Global_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     _Global_STR_MAJOR_MINOR_VERSION_1
    PEA     _ESQIFF_FMT_PCT_S_DOT_PCT_LD
    PEA     -40(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    LEA     20(A7),A7
    TST.B   D0
    BEQ.W   ESQIFF2_ShowVersionMismatchOverlay_Return

    TST.W   _Global_UIBusyFlag
    BEQ.S   .lab_0B23

    TST.W   _ED_DiagnosticsScreenActive
    BEQ.W   ESQIFF2_ShowVersionMismatchOverlay_Return

.lab_0B23:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    JSR     _GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    CLR.W   _ED_DiagnosticsScreenActive
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #60,D1
    MOVE.L  #679,D2
    MOVEQ   #100,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    PEA     _ESQIFF_STR_INCORRECT_VERSION_PLEASE_CORRECT_ASA
    PEA     90.W
    PEA     30.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _Global_LONG_PATCH_VERSION_NUMBER,(A7)
    PEA     _Global_STR_MAJOR_MINOR_VERSION_2
    PEA     _ESQIFF_FMT_YOUR_VERSION_IS_PCT_S_DOT_PCT_LD
    PEA     -40(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -40(A5)
    PEA     120.W
    PEA     30.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     _ESQIFF_STR_CORRECT_VERSION_IS,A0
    LEA     -40(A5),A1
    MOVEQ   #4,D0

; Concatenate a string with an apostrophe before displaying
; the text at a 30,150
.lab_0B24:
    MOVE.L  (A0)+,(A1)+ ; Iterate copying A0 into A1 and...
    DBF     D0,.lab_0B24 ; incrementing both until A0 is null.

    CLR.B   (A1)
    MOVEA.L _ESQIFF_RecordBufferPtr,A0
    ADDQ.L  #1,A0
    MOVE.L  A0,(A7)
    PEA     -40(A5)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     _Global_STR_APOSTROPHE
    PEA     -40(A5)
    JSR     _GROUP_AR_JMPTBL_STRING_AppendAtNull(PC)

    PEA     -40(A5)
    PEA     150.W
    PEA     30.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     72(A7),A7

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowVersionMismatchOverlay_Return   (Return tail for mismatch overlay)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for _ESQIFF2_ShowVersionMismatchOverlay.
; NOTES:
;   Restores D2-D3 and frame state before returning.
;------------------------------------------------------------------------------
ESQIFF2_ShowVersionMismatchOverlay_Return:
    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======