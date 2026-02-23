; ========== ED2.c ==========

ED2_STR_PAGE:
    NStr    " Page"
ED2_STR_LINE:
    NStr    " Line"
;------------------------------------------------------------------------------
; SYM: ED_CustomPaletteCapturePhaseMod4   (custom palette capture phase)
; TYPE: u32
; PURPOSE: Tracks capture phase modulo 4 for ED_CaptureKeySequence.
; USED BY: ED_CaptureKeySequence
; NOTES: Updated via DivS32 remainder path; sequence runs every 4 input steps.
;------------------------------------------------------------------------------
ED_CustomPaletteCapturePhaseMod4:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_CustomPaletteCaptureIndexOrSentinel   (custom palette capture state/index)
; TYPE: s32
; PURPOSE: Holds parsed nibble/index state and negative sentinel for fallback copy path.
; USED BY: ED_CaptureKeySequence
; NOTES: Values observed include 0..7, -1 sentinel, and 0..23 during template copy loop.
;------------------------------------------------------------------------------
ED_CustomPaletteCaptureIndexOrSentinel:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ED_CustomPaletteTriplesDefaultTemplate24B   (default palette triples template)
; TYPE: u8[24]
; PURPOSE: Default 24-byte template copied into custom palette triples output when capture flow falls back.
; USED BY: ED_CaptureKeySequence
; NOTES: Stored as six longwords; copied byte-wise from stack local into KYBD_CustomPaletteTriplesRBase.
;------------------------------------------------------------------------------
ED_CustomPaletteTriplesDefaultTemplate24B:
    DC.B    0,0,3
    DC.B    12,12,12
    DC.B    0,0,0
    DC.B    12,12,0
    DC.B    5,1,2
    DC.B    1,6,10
    DC.B    5,5,5
    DC.B    0,0,3

; Strings for ESC -> Special Functions -> Save ALL to disk
ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT:
    NStr    "All data is to be saved."

; Strings for ESC -> Special Functions -> Save data to disk
ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT:
    NStr    "TV Guide data is to be saved."

; Strings for ESC -> Special Functions -> Load text ads from disk
ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL:
    NStr    "Text Ads will be loaded from DH2:"

; Strings for ESC -> Special Functions -> Reboot computer
Global_STR_COMPUTER_WILL_RESET:
    NStr    "Computer will reset!"
Global_STR_GO_OFF_AIR_FOR_1_2_MINS:
    NStr    "(go off-air for 1-2 mins)"

Global_STR_SAVING_EVERYTHING_TO_DISK:
    NStr    "Saving ""EVERYTHING"" to disk"
Global_STR_SAVING_PREVUE_DATA_TO_DISK:
    NStr    "Saving Prevue data to disk"
Global_STR_LOADING_TEXT_ADS_FROM_DH2:
    NStr    "Loading Text Ads from DH2:"

; Strings for ESC -> Special Functions -> Reboot computer
Global_STR_REBOOTING_COMPUTER:
    NStr    "Rebooting Computer........"

; Strings for ESC - Edit Attributes?
ED2_STR_NUMBER_TOO_BIG:
    NStr    " Number too big        "
ED2_STR_NUMBER_TOO_SMALL:
    NStr    " Number too small      "
ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT:
    NStr    " Push ESC to exit Attribute Edit."
ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION:
    NStr    " Push RETURN to enter selection"
ED2_STR_PUSH_ANY_KEY_TO_SELECT:
    NStr    " Push any key to select"
ED2_STR_LOCAL_EDIT_NOT_AVAILABLE:
    NStr    "Local Edit not available"

; Version strings shown at the top of the ESC menu
Global_STR_VER_PERCENT_S_PERCENT_L_D:
    NStr    "Ver %s.%ld"
Global_STR_NINE_POINT_ZERO:
    NStr    "10.0"   ; Major/minor version string

; Strings for ESC -> Diagnostic Mode
Global_STR_BAUD_RATE_DIAGNOSTIC_MODE:
    NStr    "%ld baud"
Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS:
    NStr    "Disk 0 is %2ld%% full with %2ld Errors"
;------------------------------------------------------------------------------
; SYM: ED2_DiagnosticDiskUsagePercent   (diagnostic disk usage scratch/result)
; TYPE: u16
; PURPOSE: Holds or reserves output storage for disk-usage percent query in diagnostics UI.
; USED BY: ED1_DrawDiagnosticsScreen
; NOTES: Passed by address to DISKIO_QueryDiskUsagePercentAndSetBufferSize.
;------------------------------------------------------------------------------
ED2_DiagnosticDiskUsagePercent:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED2_DiagnosticDiskSoftErrorCount   (diagnostic soft-error scratch/result)
; TYPE: u16
; PURPOSE: Holds or reserves output storage for soft-error count query in diagnostics UI.
; USED BY: ED1_DrawDiagnosticsScreen
; NOTES: Passed by address to DISKIO_QueryVolumeSoftErrorCount.
;------------------------------------------------------------------------------
ED2_DiagnosticDiskSoftErrorCount:
    DS.W    1
Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2:
    NStr    "Push any key to continue."
;------------------------------------------------------------------------------
; SYM: ED2_HighlightTickEnabledFlag   (highlight tick gate)
; TYPE: u16 flag
; PURPOSE: Gates highlight tick updates once banner tables are initialized.
; USED BY: GCOMMAND_BuildBannerTables, ESQSHARED4_TickCopperAndBannerTransitions
; NOTES: Set to 1 when banner table rebuild completes; tested before highlight tick call.
;------------------------------------------------------------------------------
ED2_HighlightTickEnabledFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED2_SelectedEntryDataPtr/ED2_SelectedEntryTitlePtr   (currently selected entry pointers)
; TYPE: pointer/pointer
; PURPOSE: Tracks the active entry record pointer and its title pointer for ED2 detail/summary panels.
; USED BY: ED2_DrawEntrySummaryPanel, ED2_DrawEntryDetailsPanel
; NOTES: Either pointer may be null when there is no valid current selection.
;------------------------------------------------------------------------------
ED2_SelectedEntryDataPtr:
    DS.L    1
ED2_SelectedEntryTitlePtr:
    DS.L    1
ED2_FMT_SCRSPD_PCT_D:
    NStr    "SCRSPD=%d"
ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D:
    NStr    "MR=%d SBS=%d Sport=%d"
ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR:
    NStr    "Cycle=%c CycleFreq=%d AftrOrdr=%d"
Global_STR_CLOCKCMD_EQUALS_PCT_C:
    NStr    "ClockCmd=%c"
Global_STR_ED2_C_1:
    NStr    "ED2.c"
Global_STR_PI_CLU_POS1:
    NStr    "PI[%d] Clu_pos1=%d"
Global_STR_CHAN_SOURCE_CALLLTRS_1:
    NStr    "Chan=%s Source=%s CallLtrs=%s"
ED2_STR_NullFallbackChannel:
    NStr    "NULL"
ED2_STR_NullFallbackSource:
    NStr    "NULL"
ED2_STR_NullFallbackCallLetters:
    NStr    "NULL"
Global_STR_TS_TITLE_TIME:
    NStr    "TS=%d Title='%s' Time=%s"
ED2_STR_NullFallbackTitle:
    NStr    "NULL"
ED2_STR_NONE_ProgramFlagSummary:
    NStr    "None "
ED2_STR_MOVIE:
    NStr    "Movie "
ED2_STR_ALTHILITEPROG:
    NStr    "ALTHILITEPROG "
ED2_STR_TAGPROG:
    NStr    "TAGPROG "
ED2_STR_SPORTSPROG:
    NStr    "SPORTSPROG "
ED2_STR_DVIEW_USED:
    NStr    "DVIEW_USED "
ED2_STR_REPEATPROG:
    NStr    "REPEATPROG "
ED2_STR_PREVDAYSDATA:
    NStr    "PREVDAYSDATA "
Global_STR_ED2_C_2:
    NStr    "ED2.c"
Global_STR_CLU_CLU_POS1:
    NStr    "CLU[%d] Clu_pos1=%d"
Global_STR_CHAN_SOURCE_CALLLTRS_2:
    NStr    "Chan=%s Source=%s CallLtrs=%s"
ED2_STR_NONE_SourceFlagSummary:
    NStr    "None "
ED2_STR_HILITESRC:
    NStr    "HILITESRC "
ED2_STR_SUMBYSRC:
    NStr    "SUMBYSRC "
ED2_STR_VIDEO_TAG_DISABLE:
    NStr    "VIDEO_TAG_DISABLE "
ED2_STR_CAF_PPVSRC:
    NStr    "CAF_PPVSRC "
ED2_STR_DITTO:
    NStr    "DITTO "
ED2_STR_ALTHILITESRC:
    NStr    "ALTHILITESRC "
ED2_STR_STEREO:
    NStr    "STEREO "
ED2_STR_GRID:
    NStr    "Grid "
ED2_STR_MR:
    NStr    "MR "
ED2_STR_DNICHE:
    NStr    "DNICHE "
ED2_STR_DMPLEX:
    NStr    "DMPLEX "
ED2_STR_CF2_DPPV:
    NStr    "CF2_DPPV "
    DS.W    1
ED2_STR_CTIME:
    NStr    "CTime"
ED2_STR_BTIME:
    NStr    "BTime"
Global_STR_DF0_CLOCK_CMD:
    NStr    "df0:clock.cmd"
ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU:
    NStr3   TextLineFeed,"ED.C: Short DUMP OF CLU",TextLineFeed
ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1_:
    NStr2   "    clu_pos1=%ld, curclu=%s, jdclu1=%ld, curjd=%ld",TextLineFeed
Global_STR_TRUE_1:
    NStr    "TRUE"
Global_STR_FALSE_1:
    NStr    "FALSE"
ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU:
    NStr3   "ED.C: END OF DUMP OF CLU",TextLineFeed,TextLineFeed
ED2_FMT_WICON_PCT_LD:
    NStr2   "wicon = %ld",TextLineFeed
ED2_FMT_W_MIN_PCT_LD_MINUTES:
    NStr2   "w_min = %ld minutes",TextLineFeed
ED2_FMT_WDCNT_EVERY_PCT_LD_TIMES_PCT_LD:
    NStr2   "wdcnt = every %ld times     (%ld)",TextLineFeed
ED2_FMT_CWCNT_PCT_LD_TIMES_FROM_NOW_PCT_LD:
    NStr2   "cwcnt = %ld times from now  (%ld)",TextLineFeed
ED2_FMT_WDATA_PCT_08LX:
    NStr2   "WData = $%08lx",TextLineFeed
ED2_FMT_WCITY_PCT_S:
    NStr2   "WCity = '%s'",TextLineFeed
ED2_FMT_WEATHER_ID_PCT_S:
    NStr2   "Weather_ID = '%s'",TextLineFeed
ED2_FMT_CWCOLOR_PCT_LD:
    NStr2   "cwcolor = %ld",TextLineFeed
ED2_FMT_BANNER_FOR_WEATHER_PCT_D:
    NStr3   TextLineFeed,"banner_for_weather = %d",TextLineFeed
ED2_FMT_BITPLANE1_PCT_8LX:
    NStr    "BitPlane1 =%8lx  "
Global_STR_DF0_GRADIENT_INI_1:
    NStr    "df0:Gradient.ini"
ED2_TAG_NRLS:
    NStr    "NRLS"
ED2_STR_NYYLLZ:
    NStr    "NYyLlZ"
ED2_TAG_NYLRS:
    NStr    "NYLRS"
ED2_STR_SILENCE:
    NStr    "  Silence "
ED2_STR_LEFT:
    NStr    "Left      "
ED2_STR_RIGHT:
    NStr    "     Right"
ED2_STR_BACKGROUND:
    NStr    "Background"
ED2_STR_EXT_DOT_VIDEO_ONLY:
    NStr    "  Ext. Video Only "
ED2_STR_COMPUTER_ONLY:
    NStr    "  Computer Only   "
ED2_STR_OVERLAY_EXT_DOT_VIDEO:
    NStr    "Overlay Ext. Video"
ED2_STR_NEGATIVE_VIDEO:
    NStr    "Negative Video"
ED2_STR_VIDEO_SWITCH:
    NStr    "Video Switch "
ED2_STR_OPEN:
    NStr    "Open  "
ED2_STR_CLOSED:
    NStr    "Closed"
ED2_STR_START_TAPE_VIDEO:
    NStr    "Start TAPE Video   "
ED2_STR_STOP:
    NStr    "Stop  "
    DS.W    1
Global_REF_BOOL_IS_TEXT_OR_CURSOR:
    DC.L    1

; Strings for the ESC menu
Global_STR_EDIT_ADS:
    NStr    "Edit Ads"
Global_STR_EDIT_ATTRIBUTES:
    NStr    "Edit Attributes"
Global_STR_CHANGE_SCROLL_SPEED:
    NStr    "Change Scroll Speed"
Global_STR_DIAGNOSTIC_MODE:
    NStr    "Diagnostic Mode"
Global_STR_SPECIAL_FUNCTIONS:
    NStr    "Special Functions"
Global_STR_VERSIONS_SCREEN:
    NStr    "Versions Screen"
Global_STR_PUSH_ESC_TO_RESUME:
    NStr    " Push ESC to resume"
Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_1:
    NStr    " Push RETURN to enter selection"
Global_STR_PUSH_ANY_KEY_TO_SELECT_1:
    NStr    " Push any key to select"

; Some strings for ESC -> Diagnostic Mode
Global_STR_VIN_BCK_FWD_SSPD_AD_LINE:
    NStr    "VIN:  BCK:  FWD:  SSPD:  #AD:   LINE:"
Global_STR_TZ_DST_CONT_TXT_GRPH:
    NStr    "TZ :  DST:  CONT:  TEXT:  GRPH:"
Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_3:
    NStr    " Push RETURN to enter selection"
Global_STR_PUSH_ANY_KEY_TO_SELECT_2:
    NStr    " Push any key to select"

; Strings for ESC -> Change Scroll Speed
ESQ_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C:
    NStr    "Satellite Delivered scroll speed (%c)"
Global_STR_SPEED_ZERO_NOT_AVAILABLE:
    NStr    "Speed 0 not available"
Global_STR_SPEED_ONE_NOT_AVAILABLE:
    NStr    "Speed 1 not available"
Global_STR_SCROLL_SPEED_2:
    NStr    "Scroll speed = 2 (fastest)"
Global_STR_SCROLL_SPEED_3:
    NStr    "Scroll speed = 3 (default)"
Global_STR_SCROLL_SPEED_4:
    NStr    "Scroll speed = 4"
Global_STR_SCROLL_SPEED_5:
    NStr    "Scroll speed = 5"
Global_STR_SCROLL_SPEED_6:
    NStr    "Scroll speed = 6"
Global_STR_SCROLL_SPEED_7:
    NStr    "Scroll speed = 7 (slowest)"

; Strings for ESC -> Special Functions
Global_STR_SAVE_ALL_TO_DISK:
    NStr    "Save ALL to disk"
Global_STR_SAVE_DATA_TO_DISK:
    NStr    "Save data to disk"
Global_STR_LOAD_TEXT_ADS_FROM_DISK:
    NStr    "Load text ads from disk"
Global_STR_REBOOT_COMPUTER:
    NStr    "Reboot computer"

; Strings for ESC - Edit Ads?
Global_STR_REGISTER:
    NStr    "register "
Global_STR_R_EQUALS:
    NStr    "R= "
Global_STR_G_EQUALS:
    NStr    "G= "
Global_STR_B_EQUALS:
    NStr    "B= "
Global_STR_ARE_YOU_SURE:
    NStr    " Are you sure? (Y/N)"
Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN:
    NStr    " Enter ad number (1-"
Global_STR_LEFT_PARENTHESIS_THEN:
    NStr    ") then"
Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2:
    NStr    " push RETURN to enter selection"
Global_STR_SINGLE_SPACE_4:
    NStr    " "
Global_STR_AD_NUMBER_QUESTIONMARK:
    NStr    "Ad Number? "
Global_STR_CURRENT_COLOR_FORMATTED:
    NStr    " Current Color %02X "
Global_STR_TEXT:
    NStr    "   Text"
Global_STR_CURSOR:
    NStr    " Cursor"
Global_STR_LINE:
    NStr    " Line"
Global_STR_PAGE:
    NStr    " Page"
Global_STR_AD_NUMBER_FORMATTED:
    NStr    "Ad Number %2ld"
Global_STR_ACTIVE_INACTIVE:
    NStr    "Active Inactive"
Global_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION:
    NStr    " Push ESC to make another selection."
Global_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS:
    NStr    " Push HELP for other edit functions."
Global_STR_LINE_MODE_ON_TEXT_COLOR_MODE:
    NStr    " Line mode on       Text color mode "
Global_STR_EDITING_AD_NUMBER_FORMATTED_1:
    NStr    "Editing Ad Number %2ld"
Global_STR_EDITING_AD_NUMBER_FORMATTED_2:
    NStr    "Editing Ad Number %2ld"
ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT:
    NStr    "Push any key to continue."
ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S:
    NStr    "     ** Line/Page Commands **"
ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR:
    NStr    "F1: Home               F6: Clear"
ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL:
    NStr    "F2: Line/Page mode     F7: Insert Line"
ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE:
    NStr    "F3: Center             F8: Delete Line"
ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY:
    NStr    "F4: Left Justify       F9: Apply Color"
ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS:
    NStr    "F5: Right Justify     F10: Insert char"
Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR:
    NStr    "Shift ->: next Ad     DEL: Delete char"
Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE:
    NStr    "Shift <-: prev Ad   CTRLC: Color Mode"
Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND:
    NStr    "CTRLF: Foreground   CTRLB: Background"
