    XDEF    ESQDISP_DrawStatusBanner
    XDEF    ESQDISP_DrawStatusBanner_Impl
    XDEF    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty
    XDEF    ESQDISP_NormalizeClockAndRedrawBanner
    XDEF    ESQDISP_PollInputModeAndRefreshSelection
    XDEF    ESQDISP_PropagatePrimaryTitleMetadataToSecondary
    XDEF    ESQDISP_DrawStatusBanner_Impl_Return
    XDEF    ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return
    XDEF    ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return


; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #23,D1
    CMP.W   D1,D7
    SGT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVEM.L D5-D7,-(A7)
    MOVE.W  18(A7),D7
    MOVE.W  22(A7),D6

    MOVEQ   #-1,D0
    CMP.W   D0,D6
    BNE.S   .lab_0929

    CMPI.W  #$16e,D7
    BLE.S   .lab_0929

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_0929:
    TST.W   D6
    BNE.S   .lab_092A

    CMPI.W  #$16d,D7
    BLE.S   .lab_092A

    MOVEQ   #1,D5
    BRA.S   .lab_092B

.lab_092A:
    MOVEQ   #0,D5

.lab_092B:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    TST.W   D7
    SMI     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

; Unreferenced Code
    MOVE.L  D7,-(A7)
    MOVE.W  10(A7),D7

    MOVEQ   #1,D1
    CMP.W   D1,D7
    SLT     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PollInputModeAndRefreshSelection   (Debounce input mode and refresh selection)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0/D1/D7
; CALLS:
;   ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh, ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode
; READS:
;   ESQDISP_LatchedInputModeBit, bfd0ee
; WRITES:
;   ESQDISP_LatchedInputModeBit, ESQDISP_InputModeDebounceCount, _Global_RefreshTickCounter
; DESC:
;   Polls CIAB input mode bits with debounce; when stable change is detected,
;   updates mode state and either resets selection or redraws rast mode.
; NOTES:
;   Requires >5 consecutive polls before committing mode change.
;------------------------------------------------------------------------------
ESQDISP_PollInputModeAndRefreshSelection:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),_Global_RefreshTickCounter
    MOVE.L  #$bfd0ee,-6(A5) ; uncertain, between PRA_CIAB and PRB_CIAB
    MOVEQ   #4,D7
    MOVEA.L -6(A5),A0
    AND.B   (A0),D7
    MOVE.B  ESQDISP_LatchedInputModeBit,D0
    CMP.B   D7,D0
    BEQ.S   .lab_092D

    ADDQ.L  #1,ESQDISP_InputModeDebounceCount
    BRA.S   .lab_092E

.lab_092D:
    MOVEQ   #0,D0
    MOVE.L  D0,ESQDISP_InputModeDebounceCount

.lab_092E:
    CMPI.L  #$5,ESQDISP_InputModeDebounceCount
    BLE.S   .return

    MOVE.L  D7,D0
    MOVE.B  D0,ESQDISP_LatchedInputModeBit
    MOVEQ   #0,D1
    MOVE.L  D1,ESQDISP_InputModeDebounceCount
    TST.B   D0
    BNE.S   .lab_092F

    MOVE.L  D1,-(A7)
    JSR     ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.lab_092F:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_NormalizeClockAndRedrawBanner   (Normalize clock and redraw banner/status)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A5/A7
; CALLS:
;   _DST_RefreshBannerBuffer, DST_UpdateBannerQueue, ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner, ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData, ESQDISP_DrawStatusBanner_Impl
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
ESQDISP_NormalizeClockAndRedrawBanner:
    LINK.W  A5,#-4
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  A3,-(A7)
    PEA     _CLOCK_DaySlotIndex
    JSR     ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData(PC)

    PEA     _DST_BannerWindowPrimary
    JSR     DST_UpdateBannerQueue(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .lab_0932

    JSR     _DST_RefreshBannerBuffer(PC)

.lab_0932:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    JSR     ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    PEA     1.W
    BSR.W   ESQDISP_DrawStatusBanner_Impl

    MOVEA.L -8(A5),A3
    UNLK    A5
    RTS

;!======

; Draw the status banner into rastport 1 (with optional highlight).
ESQDISP_DrawStatusBanner:
;------------------------------------------------------------------------------
; FUNC: ESQDISP_DrawStatusBanner_Impl   (Render status banner rows and sync slot state)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange, ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex, ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup, ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList, ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState, ESQIFF_JMPTBL_MATH_Mulu32, ESQDISP_PropagatePrimaryTitleMetadataToSecondary, _LVOSetAPen
; READS:
;   Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, _ESQ_STR_B, _ESQ_STR_E, ESQDISP_StatusBannerClampGateFlag, ESQDISP_LastPrimaryCountdownValue, ESQDISP_SecondaryPersistArmGateFlag, ESQDISP_SecondaryPropagationDoneFlag, WDISP_StatusDayEntry0, WDISP_StatusDayEntry1, WDISP_StatusDayEntry2, WDISP_StatusDayEntry3, _CLOCK_DaySlotIndex, CLOCK_CacheMonthIndex0, CLOCK_CacheDayIndex0, CLOCK_CacheYear, _DST_PrimaryCountdown, WDISP_BannerSlotCursor, _CLOCK_HalfHourSlotIndex, CLOCK_CurrentDayOfYear, lab_0942, lab_0943, lab_0944
; WRITES:
;   BANNER_ResetPendingFlag, ESQDISP_SecondaryPersistRequestFlag, ESQDISP_LastPrimaryCountdownValue, ESQDISP_SecondaryPersistArmGateFlag, ESQDISP_SecondaryPropagationDoneFlag, TLIBA1_StatusBannerPropagateGuard, _TEXTDISP_SecondaryGroupCode, _TEXTDISP_PrimaryGroupCode, _CLOCK_HalfHourSlotIndex
; DESC:
;   Computes the current half-hour banner slot, applies optional range clamp,
;   updates highlight/banner state, and renders status text for active day entries.
; NOTES:
;   May trigger one-time secondary metadata/list propagation when threshold
;   conditions are met near function tail.
;------------------------------------------------------------------------------
ESQDISP_DrawStatusBanner_Impl:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D5-D7/A2,-(A7)
    MOVE.W  38(A7),D7
    MOVEQ   #0,D5
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     _CLOCK_DaySlotIndex
    JSR     ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    MOVE.W  D0,_CLOCK_HalfHourSlotIndex
    TST.W   ESQDISP_StatusBannerClampGateFlag
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
    JSR     ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange(PC)

    LEA     12(A7),A7

.lab_0934:
    JSR     ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(PC)

    TST.W   D7
    BEQ.S   .lab_0935

    MOVEQ   #1,D0
    MOVE.W  D0,BANNER_ResetPendingFlag

.lab_0935:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0937

    MOVEQ   #39,D1
    CMP.W   D1,D0
    BCC.S   .lab_0937

    MOVE.W  WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,_TEXTDISP_PrimaryGroupCode
    MOVE.W  CLOCK_CacheDayIndex0,D0
    MOVEQ   #31,D3
    CMP.W   D3,D0
    BNE.S   .lab_0936

    MOVE.W  CLOCK_CacheMonthIndex0,D0
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
    MOVE.W  WDISP_BannerSlotCursor,D1
    EXT.L   D1
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D1
    MOVE.B  D1,_TEXTDISP_SecondaryGroupCode
    MOVE.W  WDISP_BannerSlotCursor,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0939

    MOVE.W  CLOCK_CacheYear,D0
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
    MOVE.W  WDISP_BannerSlotCursor,D0
    EXT.L   D0
    SUBQ.L  #1,D0
    AND.L   D2,D0
    MOVE.B  D0,_TEXTDISP_PrimaryGroupCode

.lab_093A:
    MOVE.W  _DST_PrimaryCountdown,D0
    MOVE.W  ESQDISP_LastPrimaryCountdownValue,D1
    CMP.W   D0,D1
    BEQ.S   .lab_093C

    MOVE.W  D0,ESQDISP_LastPrimaryCountdownValue
    SUBQ.W  #1,D0
    BNE.S   .lab_093C

    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #3,D0
    BNE.S   .lab_093B

    MOVEQ   #0,D0
    MOVE.W  D0,ESQDISP_SecondaryPersistArmGateFlag
    BRA.S   .lab_093C

.lab_093B:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #46,D1
    CMP.W   D1,D0
    BNE.S   .lab_093C

    CLR.W   ESQDISP_SecondaryPropagationDoneFlag

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
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

    LEA     WDISP_StatusDayEntry0,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    TST.L   16(A1)
    BNE.S   .lab_093E

    MOVE.W  CLOCK_CurrentDayOfYear,D1
    EXT.L   D1
    ADD.L   D6,D1
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    CMP.L   (A1),D1
    BEQ.S   .lab_093F

.lab_093E:
    MOVE.W  CLOCK_CurrentDayOfYear,D0
    EXT.L   D0
    ADD.L   D6,D0
    MOVE.L  D0,24(A7)
    MOVE.L  D6,D0
    MOVEQ   #20,D1
    JSR     ESQIFF_JMPTBL_MATH_Mulu32(PC)

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

    LEA     WDISP_StatusDayEntry1,A0
    MOVEA.L A0,A1
    LEA     WDISP_StatusDayEntry0,A2
    MOVEQ   #4,D0

.lab_0942:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0942
    LEA     WDISP_StatusDayEntry2,A0
    MOVEA.L A0,A1
    LEA     WDISP_StatusDayEntry1,A2
    MOVEQ   #4,D0

.lab_0943:
    MOVE.L  (A1)+,(A2)+
    DBF     D0,.lab_0943
    LEA     WDISP_StatusDayEntry3,A0
    LEA     WDISP_StatusDayEntry2,A1
    MOVEQ   #4,D0

.lab_0944:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.lab_0944
    MOVEQ   #1,D0
    MOVE.L  D0,TLIBA1_StatusBannerPropagateGuard

.lab_0945:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    SUBQ.W  #1,D0
    BNE.S   .lab_0946

    MOVEQ   #0,D0
    MOVE.W  D0,ESQDISP_SecondaryPersistArmGateFlag

.lab_0946:
    MOVE.W  _CLOCK_HalfHourSlotIndex,D0
    MOVEQ   #2,D1
    CMP.W   D1,D0
    BCS.S   .lab_0947

    TST.W   ESQDISP_SecondaryPersistArmGateFlag
    BNE.S   .lab_0947

    MOVEQ   #1,D1
    MOVE.L  D1,ESQDISP_SecondaryPersistRequestFlag
    MOVE.W  #1,ESQDISP_SecondaryPersistArmGateFlag

.lab_0947:
    MOVEQ   #44,D1
    CMP.W   D1,D0
    BNE.S   .lab_0948

    MOVEQ   #0,D1
    MOVE.W  D1,ESQDISP_SecondaryPropagationDoneFlag

.lab_0948:
    MOVEQ   #45,D1
    CMP.W   D1,D0
    BCS.S   ESQDISP_DrawStatusBanner_Impl_Return

    TST.W   ESQDISP_SecondaryPropagationDoneFlag
    BNE.S   ESQDISP_DrawStatusBanner_Impl_Return

    BSR.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary

    JSR     ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup(PC)

    JSR     ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList(PC)

    MOVE.W  #1,ESQDISP_SecondaryPropagationDoneFlag

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

;------------------------------------------------------------------------------
; FUNC: ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty   (Mirror primary entries into secondary group when empty)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   ESQDISP_FillProgramInfoHeaderFields, ESQSHARED_CreateGroupEntryAndTitle
; READS:
;   _TEXTDISP_SecondaryGroupCode, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, TEXTDISP_SecondaryEntryPtrTablePreSlot, ff7f
; WRITES:
;   ESQDISP_PrimarySecondaryMirrorFlag
; DESC:
;   If secondary group has no entries, clones each primary entry into a newly created
;   secondary entry/title record and copies the per-slot program-info header fields.
;   Sets a flag when mirroring was performed, clears it when secondary was already populated.
; NOTES:
;   Loop walks primary indices from 0 to (PrimaryGroupEntryCount-1).
;------------------------------------------------------------------------------
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty:
    LINK.W  A5,#-12
    MOVEM.L D2-D3/D7/A2-A3/A6,-(A7)
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    BNE.W   .mark_no_mirror_needed

    MOVEQ   #0,D7

.loop_primary_entries_for_mirror:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   .set_mirror_performed_flag

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D0
    MOVEQ   #0,D1
    MOVEA.L -4(A5),A0
    MOVE.B  27(A0),D1
    LEA     12(A0),A1
    LEA     1(A0),A2
    LEA     28(A0),A3
    LEA     19(A0),A6
    MOVE.L  A6,-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     ESQSHARED_CreateGroupEntryAndTitle(PC)

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     TEXTDISP_SecondaryEntryPtrTablePreSlot,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  40(A0),D0
    ANDI.W  #$ff7f,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.W  46(A0),D0
    MOVEQ   #0,D2
    MOVE.B  41(A0),D2
    MOVEQ   #0,D3
    MOVE.B  42(A0),D3
    LEA     43(A0),A2
    MOVE.L  A2,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A1,-8(A5)
    BSR.W   ESQDISP_FillProgramInfoHeaderFields

    LEA     44(A7),A7
    ADDQ.L  #1,D7
    BRA.W   .loop_primary_entries_for_mirror

.set_mirror_performed_flag:
    MOVE.W  #1,ESQDISP_PrimarySecondaryMirrorFlag
    BRA.S   ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return

.mark_no_mirror_needed:
    CLR.W   ESQDISP_PrimarySecondaryMirrorFlag

;------------------------------------------------------------------------------
; FUNC: ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return   (Return tail for secondary mirror helper)
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
;   Restores saved registers and returns from secondary-mirror helper.
; NOTES:
;   Shared return tail for both "mirrored" and "already populated" paths.
;------------------------------------------------------------------------------
ESQDISP_MirrorPrimaryEntriesToSecondaryIfEmpty_Return:
    MOVEM.L (A7)+,D2-D3/D7/A2-A3/A6
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PropagatePrimaryTitleMetadataToSecondary   (Propagate primary title metadata to matching secondary entries)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   ESQSHARED_JMPTBL_ESQ_TestBit1Based, _ESQSHARED_JMPTBL_ESQ_WildcardMatch, _ESQPARS_ReplaceOwnedString
; READS:
;   _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _TEXTDISP_PrimaryTitlePtrTable, _TEXTDISP_SecondaryTitlePtrTable
; WRITES:
;   (none observed)
; DESC:
;   For each secondary entry lacking an owned title string and with the slot bit clear,
;   finds wildcard-matching primary titles and copies slot metadata/string ownership from
;   primary to secondary. Marks secondary title/entry flags when propagation succeeds.
; NOTES:
;   Slot scan is descending and bounded by entry class (0..47 or 44..47 window).
;------------------------------------------------------------------------------
ESQDISP_PropagatePrimaryTitleMetadataToSecondary:
    LINK.W  A5,#-40
    MOVEM.L D2-D7/A2-A3/A6,-(A7)
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.W   D1,D0
    BLS.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVEQ   #0,D7

.loop_secondary_entries:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D7
    BGE.W   ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    TST.L   60(A1)
    BNE.W   .next_secondary_entry

    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     28(A1),A0
    PEA     1.W
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_secondary_entry

    MOVEQ   #0,D4
    MOVEQ   #0,D6

.loop_primary_candidates:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.W   .next_secondary_entry

    TST.L   D4
    BNE.W   .next_secondary_entry

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    MOVE.L  A2,-(A7)
    MOVE.L  A1,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.W   .next_primary_candidate

    MOVEQ   #48,D5
    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    BTST    #5,Struct_PrimaryEntry__EditorFlagsByte(A1)
    BEQ.S   .set_slot_scan_floor_low

    MOVEQ   #0,D0
    BRA.S   .store_slot_scan_floor

.set_slot_scan_floor_low:
    MOVEQ   #44,D0

.store_slot_scan_floor:
    MOVE.L  D0,-20(A5)

.loop_slots_descending:
    CMP.L   -20(A5),D5
    BLE.W   .next_primary_candidate

    TST.L   D4
    BNE.W   .next_primary_candidate

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    LEA     Struct_PrimaryEntry__SelectionBitsetBase(A1),A0
    MOVE.L  D5,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQSHARED_JMPTBL_ESQ_TestBit1Based(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.W   .next_slot_descending

    MOVE.L  D6,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D5,D1
    ASL.L   #2,D1
    ADDA.L  D1,A2
    TST.L   Struct_TitleAuxRecord__SelectorTextPtrBase(A2)
    BEQ.W   .next_slot_descending

    MOVE.L  D7,D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A1
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVEQ   #0,D3
    MOVE.B  Struct_TitleAuxRecord__SelectorFlagsByteBase(A6),D3
    ORI.W   #$80,D3
    MOVE.B  D3,8(A3)
    MOVEA.L A1,A2
    ADDA.L  D2,A2
    MOVEA.L (A2),A3
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A2
    ADDA.L  D2,A1
    MOVEA.L (A1),A0
    MOVE.L  Struct_TitleAuxRecord__OwnedStringPtr(A0),-(A7)      ; dst owned-string slot (secondary title record)
    MOVE.L  Struct_TitleAuxRecord__SelectorTextPtrBase(A2),-(A7) ; src selector text pointer slot (+56 + selector*4)
    MOVE.L  A3,60(A7)
    JSR     _ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVEA.L 52(A7),A0
    MOVE.L  D0,Struct_TitleAuxRecord__OwnedStringPtr(A0)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryTitlePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEA.L (A1),A2
    MOVE.L  D6,D1
    ASL.L   #2,D1
    LEA     _TEXTDISP_PrimaryTitlePtrTable,A1
    MOVEA.L A1,A3
    ADDA.L  D1,A3
    MOVEA.L (A3),A6
    ADDA.L  D5,A6
    MOVE.B  252(A6),253(A2)
    MOVEA.L A0,A2
    ADDA.L  D0,A2
    MOVEA.L (A2),A3
    MOVEA.L A1,A2
    ADDA.L  D1,A2
    MOVEA.L (A2),A6
    ADDA.L  D5,A6
    MOVE.B  301(A6),302(A3)
    ADDA.L  D0,A0
    MOVEA.L (A0),A2
    ADDA.L  D1,A1
    MOVEA.L (A1),A0
    ADDA.L  D5,A0
    MOVE.B  350(A0),351(A2)
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEQ   #0,D0
    MOVE.B  40(A1),D0
    MOVE.L  D0,D1
    ORI.W   #$80,D1
    MOVE.B  D1,40(A1)
    MOVEQ   #1,D4

.next_slot_descending:
    SUBQ.L  #1,D5
    BRA.W   .loop_slots_descending

.next_primary_candidate:
    ADDQ.L  #1,D6
    BRA.W   .loop_primary_candidates

.next_secondary_entry:
    ADDQ.L  #1,D7
    BRA.W   .loop_secondary_entries

;------------------------------------------------------------------------------
; FUNC: ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return   (Return tail for title-metadata propagation)
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
;   Restores saved registers and returns from title-metadata propagation helper.
; NOTES:
;   Early exits branch here when primary/secondary counts are zero.
;------------------------------------------------------------------------------
ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return:
    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======