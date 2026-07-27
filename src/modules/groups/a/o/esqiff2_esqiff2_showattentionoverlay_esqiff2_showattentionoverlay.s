    XDEF    _ESQIFF2_ShowAttentionOverlay
    XDEF    ESQIFF2_ShowAttentionOverlay_Return



;------------------------------------------------------------------------------
; FUNC: _ESQIFF2_ShowAttentionOverlay   (Draw attention/error overlay by code)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +124: arg_2 (via 128(A5))
;   stack +134: arg_3 (via 138(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, _GCOMMAND_SeedBannerFromPrefs, _GROUP_AM_JMPTBL_WDISP_SPrintf, _LVODisable, _LVOEnable, _LVORectFill, _LVOSetAPen, _LVOSetDrMd
; READS:
;   AbsExecBase, _BRUSH_SnapshotDepth, _BRUSH_SnapshotHeader, _BRUSH_SnapshotWidth, _Global_STR_PLEASE_STANDBY_2, _Global_REF_696_400_BITMAP, Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _Global_STR_ATTENTION_SYSTEM_ENGINEER_2, _Global_STR_FILE_PERCENT_S, _Global_STR_FILE_WIDTH_COLORS_FORMATTED, _Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL, _Global_STR_REPORT_ERROR_CODE_FORMATTED, ESQIFF2_ShowAttentionOverlay_Return, _ED_DiagnosticsScreenActive, _Global_UIBusyFlag, lab_0B28, lab_0B29_0008, lab_0B29_000C, lab_0B29_0010, lab_0B29_0014, lab_0B29_0018
; WRITES:
;   _COI_AttentionOverlayBusyFlag, _ESQPARS2_ReadModeFlags, _ED_DiagnosticsScreenActive
; DESC:
;   Draws a modal attention overlay with an error code and file context, then
;   restores raster draw mode/bitmap state before returning.
; NOTES:
;   Maps incoming code 1..5 to report codes {1,2,8,9,10}; exits early otherwise.
;------------------------------------------------------------------------------
_ESQIFF2_ShowAttentionOverlay:
    LINK.W  A5,#-140
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVEQ   #-1,D5
    TST.W   _Global_UIBusyFlag
    BEQ.S   .lab_0B27

    TST.W   _ED_DiagnosticsScreenActive
    BEQ.W   ESQIFF2_ShowAttentionOverlay_Return

.lab_0B27:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.S   .lab_0B2A

    CMPI.W  #5,D0
    BGE.S   .lab_0B2A

    ADD.W   D0,D0
    MOVE.W  .lab_0B28(PC,D0.W),D0
    JMP     .lab_0B28+2(PC,D0.W)

; switch/jumptable
.lab_0B28:
    DC.W    .lab_0B29_0008-.lab_0B28-2
    DC.W    .lab_0B29_000C-.lab_0B28-2
    DC.W    .lab_0B29_0010-.lab_0B28-2
    DC.W    .lab_0B29_0014-.lab_0B28-2
    DC.W    .lab_0B29_0018-.lab_0B28-2

.lab_0B29_0008:
    MOVEQ   #1,D5
    BRA.S   .lab_0B2A

.lab_0B29_000C:
    MOVEQ   #2,D5
    BRA.S   .lab_0B2A

.lab_0B29_0010:
    MOVEQ   #8,D5
    BRA.S   .lab_0B2A

.lab_0B29_0014:
    MOVEQ   #9,D5
    BRA.S   .lab_0B2A

.lab_0B29_0018:
    MOVEQ   #10,D5

.lab_0B2A:
    TST.L   D5
    BLE.W   ESQIFF2_ShowAttentionOverlay_Return

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    JSR     _GCOMMAND_SeedBannerFromPrefs(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-138(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    CLR.W   _ED_DiagnosticsScreenActive
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEQ   #65,D1
    MOVE.L  #$2ac,D2
    MOVEQ   #40,D3
    NOT.B   D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.B  28(A0),D6
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     _Global_STR_PLEASE_STANDBY_2
    PEA     90.W
    PEA     35.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_ATTENTION_SYSTEM_ENGINEER_2
    PEA     120.W
    PEA     35.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  D5,(A7)
    PEA     _Global_STR_REPORT_ERROR_CODE_FORMATTED
    PEA     -128(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -128(A5)
    PEA     150.W
    PEA     35.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     56(A7),A7
    MOVEQ   #9,D0
    CMP.L   D0,D5
    BEQ.S   .lab_0B2B

    MOVEQ   #10,D0
    CMP.L   D0,D5
    BNE.S   .lab_0B2C

.lab_0B2B:
    MOVE.L  _BRUSH_SnapshotDepth,-(A7)   ; reuse cached brush dimensions in file dialog
    JSR     _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,(A7)
    MOVE.L  _BRUSH_SnapshotWidth,-(A7)
    PEA     _BRUSH_SnapshotHeader
    PEA     _Global_STR_FILE_WIDTH_COLORS_FORMATTED
    PEA     -128(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7
    MOVE.W  #1,_COI_AttentionOverlayBusyFlag
    BRA.S   .lab_0B2D

.lab_0B2C:
    PEA     _BRUSH_SnapshotHeader
    PEA     _Global_STR_FILE_PERCENT_S
    PEA     -128(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7

.lab_0B2D:
    PEA     -128(A5)
    PEA     180.W
    PEA     35.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    PEA     _Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL
    PEA     210.W
    PEA     35.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVE.L  D6,D0
    EXT.W   D0
    EXT.L   D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -138(A5),4(A0)

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ShowAttentionOverlay_Return   (Return tail for attention overlay)
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
;   Shared return tail for _ESQIFF2_ShowAttentionOverlay.
; NOTES:
;   Restores D2-D3/D5-D7 and frame state before returning.
;------------------------------------------------------------------------------
ESQIFF2_ShowAttentionOverlay_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7
    UNLK    A5
    RTS

;!======