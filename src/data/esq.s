; ========== ESQ.c ==========

Global_REF_GRAPHICS_LIBRARY:
    DS.L    1
Global_REF_INTUITION_LIBRARY:
    DS.L    1
Global_REF_UTILITY_LIBRARY:
    DS.L    1
Global_REF_BATTCLOCK_RESOURCE:
    DS.L    1

Global_STR_PREVUEC_FONT:
    NStr    "PrevueC.font"          ; 14 bytes
Global_STRUCT_TEXTATTR_PREVUEC_FONT:
    DC.L    Global_STR_PREVUEC_FONT
    DC.W    25      ; Size 25 font
    DC.B    $40
    DC.B    $20

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
    DC.B    $40     ;
    DC.B    $20     ;

Global_HANDLE_PREVUE_FONT:
    DS.L    1
Global_REF_DISKFONT_LIBRARY:
    DS.L    1
Global_REF_DOS_LIBRARY:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQ_HighlightMsgPort/ESQ_HighlightReplyPort   (highlight message ports)
; TYPE: pointer/pointer (Exec MsgPort)
; PURPOSE: Main message port for highlight work messages and paired reply port.
; USED BY: ESQ init/cleanup, ESQDISP message submit, GCOMMAND message service, NEWGRID polling
; NOTES: Allocated as MsgPort-sized blocks during ESQ startup.
;------------------------------------------------------------------------------
ESQ_HighlightMsgPort:
    DS.L    1
ESQ_HighlightReplyPort:
    DS.L    1
DATA_ESQ_BSS_LONG_1DC7:
    DS.L    1
LAB_1DC7_Length = 1

DATA_ESQ_STR_B_1DC8:
    DC.B    "B"
LAB_1DC8_Length = DATA_ESQ_STR_E_1DC9-DATA_ESQ_STR_B_1DC8

DATA_ESQ_STR_E_1DC9:
    DC.B    "E"
LAB_1DC9_Length = ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED-DATA_ESQ_STR_E_1DC9

ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED:
    DC.B    "3"
ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_Length = DATA_ESQ_TAG_36_1DCB-ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED

DATA_ESQ_TAG_36_1DCB:
    DC.B    "36"
DATA_ESQ_TAG_36_1DCB_Length = ED_DiagScrollSpeedChar-DATA_ESQ_TAG_36_1DCB

;------------------------------------------------------------------------------
; SYM: ED_DiagScrollSpeedChar   (diagnostic SSPD selector char)
; TYPE: u8 (ASCII digit)
; PURPOSE: Single-character diagnostic scroll-speed selector shown in ED diagnostics.
; USED BY: ED_DrawDiagnosticModeText, ED2 diagnostic menu speed cycling, ESQIFF2 diagnostics
; NOTES: Default is `'6'`; ED2 cycles this value and mirrors it into related counters.
;------------------------------------------------------------------------------
ED_DiagScrollSpeedChar:
    DC.B    "6"
LAB_1DCD_Length = DATA_ESQ_STR_N_1DCE-ED_DiagScrollSpeedChar

DATA_ESQ_STR_N_1DCE:
    DC.B    "N"
DATA_ESQ_CONST_BYTE_1DCF:
    DC.B    1
DATA_ESQ_CONST_BYTE_1DD0:
    DC.B    1
DATA_ESQ_STR_6_1DD1:
    DC.B    "6"
DATA_ESQ_STR_6_1DD1_Length = DATA_ESQ_STR_N_1DD2-DATA_ESQ_STR_6_1DD1

DATA_ESQ_STR_N_1DD2:
    DC.B    "N"
DATA_ESQ_STR_N_1DD2_Length = DATA_ESQ_STR_Y_1DD3-DATA_ESQ_STR_N_1DD2

DATA_ESQ_STR_Y_1DD3:
    DC.B    "Y"
DATA_ESQ_STR_Y_1DD3_Length = DATA_ESQ_STR_N_1DD3-DATA_ESQ_STR_Y_1DD3
DATA_ESQ_STR_N_1DD3:
    DC.B    "N"
DATA_ESQ_STR_N_1DD4:
    DC.B    "N"
DATA_ESQ_STR_N_1DD5:
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
    DS.B    1
LAB_1DD8_RASTPORT:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_WeatherStatusTextPtr   (weather/status text pointer)
; TYPE: pointer
; PURPOSE: Optional pointer to dynamic weather/status text for display/export.
; USED BY: WDISP_*, DISKIO2_*, CLEANUP_*, UNKNOWN_*
; NOTES: Null when no status text is available.
;------------------------------------------------------------------------------
WDISP_WeatherStatusTextPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_AliasCount   (alias table entry count)
; TYPE: u16
; PURPOSE: Number of active alias-table entries.
; USED BY: TEXTDISP_FindAliasIndexByName, PARSEINI_*, DISKIO2_*, ESQPARS_*
; NOTES: Used as loop bound for alias-pointer table scans.
;------------------------------------------------------------------------------
TEXTDISP_AliasCount:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_PrimaryLineHeadPtr   (primary line head text pointer)
; TYPE: pointer
; PURPOSE: First segment pointer for primary ESQIFF line text.
; USED BY: ESQIFF2_*, DISKIO2_*, CLEANUP3_*, ESQDISP_*
; NOTES: Paired with ESQIFF_PrimaryLineTailPtr.
;------------------------------------------------------------------------------
ESQIFF_PrimaryLineHeadPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_PrimaryLineTailPtr   (primary line tail text pointer)
; TYPE: pointer
; PURPOSE: Second segment pointer for primary ESQIFF line text.
; USED BY: ESQIFF2_*, DISKIO2_*, CLEANUP3_*, ESQDISP_*
; NOTES: Paired with ESQIFF_PrimaryLineHeadPtr.
;------------------------------------------------------------------------------
ESQIFF_PrimaryLineTailPtr:
    DS.L    1
Global_REF_STR_CLOCK_FORMAT:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_DeferredActionCountdown   (deferred action countdown)
; TYPE: u16
; PURPOSE: Tick countdown before committing a deferred text/display action.
; USED BY: TEXTDISP_TickDisplayState, SCRIPT3_*, ED2_*, ESQFUNC_*
; NOTES: Decremented each tick while TEXTDISP_DeferredActionArmed is set.
;------------------------------------------------------------------------------
TEXTDISP_DeferredActionCountdown:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_DeferredActionArmed   (deferred action armed flag)
; TYPE: u16
; PURPOSE: Indicates a deferred action countdown is active.
; USED BY: TEXTDISP_TickDisplayState, SCRIPT3_*, APP2_*
; NOTES: Treated as boolean/non-zero guard for countdown handling.
;------------------------------------------------------------------------------
TEXTDISP_DeferredActionArmed:
    DS.W    1
DATA_ESQ_BSS_BYTE_1DE0:
    DS.B    1
DATA_ESQ_BSS_BYTE_1DE1:
    DS.B    1
DATA_ESQ_CONST_BYTE_1DE2:
    DC.B    $03
DATA_ESQ_CONST_BYTE_1DE3:
    ; Could be a bunch of carriage returns in a row...
    DC.B    $0c
    DC.L    $0c0c0000,$000c0c00,$05010201,$060a0505
    DC.L    $05000003,$00080007,$00070007,$07000c00
    DC.L    $0c000c00,$0c0c0c00,$0000000c
DATA_ESQ_BSS_WORD_1DE4:
    DS.W    1
DATA_ESQ_BSS_WORD_1DE5:
    DS.W    1
Global_HANDLE_PREVUEC_FONT:
    DS.L    1
Global_HANDLE_H26F_FONT:
    DS.L    1
Global_HANDLE_TOPAZ_FONT:
    DS.L    1
    DS.L    2
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_SecondaryLineHeadPtr   (secondary line head text pointer)
; TYPE: pointer (stored as two words)
; PURPOSE: First segment pointer for secondary ESQIFF line text.
; USED BY: ESQIFF2_*, ESQDISP_*
; NOTES: Declared as two words to preserve original layout/alignment.
;------------------------------------------------------------------------------
ESQIFF_SecondaryLineHeadPtr:
    DS.W    1
LAB_1DE9_B:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_SecondaryLineTailPtr   (secondary line tail text pointer)
; TYPE: pointer
; PURPOSE: Second segment pointer for secondary ESQIFF line text.
; USED BY: ESQIFF2_*, ESQDISP_*
; NOTES: Paired with ESQIFF_SecondaryLineHeadPtr.
;------------------------------------------------------------------------------
ESQIFF_SecondaryLineTailPtr:
    DS.L    1
DATA_ESQ_STR_A_1DEB:
    NStr    "A"
;------------------------------------------------------------------------------
; SYM: WDISP_WeatherStatusOverlayTextPtr   (weather overlay text pointer)
; TYPE: pointer
; PURPOSE: Dynamic text pointer used by weather/status overlay formatting paths.
; USED BY: UNKNOWN_ParseRecordAndUpdateDisplay, WDISP weather draw paths, ESQIFF helpers
; NOTES: Updated through ESQPARS_ReplaceOwnedString-style realloc/copy helper flows.
;------------------------------------------------------------------------------
WDISP_WeatherStatusOverlayTextPtr:
    DS.L    1
Global_LONG_ROM_VERSION_CHECK:
    DC.L    1
DATA_ESQ_BSS_BYTE_1DEE:
    DS.B    1
DATA_ESQ_BSS_BYTE_1DEF:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: ED_DiagAvailMemMask   (diagnostics available-memory mask)
; TYPE: u32 (stored in word slot + alignment)
; PURPOSE: Selects which memory classes (chip/fast/max/largest) are displayed on diagnostics screen.
; USED BY: ED2_HandleDiagnosticsMenuActions, ESQFUNC_DrawMemoryStatusScreen
; NOTES: Low three bits are toggled by diagnostics actions.
;------------------------------------------------------------------------------
ED_DiagAvailMemMask:
    DS.W    1
    DS.B    1
DATA_ESQ_BSS_BYTE_1DF1:
    DS.B    1
DATA_ESQ_BSS_WORD_1DF2:
    DS.W    1
DATA_ESQ_BSS_WORD_1DF3:
    DS.W    1
DATA_ESQ_BSS_WORD_1DF4:
    DS.W    1
Global_WORD_SELECT_CODE_IS_RAVESC:
    DS.W    1
DATA_ESQ_BSS_WORD_1DF6:
    DS.W    1
HAS_REQUESTED_FAST_MEMORY:
    DS.W    1
IS_COMPATIBLE_VIDEO_CHIP:
    DC.L    $00000001
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
DATA_ESQ_STR_NO_DF1_PRESENT_1E0F:
    NStr    "no df1 present"
Global_STR_GUIDE_START_VERSION_AND_BUILD:
    NStr    "Ver %s.%ld Build %ld %s"
Global_STR_MAJOR_MINOR_VERSION:
    NStr    "9.0"   ; Major/minor version string
DATA_ESQ_38_Spaces:
    NStr    "                                       "
Global_STR_DF0_GRADIENT_INI_2:
    NStr    "df0:Gradient.ini"
DATA_ESQ_STR_SystemInitializing:
    NStr    "System Initializing"
DATA_ESQ_STR_PleaseStandByEllipsis:
    NStr    "Please Stand By..."
DATA_ESQ_STR_AttentionSystemEngineer:
    NStr    "ATTENTION SYSTEM ENGINEER!"
DATA_ESQ_STR_ReportErrorCodeEr011ToTVGuide:
    NStr    "Report Error Code ER011 to TV Guide Technical Services."
DATA_ESQ_STR_ReportErrorCodeER012ToTVGuide:
    NStr    "Report Error Code ER012 to TV Guide Technical Services."
Global_STR_DF0_DEFAULT_INI_1:
    NStr    "df0:default.ini"
Global_STR_DF0_BRUSH_INI_1:
    NStr    "df0:brush.ini"
DATA_ESQ_STR_DT:
    NStr    "DT"
DATA_ESQ_STR_DITHER:
    NStr    "DITHER"
Global_STR_DF0_BANNER_INI_1:
    NStr    "df0:banner.ini"
DATA_ESQ_TAG_GRANADA:
    NStr    "GRANADA"
Global_LONG_BUILD_NUMBER:
    DC.L    $00000015   ; 21
Global_STR_BUILD_ID:
    NStr    "JGT"   ; build id string
Global_PTR_STR_BUILD_ID:
    DC.L    Global_STR_BUILD_ID
DATA_ESQ_CONST_LONG_1E22:
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
DATA_ESQ_CONST_LONG_1E23:
    DC.L    $00000082
DATA_ESQ_BSS_WORD_1E24:
    DS.W    1
DATA_ESQ_BSS_LONG_1E25:
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
DATA_ESQ_CONST_LONG_1E27:
    DC.L    $0aaa0184,$03330186,$05550188,$0512018a
    DC.L    $016a018c,$0cc0018e
DATA_ESQ_CONST_LONG_1E28:
    DC.L    $00030190,$00030192,$00030194,$00030196
    DC.L    $00030198,$0003019a,$0003019c,$0003019e
DATA_ESQ_CONST_LONG_1E29:
    DC.L    $000301a0,$000301a2,$000301a4,$000301a6
    DC.L    $000301a8,$000301aa,$000301ac,$000301ae
    DC.L    $000301b0,$000301b2,$000301b4,$000301b6
    DC.L    $000301b8,$000301ba,$000301bc,$000301be
DATA_ESQ_CONST_WORD_1E2A:
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
DATA_ESQ_CONST_LONG_1E2C:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E2D:
    DC.L    $00000180
DATA_ESQ_CONST_LONG_1E2E:
    DC.L    $00030182,$00030184,$03330186,$0cc00188
    DC.L    $0512018a,$016a018c,$0555018e
    DC.W    $0003
DATA_ESQ_CONST_LONG_1E2F:
    DC.L    $00dffffe
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E30:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E31:
    DC.L    $000000e4
DATA_ESQ_CONST_LONG_1E32:
    DC.L    $000000e6
DATA_ESQ_CONST_LONG_1E33:
    DC.L    $000000e8
DATA_ESQ_CONST_LONG_1E34:
    DC.L    $000000ea
DATA_ESQ_CONST_LONG_1E35:
    DC.L    $00000182
DATA_ESQ_CONST_LONG_1E36:
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
DATA_ESQ_CONST_LONG_1E37:
    DC.L    $00d9fffe,$01009306,$01820003
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E38:
    DC.L    $000000e2
DATA_ESQ_BSS_WORD_1E39:
    DS.W    1
DATA_ESQ_CONST_LONG_1E3A:
    DC.L    $00dffffe
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E3B:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E3C:
    DC.L    $000000e4
DATA_ESQ_CONST_LONG_1E3D:
    DC.L    $000000e6
DATA_ESQ_CONST_LONG_1E3E:
    DC.L    $000000e8
DATA_ESQ_CONST_LONG_1E3F:
    DC.L    $000000ea
DATA_ESQ_CONST_LONG_1E40:
    DC.L    $00000100,$b3060084
DATA_ESQ_CONST_LONG_1E41:
    DC.L    $00000086
DATA_ESQ_CONST_LONG_1E42:
    DC.L    $00000182
DATA_ESQ_CONST_LONG_1E43:
    DC.L    $0aaa018e
DATA_ESQ_CONST_WORD_1E44:
    DC.W    $0003
DATA_ESQ_BSS_BYTE_1E45:
    DS.B    1
DATA_ESQ_CONST_BYTE_1E46:
    DC.B    $d9
    DC.L    $fffe0180,$00f000e0
DATA_ESQ_CONST_LONG_1E47:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E48:
    DC.L    $000000e4
DATA_ESQ_CONST_LONG_1E49:
    DC.L    $000000e6
DATA_ESQ_CONST_LONG_1E4A:
    DC.L    $000000e8
DATA_ESQ_CONST_LONG_1E4B:
    DC.L    $000000ea
DATA_ESQ_BSS_WORD_1E4C:
    DS.W    1
DATA_ESQ_CONST_LONG_1E4D:
    DC.L    $009c8010
DATA_ESQ_CONST_LONG_1E4E:
    DC.L    $00d9fffe,$0180016a,$01009306,$01820003
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E4F:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E50:
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
DATA_ESQ_CONST_LONG_1E51:
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
DATA_ESQ_CONST_LONG_1E52:
    DC.L    $00000082
DATA_ESQ_BSS_WORD_1E53:
    DS.W    1
DATA_ESQ_BSS_LONG_1E54:
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
DATA_ESQ_CONST_LONG_1E56:
    DC.L    $0aaa0184,$03330186,$05550188,$0512018a
    DC.L    $016a018c,$0cc0018e
DATA_ESQ_CONST_WORD_1E57:
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
DATA_ESQ_CONST_LONG_1E59:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E5A:
    DC.L    $00000180
DATA_ESQ_CONST_LONG_1E5B:
    DC.L    $00030182,$00030184,$03330186,$0cc00188
    DC.L    $0512018a,$016a018c,$0555018e
    DC.W    $0003
DATA_ESQ_CONST_LONG_1E5C:
    DC.L    $00dffffe
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E5D:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E5E:
    DC.L    $000000e4
DATA_ESQ_CONST_LONG_1E5F:
    DC.L    $000000e6
DATA_ESQ_CONST_LONG_1E60:
    DC.L    $000000e8
DATA_ESQ_CONST_LONG_1E61:
    DC.L    $000000ea
DATA_ESQ_CONST_LONG_1E62:
    DC.L    $00000182
DATA_ESQ_CONST_LONG_1E63:
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
DATA_ESQ_CONST_LONG_1E64:
    DC.L    $00d9fffe,$01009306,$01820003
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E65:
    DC.L    $000000e2
DATA_ESQ_BSS_WORD_1E66:
    DS.W    1
DATA_ESQ_CONST_LONG_1E67:
    DC.L    $00dffffe
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E68:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E69:
    DC.L    $000000e4
DATA_ESQ_CONST_LONG_1E6A:
    DC.L    $000000e6
DATA_ESQ_CONST_LONG_1E6B:
    DC.L    $000000e8
DATA_ESQ_CONST_LONG_1E6C:
    DC.L    $000000ea
DATA_ESQ_CONST_LONG_1E6D:
    DC.L    $00000100,$b3060084
DATA_ESQ_CONST_LONG_1E6E:
    DC.L    $00000086
DATA_ESQ_CONST_LONG_1E6F:
    DC.L    $00000182
DATA_ESQ_CONST_LONG_1E70:
    DC.L    $0aaa018e
DATA_ESQ_CONST_WORD_1E71:
    DC.W    $0003
DATA_ESQ_BSS_BYTE_1E72:
    DS.B    1
DATA_ESQ_CONST_BYTE_1E73:
    DC.B    $d9
    DC.L    $fffe0180,$00f000e0
DATA_ESQ_CONST_LONG_1E74:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E75:
    DC.L    $000000e4
DATA_ESQ_CONST_LONG_1E76:
    DC.L    $000000e6
DATA_ESQ_CONST_LONG_1E77:
    DC.L    $000000e8
DATA_ESQ_CONST_LONG_1E78:
    DC.L    $000000ea
DATA_ESQ_BSS_WORD_1E79:
    DS.W    1
DATA_ESQ_CONST_LONG_1E7A:
    DC.L    $009c8010
DATA_ESQ_CONST_LONG_1E7B:
    DC.L    $00d9fffe,$0180016a,$01009306,$01820003
    DC.W    $00e0
DATA_ESQ_CONST_LONG_1E7C:
    DC.L    $000000e2
DATA_ESQ_CONST_LONG_1E7D:
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
