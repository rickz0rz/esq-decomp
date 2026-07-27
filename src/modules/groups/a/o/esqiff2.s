    XDEF    ESQIFF2_ApplyIncomingStatusPacket
    XDEF    ESQIFF2_ApplyIncomingStatusPacket_Return


; Rename this file to its proper purpose.

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ApplyIncomingStatusPacket   (Apply incoming status packet and refresh UI)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A7/D0/D1/D2/D6/D7
; CALLS:
;   _ED_DrawDiagnosticModeText, ESQDISP_DrawStatusBanner, ESQPARS_JMPTBL_DST_RefreshBannerBuffer, ESQPARS_JMPTBL_DST_UpdateBannerQueue, ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds
; READS:
;   _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED, _ESQ_STR_B, CLOCK_MinuteEventBaseMinute, CLOCK_MinuteEventBaseOffset, _ESQ_STR_6, _ED_DiagVinModeChar, _LOCAVAIL_FilterModeFlag, _DST_BannerWindowPrimary, _ED_SavedScrollSpeedIndex, _ED_DiagnosticsScreenActive, _SCRIPT_RuntimeMode
; WRITES:
;   CLOCK_MinuteEventBaseMinute, CLOCK_MinuteEventBaseOffset, _ESQ_STR_6, _ESQPARS2_StateIndex, SCRIPT_RuntimeModeDeferredFlag
; DESC:
;   Copies status payload bytes into globals, refreshes banner/status UI paths,
;   reseeds minute-event thresholds, and updates scroll-speed state/index.
; NOTES:
;   Triggers diagnostics redraw when diagnostics screen is active.
;------------------------------------------------------------------------------
ESQIFF2_ApplyIncomingStatusPacket:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVE.B  _ED_DiagVinModeChar,D6
    MOVEQ   #0,D7

.lab_0AB9:
    MOVEQ   #20,D0
    CMP.W   D0,D7
    BGE.S   .lab_0ABA

    LEA     _ESQ_STR_B,A0
    ADDA.W  D7,A0
    MOVE.B  0(A3,D7.W),(A0)
    ADDQ.W  #1,D7
    BRA.S   .lab_0AB9

.lab_0ABA:
    TST.L   _LOCAVAIL_FilterModeFlag
    BNE.S   .branch

    MOVE.B  _ED_DiagVinModeChar,D0
    CMP.B   D0,D6
    BEQ.S   .branch

    MOVE.W  _SCRIPT_RuntimeMode,D0
    BEQ.S   .branch

    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_RuntimeModeDeferredFlag

.branch:
    MOVE.B  _ESQ_STR_6,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BCS.S   .branch_1

    MOVEQ   #72,D1
    CMP.B   D1,D0
    BLS.S   .branch_2

.branch_1:
    MOVE.B  #$36,_ESQ_STR_6

.branch_2:
    PEA     _DST_BannerWindowPrimary
    JSR     ESQPARS_JMPTBL_DST_UpdateBannerQueue(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BNE.S   .branch_3

    JSR     ESQPARS_JMPTBL_DST_RefreshBannerBuffer(PC)

.branch_3:
    PEA     1.W
    JSR     ESQDISP_DrawStatusBanner(PC)

    ADDQ.W  #4,A7
    MOVE.B  CLOCK_MinuteEventBaseMinute,D0
    MOVEQ   #9,D1
    CMP.B   D1,D0
    BHI.S   .branch_4

    MOVEQ   #0,D2
    CMP.B   D2,D0
    BHI.S   .branch_5

.branch_4:
    MOVEQ   #1,D2
    MOVE.B  D2,CLOCK_MinuteEventBaseMinute

.branch_5:
    MOVE.B  CLOCK_MinuteEventBaseOffset,D0
    CMP.B   D1,D0
    BHI.S   .branch_6

    MOVEQ   #0,D1
    CMP.B   D1,D0
    BHI.S   .branch_7

.branch_6:
    MOVEQ   #1,D1
    MOVE.B  D1,CLOCK_MinuteEventBaseOffset

.branch_7:
    MOVEQ   #0,D0
    MOVE.B  CLOCK_MinuteEventBaseMinute,D0
    MOVEQ   #0,D1
    MOVE.B  CLOCK_MinuteEventBaseOffset,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQPARS_JMPTBL_ESQ_SeedMinuteEventThresholds(PC)

    ADDQ.W  #8,A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .branch_8

    JSR     _ED_DrawDiagnosticModeText(PC)

.branch_8:
    TST.L   _ED_SavedScrollSpeedIndex
    BNE.S   ESQIFF2_ApplyIncomingStatusPacket_Return

    MOVEQ   #0,D0
    MOVE.B  _ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLT.S   .branch_9

    MOVEQ   #8,D1
    CMP.W   D1,D7
    BGT.S   .branch_9

    MOVE.W  D7,_ESQPARS2_StateIndex
    BRA.S   ESQIFF2_ApplyIncomingStatusPacket_Return

.branch_9:
    MOVE.W  #4,_ESQPARS2_StateIndex

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ApplyIncomingStatusPacket_Return   (Return tail for incoming-status packet handler)
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
;   ESQIFF_StatusPacketReadyFlag
; DESC:
;   Marks banner/status dirty flag, restores registers, and returns.
; NOTES:
;   Shared tail for all post-update state/index clamp paths.
;------------------------------------------------------------------------------
ESQIFF2_ApplyIncomingStatusPacket_Return:
    MOVE.W  #1,ESQIFF_StatusPacketReadyFlag
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======