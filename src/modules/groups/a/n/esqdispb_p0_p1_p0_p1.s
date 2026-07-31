    XDEF    _ESQDISP_NormalizeClockAndRedrawBanner


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_NormalizeClockAndRedrawBanner   (Normalize clock and redraw banner/status)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A5/A7
; CALLS:
;   _DST_RefreshBannerBuffer, _DST_UpdateBannerQueue, _ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner, _ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData, _ESQDISP_DrawStatusBanner_Impl
; READS:
;   _Global_REF_696_400_BITMAP, _Global_REF_RASTPORT_1, _DST_BannerWindowPrimary, _CLOCK_DaySlotIndex
; WRITES:
;   (none observed)
; DESC:
;   Normalizes clock data, updates banner queue/buffer, draws clock banner on
;   the 696x400 bitmap, then redraws status banner with highlight enabled.
; NOTES:
;   Temporarily swaps rastport bitmap pointer during clock banner draw.
;------------------------------------------------------------------------------
_ESQDISP_NormalizeClockAndRedrawBanner:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,-(A7)
    PEA     _CLOCK_DaySlotIndex
    JSR     _ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(PC)

    PEA     _DST_BannerWindowPrimary
    JSR     _DST_UpdateBannerQueue(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .lab_0932

    JSR     _DST_RefreshBannerBuffer(PC)

.lab_0932:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    JSR     _ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    PEA     1.W
    BSR.W   _ESQDISP_DrawStatusBanner_Impl

    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======