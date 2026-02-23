; ========== ESQ.c ==========

Global_REF_GRAPHICS_LIBRARY:
    DC.L    0
Global_REF_INTUITION_LIBRARY:
    DC.L    0
Global_REF_UTILITY_LIBRARY:
    DC.L    0
Global_REF_BATTCLOCK_RESOURCE:
    DC.L    0

Global_STR_PREVUEC_FONT:
    NStr    "PrevueC.font"          ; 14 bytes
Global_STRUCT_TEXTATTR_PREVUEC_FONT:
    DC.L    Global_STR_PREVUEC_FONT
    DC.W    25      ; Size 25 font
    DC.B    $40     ; Style
    DC.B    $20     ; Flags

Global_STR_H26F_FONT:
    NStr    "h26f.font"             ; 10 bytes
Global_STRUCT_TEXTATTR_H26F_FONT:
    DC.L    Global_STR_H26F_FONT
    DC.W    26      ; Size 26 font
    DC.B    0       ; Style: 0
    DC.B    0       ; Flags: 0

Global_STR_TOPAZ_FONT:
    NStr    "topaz.font"            ; 12 bytes
Global_STRUCT_TEXTATTR_TOPAZ_FONT:
    DC.L    Global_STR_TOPAZ_FONT
    DC.W    8      ; Size 8 font
    DC.B    0      ; Style: 0
    DC.B    1      ; Flags: 1

Global_STR_PREVUE_FONT:
    NStr    "Prevue.font"           ; 12 bytes
Global_STRUCT_TEXTATTR_PREVUE_FONT:
    DC.L    Global_STR_PREVUE_FONT
    DC.W    13      ; Size 13 font
    DC.B    $40     ; Style
    DC.B    $20     ; Flags

Global_HANDLE_PREVUE_FONT:
    DC.L    0
Global_REF_DISKFONT_LIBRARY:
    DC.L    0
Global_REF_DOS_LIBRARY:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: ESQ_HighlightMsgPort/ESQ_HighlightReplyPort   (highlight message ports)
; TYPE: pointer/pointer (Exec MsgPort)
; PURPOSE: Main message port for highlight work messages and paired reply port.
; USED BY: ESQ init/cleanup, ESQDISP message submit, GCOMMAND message service, NEWGRID polling
; NOTES: Allocated as MsgPort-sized blocks during ESQ startup.
;------------------------------------------------------------------------------
ESQ_HighlightMsgPort:
    DC.L    0
ESQ_HighlightReplyPort:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: ESQ_ProcessWindowPtrBackup   (startup/restored process window pointer)
; TYPE: pointer
; PURPOSE: Saves current process `pr_WindowPtr` before ESQ sets it to `-1`.
; USED BY: ESQ startup task init, CLEANUP shutdown restore
; NOTES: Restored only when non-null.
;------------------------------------------------------------------------------
ESQ_ProcessWindowPtrBackup:
    DC.L    0
ED_DiagVinModeChar_Length = 1

ESQ_STR_B:
    DC.B    "B"
ESQ_STR_B_Length = ESQ_STR_E-ESQ_STR_B

ESQ_STR_E:
    DC.B    "E"
ESQ_STR_E_Length = ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED-ESQ_STR_E

ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED:
    DC.B    "3"
ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_Length = ESQ_TAG_36-ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED

ESQ_TAG_36:
    DC.B    "36"
ESQ_TAG_36_Length = ED_DiagScrollSpeedChar-ESQ_TAG_36

;------------------------------------------------------------------------------
; SYM: ED_DiagScrollSpeedChar   (diagnostic SSPD selector char)
; TYPE: u8 (ASCII digit)
; PURPOSE: Single-character diagnostic scroll-speed selector shown in ED diagnostics.
; USED BY: ED_DrawDiagnosticModeText, ED2 diagnostic menu speed cycling, ESQIFF2 diagnostics
; NOTES: Default is `'6'`; ED2 cycles this value and mirrors it into related counters.
;------------------------------------------------------------------------------
ED_DiagScrollSpeedChar:
    DC.B    "6"
ED_DiagScrollSpeedChar_Length = ESQ_DefaultNoFlagChar-ED_DiagScrollSpeedChar

ESQ_DefaultNoFlagChar:
    DC.B    "N"
;------------------------------------------------------------------------------
; SYM: CLOCK_MinuteEventBaseMinute/CLOCK_MinuteEventBaseOffset   (minute trigger seeds)
; TYPE: u8/u8
; PURPOSE: Base values passed into ESQ_SeedMinuteEventThresholds.
; USED BY: ESQIFF2_ApplyIncomingStatusPacket
; NOTES: Clamped to the 1..9 range before use.
;------------------------------------------------------------------------------
CLOCK_MinuteEventBaseMinute:
    DC.B    1
CLOCK_MinuteEventBaseOffset:
    DC.B    1
ESQ_STR_6:
    DC.B    "6"
ESQ_STR_6_Length = ESQ_SecondarySlotModeFlagChar-ESQ_STR_6

ESQ_SecondarySlotModeFlagChar:
    DC.B    "N"
ESQ_SecondarySlotModeFlagChar_Length = ESQ_STR_Y-ESQ_SecondarySlotModeFlagChar

ESQ_STR_Y:
    DC.B    "Y"
ESQ_STR_Y_Length = ESQ_ReservedFlagChar0-ESQ_STR_Y
ESQ_ReservedFlagChar0:
    DC.B    "N"
ESQ_AlertType4ModeFlagChar:
    DC.B    "N"
ESQ_AlertType235ModeFlagChar:
    DC.B    "N"
    DC.B    "YA"
;------------------------------------------------------------------------------
; SYM: ED_DiagGraphModeChar/ED_DiagVinModeChar   (diagnostic GRPH/VIN selector chars)
; TYPE: u8/u8 (ASCII)
; PURPOSE: Current single-char selectors shown in ED diagnostics for GRPH and VIN columns.
; USED BY: ED_DrawDiagnosticModeText, ED2 diagnostic menu action cycling, SCRIPT3_/ESQIFF2_/ESQFUNC_ flows
; NOTES: Values are cycled through fixed option tables by ED diagnostics handlers.
;------------------------------------------------------------------------------
ED_DiagGraphModeChar:
    DC.B    "N"
ED_DiagGraphModeChar_Length = ED_DiagVinModeChar-ED_DiagGraphModeChar
ED_DiagVinModeChar:
    DC.B    "N"
;------------------------------------------------------------------------------
; SYM: CLOCK_FormatVariantCode   (clock format variant code)
; TYPE: u8
; PURPOSE: Selects variant for clock/time text formatting.
; USED BY: TEXTDISP3_*, NEWGRID_*, CLEANUP2_*, DST2_*
; NOTES: Consumed by routines that format hour/minute display variants.
;------------------------------------------------------------------------------
CLOCK_FormatVariantCode:
    DC.B    0
ESQ_TopazGuardRastPortAnchor:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: WDISP_WeatherStatusTextPtr   (weather/status text pointer)
; TYPE: pointer
; PURPOSE: Optional pointer to dynamic weather/status text for display/export.
; USED BY: WDISP_*, DISKIO2_*, CLEANUP_*, UNKNOWN_*
; NOTES: Null when no status text is available.
;------------------------------------------------------------------------------
WDISP_WeatherStatusTextPtr:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_AliasCount   (alias table entry count)
; TYPE: u16
; PURPOSE: Number of active alias-table entries.
; USED BY: TEXTDISP_FindAliasIndexByName, PARSEINI_*, DISKIO2_*, ESQPARS_*
; NOTES: Used as loop bound for alias-pointer table scans.
;------------------------------------------------------------------------------
TEXTDISP_AliasCount:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: ESQIFF_PrimaryLineHeadPtr   (primary line head text pointer)
; TYPE: pointer
; PURPOSE: First segment pointer for primary ESQIFF line text.
; USED BY: ESQIFF2_*, DISKIO2_*, CLEANUP3_*, ESQDISP_*
; NOTES: Paired with ESQIFF_PrimaryLineTailPtr.
;------------------------------------------------------------------------------
ESQIFF_PrimaryLineHeadPtr:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: ESQIFF_PrimaryLineTailPtr   (primary line tail text pointer)
; TYPE: pointer
; PURPOSE: Second segment pointer for primary ESQIFF line text.
; USED BY: ESQIFF2_*, DISKIO2_*, CLEANUP3_*, ESQDISP_*
; NOTES: Paired with ESQIFF_PrimaryLineHeadPtr.
;------------------------------------------------------------------------------
ESQIFF_PrimaryLineTailPtr:
    DC.L    0
Global_REF_STR_CLOCK_FORMAT:
    DC.L    0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_DeferredActionCountdown   (deferred action countdown)
; TYPE: u16
; PURPOSE: Tick countdown before committing a deferred text/display action.
; USED BY: TEXTDISP_TickDisplayState, SCRIPT3_*, ED2_*, ESQFUNC_*
; NOTES: Decremented each tick while TEXTDISP_DeferredActionArmed is set.
;------------------------------------------------------------------------------
TEXTDISP_DeferredActionCountdown:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_DeferredActionArmed   (deferred action armed flag)
; TYPE: u16
; PURPOSE: Indicates a deferred action countdown is active.
; USED BY: TEXTDISP_TickDisplayState, SCRIPT3_*, APP2_*
; NOTES: Treated as boolean/non-zero guard for countdown handling.
;------------------------------------------------------------------------------
TEXTDISP_DeferredActionArmed:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PresetFallbackValue0..GCOMMAND_PresetFallbackValue3   (banner preset fallback nibble values)
; TYPE: u8/u8/u8/u8
; PURPOSE: Per-lane fallback values used when preset work entries are negative.
; USED BY: GCOMMAND_RebuildBannerTablesFromBounds, ED diagnostic nibble editor/drawer
; NOTES: Followed by packed template bytes consumed by nearby table-style logic.
;------------------------------------------------------------------------------
GCOMMAND_PresetFallbackValue0:
    DC.B    0
GCOMMAND_PresetFallbackValue1:
    DC.B    0
GCOMMAND_PresetFallbackValue2:
    DC.B    $03
GCOMMAND_PresetFallbackValue3:
    ; First byte doubles as fallback value #3 for banner rebuild.
    DC.B    $0c
GCOMMAND_PresetFallbackTemplateTable:
    DC.L    $0c0c0000,$000c0c00,$05010201,$060a0505
    DC.L    $05000003,$00080007,$00070007,$07000c00
    DC.L    $0c000c00,$0c0c0c00,$0000000c
;------------------------------------------------------------------------------
; SYM: ESQ_ShutdownRequestedFlag/ESQ_MainLoopUiTickEnabledFlag   (main-loop runtime gates)
; TYPE: u16/u16
; PURPOSE: Shutdown request latch and UI-tick enable gate for the main loop.
; USED BY: ESQ_MainInitAndRun, ESQFUNC_ServiceUiTickIfRunning, ED menu handlers
; NOTES: Shutdown flag exits the main idle loop when non-zero.
;------------------------------------------------------------------------------
ESQ_ShutdownRequestedFlag:
    DC.W    0
ESQ_MainLoopUiTickEnabledFlag:
    DC.W    0
Global_HANDLE_PREVUEC_FONT:
    DC.L    0
Global_HANDLE_H26F_FONT:
    DC.L    0
Global_HANDLE_TOPAZ_FONT:
    DC.L    0,0,0
    DC.W    0
;------------------------------------------------------------------------------
; SYM: ESQIFF_SecondaryLineHeadPtr   (secondary line head text pointer)
; TYPE: pointer (stored as two words)
; PURPOSE: First segment pointer for secondary ESQIFF line text.
; USED BY: ESQIFF2_*, ESQDISP_*
; NOTES: Declared as two words to preserve original layout/alignment.
;------------------------------------------------------------------------------
ESQIFF_SecondaryLineHeadPtr:
    DC.W    0
ESQIFF_SecondaryLineHeadPtr_HiWord:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: ESQIFF_SecondaryLineTailPtr   (secondary line tail text pointer)
; TYPE: pointer
; PURPOSE: Second segment pointer for secondary ESQIFF line text.
; USED BY: ESQIFF2_*, ESQDISP_*
; NOTES: Paired with ESQIFF_SecondaryLineHeadPtr.
;------------------------------------------------------------------------------
ESQIFF_SecondaryLineTailPtr:
    DC.L    0
ESQ_STR_A:
    NStr    "A"
;------------------------------------------------------------------------------
; SYM: WDISP_WeatherStatusOverlayTextPtr   (weather overlay text pointer)
; TYPE: pointer
; PURPOSE: Dynamic text pointer used by weather/status overlay formatting paths.
; USED BY: UNKNOWN_ParseRecordAndUpdateDisplay, WDISP weather draw paths, ESQIFF helpers
; NOTES: Updated through ESQPARS_ReplaceOwnedString-style realloc/copy helper flows.
;------------------------------------------------------------------------------
WDISP_WeatherStatusOverlayTextPtr:
    DC.L    0
Global_LONG_ROM_VERSION_CHECK:
    DC.L    1
;------------------------------------------------------------------------------
; SYM: ESQDISP_StatusIndicatorDeferredApplyFlag   (status-indicator deferred paint gate)
; TYPE: u8
; PURPOSE: Defers indicator repaint and caches color while attention countdown is active.
; USED BY: GCOMMAND_ConsumeBannerQueueEntry, ESQDISP_SetStatusIndicatorColorSlot
; NOTES: Set on queue control byte `0xFF`, cleared when countdown expires.
;------------------------------------------------------------------------------
ESQDISP_StatusIndicatorDeferredApplyFlag:
    DC.B    0
;------------------------------------------------------------------------------
; SYM: CLEANUP_DiagOverlayAutoRefreshFlag   (diagnostic overlay auto-refresh enable)
; TYPE: u8
; PURPOSE: Enables periodic diagnostics redraw from alert-processing tick paths.
; USED BY: ED2 diagnostic menu action, CLEANUP_ProcessAlerts
; NOTES: Toggled by diagnostics menu command.
;------------------------------------------------------------------------------
CLEANUP_DiagOverlayAutoRefreshFlag:
    DC.B    0
;------------------------------------------------------------------------------
; SYM: ED_DiagAvailMemMask   (diagnostics available-memory mask)
; TYPE: u32 (stored in word slot + alignment)
; PURPOSE: Selects which memory classes (chip/fast/max/largest) are displayed on diagnostics screen.
; USED BY: ED2_HandleDiagnosticsMenuActions, ESQFUNC_DrawMemoryStatusScreen
; NOTES: Low three bits are toggled by diagnostics actions.
;------------------------------------------------------------------------------
ED_DiagAvailMemMask:
    DC.W    0
    DC.B    0
;------------------------------------------------------------------------------
; SYM: ED_DiagAvailMemPresetBits   (diagnostics memory-view preset selector bits)
; TYPE: u8 (bitfield)
; PURPOSE: Stores menu-selected preset bits for diagnostics memory display mode.
; USED BY: ED2 diagnostics menu handlers
; NOTES: Bits 0..2 are set by dedicated menu cases.
;------------------------------------------------------------------------------
ED_DiagAvailMemPresetBits:
    DC.B    0
;------------------------------------------------------------------------------
; SYM: ESQDISP_GridMessagePumpBlockFlag/SCRIPT_StatusRefreshHoldFlag/TEXTDISP_TickSuspendFlag/ESQPARS_PersistOnNextBoxOffFlag
; TYPE: u16/u16/u16/u16
; PURPOSE: Misc runtime gates for grid message pump, script refresh hold, text tick suspend, and deferred boxoff persist.
; USED BY: ESQDISP_ProcessGridMessagesIfIdle, SCRIPT_UpdateCtrlStateMachine, TEXTDISP_TickDisplayState, ESQPARS command parser
; NOTES: `ESQPARS_PersistOnNextBoxOffFlag` is set by `%` command and consumed by boxoff path.
;------------------------------------------------------------------------------
ESQDISP_GridMessagePumpBlockFlag:
    DC.W    0
SCRIPT_StatusRefreshHoldFlag:
    DC.W    0
TEXTDISP_TickSuspendFlag:
    DC.W    0
Global_WORD_SELECT_CODE_IS_RAVESC:
    DC.W    0
ESQPARS_PersistOnNextBoxOffFlag:
    DC.W    0
HAS_REQUESTED_FAST_MEMORY:
    DC.W    0
IS_COMPATIBLE_VIDEO_CHIP:
    DC.L    1
Global_STR_RAVESC:
    NStr    "RAVESC"
Global_STR_COPY_NIL_ASSIGN_RAM:
    NStr    "copy >NIL: C:assign ram:"
Global_STR_GRAPHICS_LIBRARY:
    NStr    "graphics.library"
Global_STR_DISKFONT_LIBRARY:
    NStr    "diskfont.library"
Global_STR_DOS_LIBRARY:
    NStr    "dos.library"
Global_STR_INTUITION_LIBRARY:
    NStr    "intuition.library"
Global_STR_UTILITY_LIBRARY:
    NStr    "utility.library"
Global_STR_BATTCLOCK_RESOURCE:
    NStr    "battclock.resource"
Global_STR_ESQ_C_1:
    NStr    "ESQ.c"
Global_STR_ESQ_C_2:
    NStr    "ESQ.c"
Global_STR_ESQ_C_3:
    NStr    "ESQ.c"
Global_STR_ESQ_C_4:
    NStr    "ESQ.c"
Global_STR_ESQ_C_5:
    NStr    "ESQ.c"
Global_STR_CART:
    NStr    "CART"
Global_STR_ESQ_C_6:
    NStr    "ESQ.c"
Global_STR_SERIAL_READ:
    NStr    "Serial.Read"
Global_STR_SERIAL_DEVICE:
    NStr    "serial.device"
Global_STR_ESQ_C_7:
    NStr    "ESQ.c"
Global_STR_ESQ_C_8:
    NStr    "ESQ.c"
Global_STR_ESQ_C_9:
    NStr    "ESQ.c"
Global_STR_ESQ_C_10:
    NStr    "ESQ.c"
Global_STR_ESQ_C_11:
    NStr    "ESQ.c"
ESQ_STR_NO_DF1_PRESENT:
    NStr    "no df1 present"
Global_STR_GUIDE_START_VERSION_AND_BUILD:
    NStr    "Ver %s.%ld Build %s"
Global_STR_MAJOR_MINOR_VERSION:
    NStr    "10.0"   ; Major/minor version string
ESQ_STR_38_Spaces:
    NStr    "                                       "
Global_STR_DF0_GRADIENT_INI_2:
    NStr    "df0:Gradient.ini"
ESQ_STR_CommunityPatchEdition:
    NStr    "Community Patch Edition"
ESQ_STR_SystemInitializing:
    NStr    "System Initializing"
ESQ_STR_PleaseStandByEllipsis:
    NStr    "Please Stand By..."
ESQ_STR_AttentionSystemEngineer:
    NStr    "ATTENTION SYSTEM ENGINEER!"
ESQ_STR_ReportErrorCodeEr011ToTVGuide:
    NStr    "Report Error Code ER011 to TV Guide Technical Services."
ESQ_STR_ReportErrorCodeER012ToTVGuide:
    NStr    "Report Error Code ER012 to TV Guide Technical Services."
Global_STR_DF0_DEFAULT_INI_1:
    NStr    "df0:default.ini"
Global_STR_DF0_BRUSH_INI_1:
    NStr    "df0:brush.ini"
ESQ_STR_DT:
    NStr    "DT"
ESQ_STR_DITHER:
    NStr    "DITHER"
Global_STR_DF0_BANNER_INI_1:
    NStr    "df0:banner.ini"
ESQ_TAG_GRANADA:
    NStr    "GRANADA"
Global_STR_GitCommitHash:
    NStr    "675c407"
;------------------------------------------------------------------------------
; SYM: ESQ_CopperEffectListA/ESQ_CopperEffectListB   (paired copper effect lists)
; TYPE: u32[]/u32[]
; PURPOSE: Paired copperlists used for effect/status-band rendering and selected by VPOSR field state.
; USED BY: ESQ_UpdateCopperListsFromParams, ESQSHARED4_ProgramDisplayWindowAndCopper, ESQSHARED4_TickCopperAndBannerTransitions
; NOTES:
;   ESQ_UpdateCopperListsFromParams writes synchronized effect words into both lists.
;   Selector polarity differs across some call paths; keep neutral A/B naming.
;------------------------------------------------------------------------------
ESQ_CopperEffectListA:
    DC.L    $055bfffe,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$065bfffe,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $03d9fffe
    DC.W    $0080
ESQ_CopperEffectListB_PtrHiWord:
    DC.L    $00000082
ESQ_CopperEffectListB_PtrLoWord:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: ESQ_CopperEffectTemplateRowsSet0   (copper effect list B body template ??)
; TYPE: u32[] + tail word
; PURPOSE: Backing storage for effect-list B command payload words.
; USED BY: ESQSHARED4 banner/copper setup and update paths
; NOTES:
;   Pointer high/low words above are rebound at runtime; per-entry color/wait
;   semantics in this block are not fully resolved yet.
;------------------------------------------------------------------------------
ESQ_CopperEffectTemplateRowsSet0:
    DS.L    19
    DC.W    $0180
;------------------------------------------------------------------------------
; SYM: ESQ_CopperStatusDigitsA   (copper status digit list A)
; TYPE: u32[]
; PURPOSE: Base copperlist words for status-digit rendering set A.
; USED BY: APP2_*, ESQFUNC_*, ESQSHARED4_*
; NOTES: Paired with ESQ_CopperStatusDigitsB.
;------------------------------------------------------------------------------
ESQ_CopperStatusDigitsA:
    DC.L    $00030182
ESQ_CopperStatusDigitsA_ColorRegistersA:
    DC.L    $0aaa0184,$03330186,$05550188,$0512018a
    DC.L    $016a018c,$0cc0018e
ESQ_CopperStatusDigitsA_ColorRegistersB:
    DC.L    $00030190,$00030192,$00030194,$00030196
    DC.L    $00030198,$0003019a,$0003019c,$0003019e
ESQ_CopperStatusDigitsA_ColorRegistersC:
    DC.L    $000301a0,$000301a2,$000301a4,$000301a6
    DC.L    $000301a8,$000301aa,$000301ac,$000301ae
    DC.L    $000301b0,$000301b2,$000301b4,$000301b6
    DC.L    $000301b8,$000301ba,$000301bc,$000301be
ESQ_CopperStatusDigitsA_TailColorWord:
    DC.W    $0003
;------------------------------------------------------------------------------
; SYM: ESQ_CopperListBannerA   (banner copper list A)
; TYPE: u32[]
; PURPOSE: Copper command template for banner/digital overlay variant A.
; USED BY: GCOMMAND3_*, APP2_*, ESQSHARED4_*
; NOTES: Contains register/value words plus wait terminator.
;------------------------------------------------------------------------------
ESQ_CopperListBannerA:
    DC.L    $00d9fffe,$00920030,$009400d8,$008e1769
    DC.L    $0090ffc5,$01080058,$010a0058,$01009306
    DC.L    $01020000,$01820003
    DC.W    $00e0
ESQ_BannerWorkRasterPtrA_HiWord:
    DC.L    $000000e2
ESQ_BannerWorkRasterPtrA_LoWord:
    DC.L    $00000180
ESQ_BannerPaletteWordsA:
    DC.L    $00030182,$00030184,$03330186,$0cc00188
    DC.L    $0512018a,$016a018c,$0555018e
    DC.W    $0003
ESQ_BannerSweepWaitRowA:
    DC.L    $00dffffe
    DC.W    $00e0
ESQ_BannerPlane0SnapshotScratchPtrHiWord:
    DC.L    $000000e2
ESQ_BannerPlane0SnapshotScratchPtrLoWord:
    DC.L    $000000e4
ESQ_BannerPlane1SnapshotScratchPtrHiWord:
    DC.L    $000000e6
ESQ_BannerPlane1SnapshotScratchPtrLoWord:
    DC.L    $000000e8
ESQ_BannerPlane2SnapshotScratchPtrHiWord:
    DC.L    $000000ea
ESQ_BannerPlane2SnapshotScratchPtrLoWord:
    DC.L    $00000182
;------------------------------------------------------------------------------
; SYM: ESQ_BannerColorSweepProgramA..ESQ_CopperEffectSwitchWaitWordA   (banner copper color-sweep cluster A ??)
; TYPE: u32/u16 mixed command templates
; PURPOSE: Runtime-patched copper command words used by banner color sweep (A path).
; USED BY: ESQSHARED4_InitializeBannerCopperSystem, ESQSHARED4_ApplyBannerColorStep
; NOTES:
;   Includes wait rows, color register writes, and pointer-word placeholders.
;   Individual entries remain intentionally anonymous until per-word behavior is
;   confirmed from deeper trace work.
;------------------------------------------------------------------------------
ESQ_BannerColorSweepProgramA:
    DC.L    $0aaa0100,$b30680d5,$80fe0188,$0100018a
    DC.L    $0000018c,$0000018e,$000180d5,$80fe0188
    DC.L    $0200018a,$0011018c,$0111018e,$000280d5
    DC.L    $80fe0188,$0300018a,$0022018c,$0222018e
    DC.L    $000380d5,$80fe0188,$0400018a,$0033018c
    DC.L    $0333018e,$000480d5,$80fe0188,$0500018a
    DC.L    $0044018c,$0444018e,$000580d5,$80fe0188
    DC.L    $0600018a,$0055018c,$0555018e,$000680d5
    DC.L    $80fe0188,$0700018a,$0066018c,$0666018e
    DC.L    $000780d5,$80fe0188,$0800018a,$0077018c
    DC.L    $0777018e,$000880d5,$80fe0188,$0900018a
    DC.L    $0088018c,$0888018e,$000980d5,$80fe0188
    DC.L    $0a00018a,$0099018c,$0999018e,$000a00d5
    DC.L    $80fe0188,$0b00018a,$00aa018c,$0aaa018e
    DC.L    $000b80d5,$80fe0188,$0c00018a,$00bb018c
    DC.L    $0bbb018e,$000c80d5,$80fe0188,$0d00018a
    DC.L    $00cc018c,$0ccc018e,$000d80d5,$80fe0188
    DC.L    $0e00018a,$00dd018c,$0ddd018e,$000e80d5
    DC.L    $80fe0188,$0f00018a,$00ee018c,$0eee018e
    DC.L    $000f80d5,$80fe0188,$0512018a,$016a018c
    DC.L    $0555018e
    DC.W    $0003
ESQ_BannerSweepWaitStartProgramA:
    DC.L    $00d9fffe,$01009306,$01820003
    DC.W    $00e0
ESQ_BannerWorkRasterPtrMirrorA_HiWord:
    DC.L    $000000e2
ESQ_BannerWorkRasterPtrMirrorA_LoWord:
    DC.W    0
ESQ_BannerSweepWaitEndProgramA:
    DC.L    $00dffffe
    DC.W    $00e0
ESQ_BannerSnapshotPlane0DstPtrHiWord:
    DC.L    $000000e2
ESQ_BannerSnapshotPlane0DstPtrLoWord:
    DC.L    $000000e4
ESQ_BannerSnapshotPlane1DstPtrHiWord:
    DC.L    $000000e6
ESQ_BannerSnapshotPlane1DstPtrLoWord:
    DC.L    $000000e8
ESQ_BannerSnapshotPlane2DstPtrHiWord:
    DC.L    $000000ea
ESQ_BannerSnapshotPlane2DstPtrLoWord:
    DC.L    $00000100,$b3060084
ESQ_CopperEffectJumpTargetA_HiWord:
    DC.L    $00000086
ESQ_CopperEffectJumpTargetA_LoWord:
    DC.L    $00000182
ESQ_BannerColorSweepProgramA_AnchorColorWord:
    DC.L    $0aaa018e
ESQ_BannerColorSweepProgramA_TailColorWord:
    DC.W    $0003
ESQ_BannerColorClampValueA:
    DC.B    0
ESQ_BannerColorClampWaitRowA:
    DC.B    $d9
    DC.L    $fffe0180,$00f000e0
ESQ_BannerPlane0DstPtrReset_HiWord:
    DC.L    $000000e2
ESQ_BannerPlane0DstPtrReset_LoWord:
    DC.L    $000000e4
ESQ_BannerPlane1DstPtrReset_HiWord:
    DC.L    $000000e6
ESQ_BannerPlane1DstPtrReset_LoWord:
    DC.L    $000000e8
ESQ_BannerPlane2DstPtrReset_HiWord:
    DC.L    $000000ea
ESQ_BannerPlane2DstPtrReset_LoWord:
    DC.W    0
ESQ_CopperEffectSwitchWaitWordA:
    DC.L    $009c8010
;------------------------------------------------------------------------------
; SYM: ESQ_CopperBannerTailListA/ESQ_CopperBannerTailListB   (banner copper tail lists)
; TYPE: u32[]/u32[]
; PURPOSE: Short tail command lists appended into each banner copper program.
; USED BY: ESQSHARED4_ResetBannerColorSweepState
; NOTES:
;   First byte is patched at runtime to retarget the leading wait row during
;   banner color-sweep reset.
;------------------------------------------------------------------------------
ESQ_CopperBannerTailListA:
    DC.L    $00d9fffe,$0180016a,$01009306,$01820003
    DC.W    $00e0
ESQ_BannerWorkRasterPtrTailA_HiWord:
    DC.L    $000000e2
;------------------------------------------------------------------------------
; SYM: ESQ_CopperBannerRasterPointerListA/ESQ_CopperBannerRasterPointerListB   (banner raster pointer lists)
; TYPE: u32[]/u32[]
; PURPOSE: Copper wait/pointer payload lists whose base pointer words are
;   rebound to the banner work raster.
; USED BY: ESQSHARED4_BindAndClearBannerWorkRaster
; NOTES:
;   Bind step writes the work-raster low/high words into the first long entry.
;------------------------------------------------------------------------------
ESQ_CopperBannerRasterPointerListA:
    DC.L    $0000ffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff
    DC.W    $fffe
ESQ_CopperEffectListB:
    DC.L    $055bfffe,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$065bfffe,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $0100c306,$0100c306,$0100c306,$0100c306
    DC.L    $03d9fffe
    DC.W    $0080
ESQ_CopperEffectListA_PtrHiWord:
    DC.L    $00000082
ESQ_CopperEffectListA_PtrLoWord:
    DC.W    0
;------------------------------------------------------------------------------
; SYM: ESQ_CopperEffectTemplateRowsSet1   (copper effect list A body template ??)
; TYPE: u32[] + tail word
; PURPOSE: Backing storage for effect-list A command payload words.
; USED BY: ESQSHARED4 banner/copper setup and update paths
; NOTES:
;   Mirrors ESQ_CopperEffectTemplateRowsSet0 for the alternate effect list.
;------------------------------------------------------------------------------
ESQ_CopperEffectTemplateRowsSet1:
    DS.L    19
    DC.W    $0180
;------------------------------------------------------------------------------
; SYM: ESQ_CopperStatusDigitsB   (copper status digit list B)
; TYPE: u32[]
; PURPOSE: Alternate status-digit copperlist template.
; USED BY: APP2_*, ESQFUNC_*, ESQSHARED4_*
; NOTES: Mirrors ESQ_CopperStatusDigitsA structure with companion data set.
;------------------------------------------------------------------------------
ESQ_CopperStatusDigitsB:
    DC.L    $00030182
ESQ_CopperStatusDigitsB_ColorRegistersA:
    DC.L    $0aaa0184,$03330186,$05550188,$0512018a
    DC.L    $016a018c,$0cc0018e
ESQ_CopperStatusDigitsB_TailColorWord:
    DC.W    $0003
;------------------------------------------------------------------------------
; SYM: ESQ_CopperListBannerB   (banner copper list B)
; TYPE: u32[]
; PURPOSE: Copper command template for banner/digital overlay variant B.
; USED BY: GCOMMAND3_*, APP2_*, ESQSHARED4_*
; NOTES: Companion to ESQ_CopperListBannerA.
;------------------------------------------------------------------------------
ESQ_CopperListBannerB:
    DC.L    $00d9fffe,$00920030,$009400d8,$008e1769
    DC.L    $0090ffc5,$01080058,$010a0058,$01009306
    DC.L    $01020000,$01820003
    DC.W    $00e0
;------------------------------------------------------------------------------
; SYM: ESQ_BannerWorkRasterPtrB_HiWord..ESQ_BannerWorkRasterPtrTailB_HiWord   (banner copper color-sweep cluster B ??)
; TYPE: u32/u16 mixed command templates
; PURPOSE: Runtime-patched copper command words used by banner color sweep (B path).
; USED BY: ESQSHARED4_InitializeBannerCopperSystem, ESQSHARED4_ApplyBannerColorStep
; NOTES:
;   Companion set to cluster A above; many entries are structural mirrors.
;   Retain anonymous per-entry labels until row/register mapping is fully traced.
;------------------------------------------------------------------------------
ESQ_BannerWorkRasterPtrB_HiWord:
    DC.L    $000000e2
ESQ_BannerWorkRasterPtrB_LoWord:
    DC.L    $00000180
ESQ_BannerPaletteWordsB:
    DC.L    $00030182,$00030184,$03330186,$0cc00188
    DC.L    $0512018a,$016a018c,$0555018e
    DC.W    $0003
ESQ_BannerSweepWaitRowB:
    DC.L    $00dffffe
    DC.W    $00e0
ESQ_BannerPlane0ScratchPtrAlt_HiWord:
    DC.L    $000000e2
ESQ_BannerPlane0ScratchPtrAlt_LoWord:
    DC.L    $000000e4
ESQ_BannerPlane1ScratchPtrAlt_HiWord:
    DC.L    $000000e6
ESQ_BannerPlane1ScratchPtrAlt_LoWord:
    DC.L    $000000e8
ESQ_BannerPlane2ScratchPtrAlt_HiWord:
    DC.L    $000000ea
ESQ_BannerPlane2ScratchPtrAlt_LoWord:
    DC.L    $00000182
ESQ_BannerColorSweepProgramB:
    DC.L    $0aaa018e,$03330100,$b30680d5,$80fe0188
    DC.L    $0100018a,$0000018c,$0000018e,$000180d5
    DC.L    $80fe0188,$0200018a,$0011018c,$0111018e
    DC.L    $000280d5,$80fe0188,$0300018a,$0022018c
    DC.L    $0222018e,$000380d5,$80fe0188,$0400018a
    DC.L    $0033018c,$0333018e,$000480d5,$80fe0188
    DC.L    $0500018a,$0044018c,$0444018e,$000580d5
    DC.L    $80fe0188,$0600018a,$0055018c,$0555018e
    DC.L    $000680d5,$80fe0188,$0700018a,$0066018c
    DC.L    $0666018e,$000780d5,$80fe0188,$0800018a
    DC.L    $0077018c,$0777018e,$000880d5,$80fe0188
    DC.L    $0900018a,$0088018c,$0888018e,$000980d5
    DC.L    $80fe0188,$0a00018a,$0099018c,$0999018e
    DC.L    $000a00d5,$80fe0188,$0b00018a,$00aa018c
    DC.L    $0aaa018e,$000b80d5,$80fe0188,$0c00018a
    DC.L    $00bb018c,$0bbb018e,$000c80d5,$80fe0188
    DC.L    $0d00018a,$00cc018c,$0ccc018e,$000d80d5
    DC.L    $80fe0188,$0e00018a,$00dd018c,$0ddd018e
    DC.L    $000e80d5,$80fe0188,$0f00018a,$00ee018c
    DC.L    $0eee018e,$000f80d5,$80fe0188,$0512018a
    DC.L    $016a018c,$0555018e
    DC.W    $0003
ESQ_BannerSweepWaitStartProgramB:
    DC.L    $00d9fffe,$01009306,$01820003
    DC.W    $00e0
ESQ_BannerWorkRasterPtrMirrorB_HiWord:
    DC.L    $000000e2
ESQ_BannerWorkRasterPtrMirrorB_LoWord:
    DC.W    0
ESQ_BannerSweepWaitEndProgramB:
    DC.L    $00dffffe
    DC.W    $00e0
ESQ_BannerSweepSrcPlane0Ptr_HiWord:
    DC.L    $000000e2
ESQ_BannerSweepSrcPlane0Ptr_LoWord:
    DC.L    $000000e4
ESQ_BannerSweepSrcPlane1Ptr_HiWord:
    DC.L    $000000e6
ESQ_BannerSweepSrcPlane1Ptr_LoWord:
    DC.L    $000000e8
ESQ_BannerSweepSrcPlane2Ptr_HiWord:
    DC.L    $000000ea
ESQ_BannerSweepSrcPlane2Ptr_LoWord:
    DC.L    $00000100,$b3060084
ESQ_CopperEffectJumpTargetB_HiWord:
    DC.L    $00000086
ESQ_CopperEffectJumpTargetB_LoWord:
    DC.L    $00000182
ESQ_BannerColorSweepProgramB_AnchorColorWord:
    DC.L    $0aaa018e
ESQ_BannerColorSweepProgramB_TailColorWord:
    DC.W    $0003
ESQ_BannerColorClampValueB:
    DC.B    0
ESQ_BannerColorClampWaitRowB:
    DC.B    $d9
    DC.L    $fffe0180,$00f000e0
ESQ_BannerSweepSrcPlane0PtrReset_HiWord:
    DC.L    $000000e2
ESQ_BannerSweepSrcPlane0PtrReset_LoWord:
    DC.L    $000000e4
ESQ_BannerSweepSrcPlane1PtrReset_HiWord:
    DC.L    $000000e6
ESQ_BannerSweepSrcPlane1PtrReset_LoWord:
    DC.L    $000000e8
ESQ_BannerSweepSrcPlane2PtrReset_HiWord:
    DC.L    $000000ea
ESQ_BannerSweepSrcPlane2PtrReset_LoWord:
    DC.W    0
ESQ_CopperEffectSwitchWaitWordB:
    DC.L    $009c8010
ESQ_CopperBannerTailListB:
    DC.L    $00d9fffe,$0180016a,$01009306,$01820003
    DC.W    $00e0
ESQ_BannerWorkRasterPtrTailB_HiWord:
    DC.L    $000000e2
ESQ_CopperBannerRasterPointerListB:
    DC.L    $0000ffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff,$fffeffff,$fffeffff,$fffeffff
    DC.L    $fffeffff
    DC.W    $fffe
Global_PTR_AUD1_DMA:
    DC.L    76
