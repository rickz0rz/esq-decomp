    XDEF    _ED1_EnterEscMenu
    XDEF    _ED1_EnterEscMenu_AfterVersionText


;------------------------------------------------------------------------------
; FUNC: _ED1_EnterEscMenu   (Initialize ESC menu screen/state)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D7
; CALLS:
;   _LVOSetFont, _LVOInitBitMap, _LVOSetRast, _LVOSetDrMd, _LVODisable, _LVOEnable,
;   _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte, _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight,
;   _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults, _ED_DrawESCMenuBottomHelp,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow,
;   _DISPLIB_DisplayTextAtPosition, _ESQIFF_RunCopperDropTransition, _ESQIFF_RunCopperRiseTransition
; READS:
;   _ESQ_TAG_36, _ED_DiagScrollSpeedChar, _KYBD_CustomPaletteTriplesRBase, _ED_DiagGraphModeChar, _ED_SaveTextAdsOnExitFlag
; WRITES:
;   _Global_UIBusyFlag, _ED_SavedDiagGraphModeChar, _ED_SaveTextAdsOnExitFlag, _ED_MaxAdNumber, _ED_TextLimit, _ED_BlockOffset,
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _WDISP_PaletteTriplesRBase
; DESC:
;   Prepares the ESC menu UI, computes layout values, and draws the version row.
; NOTES:
;   Copies 24 bytes from _KYBD_CustomPaletteTriplesRBase into _WDISP_PaletteTriplesRBase.
;   Local version buffer is 41 bytes (-41(A5)..-1(A5)); _WDISP_SPrintf has no
;   destination-length parameter, so format/string edits must keep headroom.
;------------------------------------------------------------------------------
_ED1_EnterEscMenu:

.versionBanner   = -41

    LINK.W  A5,#-48
    MOVEM.L D2/D7,-(A7)

    MOVE.W  #1,_Global_UIBusyFlag
    MOVE.B  _ED_DiagGraphModeChar,D0
    MOVE.B  D0,_ED_SavedDiagGraphModeChar
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L _Global_HANDLE_H26F_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    LEA     _Global_REF_696_400_BITMAP,A0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVE.L  A0,4(A1)
    MOVEQ   #3,D0
    MOVE.L  #696,D1
    MOVE.L  #509,D2
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetRast(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     _ESQIFF_RunCopperDropTransition(PC)

    MOVEQ   #0,D7

.copy_template_loop:
    MOVEQ   #24,D0
    CMP.L   D0,D7
    BGE.S   .after_copy_template

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D7,A0
    LEA     _KYBD_CustomPaletteTriplesRBase,A1
    ADDA.L  D7,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D7
    BRA.S   .copy_template_loop

.after_copy_template:
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    CLR.W   _ESQSHARED_BannerColorModeWord
    PEA     3.W
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    CLR.L   _ED_SaveTextAdsOnExitFlag
    JSR     _ED1_JMPTBL_GCOMMAND_SeedBannerDefaults(PC)

    ADDQ.W  #4,A7
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEQ   #0,D0
    MOVE.B  _ESQ_TAG_36,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  _ESQ_TAG_36+1,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,_ED_MaxAdNumber
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagScrollSpeedChar,D0
    SUB.L   D1,D0
    MOVE.L  D0,_ED_TextLimit
    MOVEQ   #6,D1
    CMP.L   D1,D0
    BLE.S   .clamp_minor_version

    MOVE.L  D1,_ED_TextLimit
    MOVE.B  #$36,_ED_DiagScrollSpeedChar

.clamp_minor_version:
    MOVE.L  _ED_TextLimit,D0
    MOVEQ   #40,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_ED_BlockOffset
    MOVEQ   #1,D0
    MOVE.L  D0,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    ; 41-byte local buffer, reused for centered version row text.
    MOVE.L  _Global_LONG_PATCH_VERSION_NUMBER,-(A7)
    PEA     _Global_STR_NINE_POINT_ZERO
    PEA     _Global_STR_VER_PERCENT_S_PERCENT_L_D
    PEA     .versionBanner(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    JSR     _ED1_JMPTBL_CLEANUP_DrawDateTimeBannerRow(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_version_text

    ADDQ.L  #1,D1

.center_version_text:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    MOVEQ   #33,D0
    ADD.L   D0,D1
    PEA     .versionBanner(A5)
    MOVE.L  D1,-(A7)
    PEA     280.W
    MOVE.L  A1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    JSR     _ESQIFF_RunCopperRiseTransition(PC)

;------------------------------------------------------------------------------
; FUNC: _ED1_EnterEscMenu_AfterVersionText   (Routine at _ED1_EnterEscMenu_AfterVersionText)
; ARGS:
;   stack +52: arg_1 (via 56(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState
; READS:
;   _LOCAVAIL_PrimaryFilterState
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_ED1_EnterEscMenu_AfterVersionText:
    PEA     _LOCAVAIL_PrimaryFilterState
    JSR     _ED1_JMPTBL_LOCAVAIL_ResetFilterCursorState(PC)

    MOVEM.L -56(A5),D2/D7
    UNLK    A5
    RTS

;!======