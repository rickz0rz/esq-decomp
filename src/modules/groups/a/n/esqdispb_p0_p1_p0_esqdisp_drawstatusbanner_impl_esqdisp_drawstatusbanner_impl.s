    XDEF    _ESQDISP_DrawStatusBanner_Impl
    XDEF    _ESQDISP_DrawStatusBanner
    XDEF    ESQDISP_DrawStatusBanner_Impl_Return



; Draw the status banner into rastport 1 (with optional highlight).
_ESQDISP_DrawStatusBanner:
;------------------------------------------------------------------------------
; FUNC: _ESQDISP_DrawStatusBanner_Impl   (Render status banner rows and sync slot state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange, _ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex, _ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup, _ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList, _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState, _ESQIFF_JMPTBL_MATH_Mulu32, _ESQDISP_PropagatePrimaryTitleMetadataToSecondary, _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _ESQ_STR_B, _ESQ_STR_E, _ESQDISP_StatusBannerClampGateFlag, _ESQDISP_LastPrimaryCountdownValue, _ESQDISP_SecondaryPersistArmGateFlag, _ESQDISP_SecondaryPropagationDoneFlag, _WDISP_StatusDayEntry0, _WDISP_StatusDayEntry1, _WDISP_StatusDayEntry2, _WDISP_StatusDayEntry3, _CLOCK_DaySlotIndex, _CLOCK_CacheMonthIndex0, _CLOCK_CacheDayIndex0, _CLOCK_CacheYear, _DST_PrimaryCountdown, _WDISP_BannerSlotCursor, _CLOCK_HalfHourSlotIndex, _CLOCK_CurrentDayOfYear, lab_0942, lab_0943, lab_0944
; WRITES:
;   _BANNER_ResetPendingFlag, _ESQDISP_SecondaryPersistRequestFlag, _ESQDISP_LastPrimaryCountdownValue, _ESQDISP_SecondaryPersistArmGateFlag, _ESQDISP_SecondaryPropagationDoneFlag, _TLIBA1_StatusBannerPropagateGuard, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _CLOCK_HalfHourSlotIndex
; DESC:
;   Computes the current half-hour banner slot, applies optional range clamp,
;   updates highlight/banner state, and renders status text for active day entries.
; NOTES:
;   May trigger one-time secondary metadata/list propagation when threshold
;   conditions are met near function tail.
;------------------------------------------------------------------------------
_ESQDISP_DrawStatusBanner_Impl:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.W  38(A7),D7
    MOVEQ   #0,D5
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     _CLOCK_DaySlotIndex
    JSR     _ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,_CLOCK_HalfHourSlotIndex
    TST.W   _ESQDISP_StatusBannerClampGateFlag
    BEQ.S   .lab_0934

    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVEQ   #0,D0
    MOVE.B  _ESQ_STR_B,D0
    MOVEQ   #0,D2
    MOVE.B  _ESQ_STR_E,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     _ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange(PC)

    LEA     12(A7),A7

.lab_0934:
    JSR     _ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    TST.W   D7
    BEQ.S   .lab_0935

    MOVEQ   #1,D0
    MOVE.W  D0,_BANNER_ResetPendingFlag

.lab_0935:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0937

    MOVEQ   #39,D1
    CMP.W   D1,D0
    BCC.S   .lab_0937

    MOVE.W  _WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,_TEXTDISP_PrimaryGroupCode
    MOVE.W  _CLOCK_CacheDayIndex0,D0
    MOVEQ   #31,D3
    CMP.W   D3,D0
    BNE.S   .lab_0936

    MOVE.W  _CLOCK_CacheMonthIndex0,D0
    MOVEQ   #11,D3
    CMP.W   D3,D0
    BNE.S   .lab_0936

    MOVE.B  #$1,_TEXTDISP_SecondaryGroupCode
    BRA.S   .lab_093A

.lab_0936:
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    ADDQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,_TEXTDISP_SecondaryGroupCode
    BRA.S   .lab_093A

.lab_0937:
    MOVE.W  _WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,_TEXTDISP_SecondaryGroupCode
    MOVE.W  _WDISP_BannerSlotCursor,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0939

    MOVE.W  _CLOCK_CacheYear,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    BNE.S   .lab_0938

    MOVE.B  #$6e,_TEXTDISP_PrimaryGroupCode
    BRA.S   .lab_093A

.lab_0938:
    MOVE.B  #$6d,_TEXTDISP_PrimaryGroupCode
    BRA.S   .lab_093A

.lab_0939:
    MOVE.W  _WDISP_BannerSlotCursor,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,_TEXTDISP_PrimaryGroupCode

.lab_093A:
    MOVE.W  _DST_PrimaryCountdown,D0
    MOVE.W  _ESQDISP_LastPrimaryCountdownValue,D1
    CMP.W   D0,D1
    BEQ.S   .lab_093C

    MOVE.W  D0,_ESQDISP_LastPrimaryCountdownValue
    SUBQ.W  #1,D0
    BNE.S   .lab_093C

    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #3,D0
    BNE.S   .lab_093B

    MOVEQ   #0,D0
    MOVE.W  D0,_ESQDISP_SecondaryPersistArmGateFlag
    BRA.S   .lab_093C

.lab_093B:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #46,D1
    CMP.W   D1,D0
    BNE.S   .lab_093C

    CLR.W   _ESQDISP_SecondaryPropagationDoneFlag

.lab_093C:
    MOVEQ   #0,D6

.lab_093D:
    TST.L   D5
    BNE.S   .lab_0941

    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .lab_0941

    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     _WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   16(A1)
    BNE.S   .lab_093E

    MOVE.W  _CLOCK_CurrentDayOfYear,D1
    EXT.L   D1
    ADD.L   D6,D1
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    CMP.L   (A1),D1
    BEQ.S   .lab_093F

.lab_093E:
    MOVE.W  _CLOCK_CurrentDayOfYear,D0
    EXT.L   D0
    ADD.L   D6,D0
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    ADDA.L  D0,A0
    MOVE.L  24(A7),D0
    ADDI.L  #$100,D0
    CMP.L   (A0),D0
    BEQ.S   .lab_093F

    MOVEQ   #0,D0
    BRA.S   .lab_0940

.lab_093F:
    MOVEQ   #1,D0

.lab_0940:
    MOVE.L  D0,D5
    ADDQ.L  #1,D6
    BRA.S   .lab_093D

.lab_0941:
    TST.L   D5
    BEQ.S   .lab_0945

    LEA     _WDISP_StatusDayEntry1,A0
    MOVEA.L A0,A1
    LEA     _WDISP_StatusDayEntry0,A2
    MOVEQ   #4,D0

.lab_0942:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0942
    LEA     _WDISP_StatusDayEntry2,A0
    MOVEA.L A0,A1
    LEA     _WDISP_StatusDayEntry1,A2
    MOVEQ   #4,D0

.lab_0943:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0943
    LEA     _WDISP_StatusDayEntry3,A0
    LEA     _WDISP_StatusDayEntry2,A1
    MOVEQ   #4,D0

.lab_0944:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_0944
    MOVEQ   #1,D0
    MOVE.L  D0,_TLIBA1_StatusBannerPropagateGuard

.lab_0945:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0946

    MOVEQ   #0,D0
    MOVE.W  D0,_ESQDISP_SecondaryPersistArmGateFlag

.lab_0946:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0947

    TST.W   _ESQDISP_SecondaryPersistArmGateFlag
    BNE.S   .lab_0947

    MOVEQ   #1,D1
    MOVE.L  D1,_ESQDISP_SecondaryPersistRequestFlag
    MOVE.W  #1,_ESQDISP_SecondaryPersistArmGateFlag

.lab_0947:
    MOVEQ   #44,D1
    CMP.W   D1,D0
    BNE.S   .lab_0948

    MOVEQ   #0,D1
    MOVE.W  D1,_ESQDISP_SecondaryPropagationDoneFlag

.lab_0948:
    MOVEQ   #45,D1
    CMP.W   D1,D0
    BCS.S   ESQDISP_DrawStatusBanner_Impl_Return

    TST.W   _ESQDISP_SecondaryPropagationDoneFlag
    BNE.S   ESQDISP_DrawStatusBanner_Impl_Return

    BSR.W   _ESQDISP_PropagatePrimaryTitleMetadataToSecondary

    JSR     _ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup(PC)

    JSR     _ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList(PC)

    MOVE.W  #1,_ESQDISP_SecondaryPropagationDoneFlag

;------------------------------------------------------------------------------
; FUNC: ESQDISP_DrawStatusBanner_Impl_Return   (Return tail for status-banner renderer)
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
;   Restores saved registers/frame and returns to caller.
; NOTES:
;   Shared exit for all draw/early-return paths.
;------------------------------------------------------------------------------
ESQDISP_DrawStatusBanner_Impl_Return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2
    UNLK    A5
    RTS

;!======