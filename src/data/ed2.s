; ========== ED2.c ==========

DATA_ED2_STR_PAGE_1D16:
    NStr    " Page"
DATA_ED2_STR_LINE_1D17:
    NStr    " Line"
DATA_ED2_BSS_LONG_1D18:
    DS.L    1
DATA_ED2_BSS_LONG_1D19:
    DS.L    1
DATA_ED2_CONST_LONG_1D1A:
    DC.L    $0000030c,$0c0c0000,$000c0c00,$05010201
    DC.L    $060a0505,$05000003

; Strings for ESC -> Special Functions -> Save ALL to disk
DATA_ED2_STR_ALL_DATA_IS_TO_BE_SAVED_DOT_1D1B:
    NStr    "All data is to be saved."

; Strings for ESC -> Special Functions -> Save data to disk
DATA_ED2_STR_TV_GUIDE_DATA_IS_TO_BE_SAVED_DOT_1D1C:
    NStr    "TV Guide data is to be saved."

; Strings for ESC -> Special Functions -> Load text ads from disk
DATA_ED2_STR_TEXT_ADS_WILL_BE_LOADED_FROM_DH2_COL_1D1D:
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
DATA_ED2_STR_NUMBER_TOO_BIG_1D24:
    NStr    " Number too big        "
DATA_ED2_STR_NUMBER_TOO_SMALL_1D25:
    NStr    " Number too small      "
DATA_ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT_1D26:
    NStr    " Push ESC to exit Attribute Edit."
DATA_ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION_1D27:
    NStr    " Push RETURN to enter selection"
DATA_ED2_STR_PUSH_ANY_KEY_TO_SELECT_1D28:
    NStr    " Push any key to select"
DATA_ED2_STR_LOCAL_EDIT_NOT_AVAILABLE_1D29:
    NStr    "Local Edit not available"

; Version strings shown at the top of the ESC menu
Global_STR_VER_PERCENT_S_PERCENT_L_D:
    NStr    "Ver %s.%ld"
Global_STR_NINE_POINT_ZERO:
    NStr    "9.0"   ; Major/minor version string

; Strings for ESC -> Diagnostic Mode
Global_STR_BAUD_RATE_DIAGNOSTIC_MODE:
    NStr    "%ld baud"
Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS:
    NStr    "Disk 0 is %2ld%% full with %2ld Errors"
DATA_ED2_BSS_WORD_1D2E:
    DS.W    1
DATA_ED2_BSS_WORD_1D2F:
    DS.W    1
Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2:
    NStr    "Push any key to continue."
DATA_ED2_BSS_WORD_1D31:
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
DATA_ED2_FMT_SCRSPD_PCT_D_1D34:
    NStr    "SCRSPD=%d"
DATA_ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D_1D35:
    NStr    "MR=%d SBS=%d Sport=%d"
DATA_ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR_1D36:
    NStr    "Cycle=%c CycleFreq=%d AftrOrdr=%d"
Global_STR_CLOCKCMD_EQUALS_PCT_C:
    NStr    "ClockCmd=%c"
Global_STR_ED2_C_1:
    NStr    "ED2.c"
Global_STR_PI_CLU_POS1:
    NStr    "PI[%d] Clu_pos1=%d"
Global_STR_CHAN_SOURCE_CALLLTRS_1:
    NStr    "Chan=%s Source=%s CallLtrs=%s"
DATA_ED2_TAG_NULL_1D3B:
    NStr    "NULL"
DATA_ED2_TAG_NULL_1D3C:
    NStr    "NULL"
DATA_ED2_TAG_NULL_1D3D:
    NStr    "NULL"
Global_STR_TS_TITLE_TIME:
    NStr    "TS=%d Title='%s' Time=%s"
DATA_ED2_TAG_NULL_1D3F:
    NStr    "NULL"
DATA_ED2_STR_NONE_1D40:
    NStr    "None "
DATA_ED2_STR_MOVIE_1D41:
    NStr    "Movie "
DATA_ED2_STR_ALTHILITEPROG_1D42:
    NStr    "ALTHILITEPROG "
DATA_ED2_STR_TAGPROG_1D43:
    NStr    "TAGPROG "
DATA_ED2_STR_SPORTSPROG_1D44:
    NStr    "SPORTSPROG "
DATA_ED2_STR_DVIEW_USED_1D45:
    NStr    "DVIEW_USED "
DATA_ED2_STR_REPEATPROG_1D46:
    NStr    "REPEATPROG "
DATA_ED2_STR_PREVDAYSDATA_1D47:
    NStr    "PREVDAYSDATA "
Global_STR_ED2_C_2:
    NStr    "ED2.c"
Global_STR_CLU_CLU_POS1:
    NStr    "CLU[%d] Clu_pos1=%d"
Global_STR_CHAN_SOURCE_CALLLTRS_2:
    NStr    "Chan=%s Source=%s CallLtrs=%s"
DATA_ED2_STR_NONE_1D4B:
    NStr    "None "
DATA_ED2_STR_HILITESRC_1D4C:
    NStr    "HILITESRC "
DATA_ED2_STR_SUMBYSRC_1D4D:
    NStr    "SUMBYSRC "
DATA_ED2_STR_VIDEO_TAG_DISABLE_1D4E:
    NStr    "VIDEO_TAG_DISABLE "
DATA_ED2_STR_CAF_PPVSRC_1D4F:
    NStr    "CAF_PPVSRC "
DATA_ED2_STR_DITTO_1D50:
    NStr    "DITTO "
DATA_ED2_STR_ALTHILITESRC_1D51:
    NStr    "ALTHILITESRC "
DATA_ED2_STR_STEREO_1D52:
    NStr    "STEREO "
DATA_ED2_STR_GRID_1D53:
    NStr    "Grid "
DATA_ED2_STR_MR_1D54:
    NStr    "MR "
DATA_ED2_STR_DNICHE_1D55:
    NStr    "DNICHE "
DATA_ED2_STR_DMPLEX_1D56:
    NStr    "DMPLEX "
DATA_ED2_STR_CF2_DPPV_1D57:
    NStr    "CF2_DPPV "
    DS.W    1
DATA_ED2_STR_CTIME_1D58:
    NStr    "CTime"
DATA_ED2_STR_BTIME_1D59:
    NStr    "BTime"
Global_STR_DF0_CLOCK_CMD:
    NStr    "df0:clock.cmd"
DATA_ED2_STR_ED_DOT_C_COLON_SHORT_DUMP_OF_CLU_1D5B:
    NStr3   TextLineFeed,"ED.C: Short DUMP OF CLU",TextLineFeed
DATA_ED2_FMT_CLU_POS1_PCT_LD_CURCLU_PCT_S_JDCLU1__1D5C:
    NStr2   "    clu_pos1=%ld, curclu=%s, jdclu1=%ld, curjd=%ld",TextLineFeed
Global_STR_TRUE_1:
    NStr    "TRUE"
Global_STR_FALSE_1:
    NStr    "FALSE"
DATA_ED2_STR_ED_DOT_C_COLON_END_OF_DUMP_OF_CLU_1D5F:
    NStr3   "ED.C: END OF DUMP OF CLU",TextLineFeed,TextLineFeed
DATA_ED2_FMT_WICON_PCT_LD_1D60:
    NStr2   "wicon = %ld",TextLineFeed
DATA_ED2_FMT_W_MIN_PCT_LD_MINUTES_1D61:
    NStr2   "w_min = %ld minutes",TextLineFeed
DATA_ED2_FMT_WDCNT_EVERY_PCT_LD_TIMES_PCT_LD_1D62:
    NStr2   "wdcnt = every %ld times     (%ld)",TextLineFeed
DATA_ED2_FMT_CWCNT_PCT_LD_TIMES_FROM_NOW_PCT_LD_1D63:
    NStr2   "cwcnt = %ld times from now  (%ld)",TextLineFeed
DATA_ED2_FMT_WDATA_PCT_08LX_1D64:
    NStr2   "WData = $%08lx",TextLineFeed
DATA_ED2_FMT_WCITY_PCT_S_1D65:
    NStr2   "WCity = '%s'",TextLineFeed
DATA_ED2_FMT_WEATHER_ID_PCT_S_1D66:
    NStr2   "Weather_ID = '%s'",TextLineFeed
DATA_ED2_FMT_CWCOLOR_PCT_LD_1D67:
    NStr2   "cwcolor = %ld",TextLineFeed
DATA_ED2_FMT_BANNER_FOR_WEATHER_PCT_D_1D68:
    NStr3   TextLineFeed,"banner_for_weather = %d",TextLineFeed
DATA_ED2_FMT_BITPLANE1_PCT_8LX_1D69:
    NStr    "BitPlane1 =%8lx  "
Global_STR_DF0_GRADIENT_INI_1:
    NStr    "df0:Gradient.ini"
DATA_ED2_TAG_NRLS_1D6B:
    NStr    "NRLS"
DATA_ED2_STR_NYYLLZ_1D6C:
    NStr    "NYyLlZ"
DATA_ED2_TAG_NYLRS_1D6D:
    NStr    "NYLRS"
DATA_ED2_STR_SILENCE_1D6E:
    NStr    "  Silence "
DATA_ED2_STR_LEFT_1D6F:
    NStr    "Left      "
DATA_ED2_STR_RIGHT_1D70:
    NStr    "     Right"
DATA_ED2_STR_BACKGROUND_1D71:
    NStr    "Background"
DATA_ED2_STR_EXT_DOT_VIDEO_ONLY_1D72:
    NStr    "  Ext. Video Only "
DATA_ED2_STR_COMPUTER_ONLY_1D73:
    NStr    "  Computer Only   "
DATA_ED2_STR_OVERLAY_EXT_DOT_VIDEO_1D74:
    NStr    "Overlay Ext. Video"
DATA_ED2_STR_NEGATIVE_VIDEO_1D75:
    NStr    "Negative Video"
DATA_ED2_STR_VIDEO_SWITCH_1D76:
    NStr    "Video Switch "
DATA_ED2_STR_OPEN_1D77:
    NStr    "Open  "
DATA_ED2_STR_CLOSED_1D78:
    NStr    "Closed"
DATA_ED2_STR_START_TAPE_VIDEO_1D79:
    NStr    "Start TAPE Video   "
DATA_ED2_STR_STOP_1D7A:
    NStr    "Stop  "
    DS.W    1
Global_REF_BOOL_IS_TEXT_OR_CURSOR:
    DC.L    $00000001

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
Global_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C:
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
DATA_ED2_STR_PUSH_ANY_KEY_TO_CONTINUE_DOT_1DAC:
    NStr    "Push any key to continue."
DATA_ED2_STR_STAR_STAR_LINE_SLASH_PAGE_COMMANDS_S_1DAD:
    NStr    "     ** Line/Page Commands **"
DATA_ED2_STR_F1_COLON_HOME_F6_COLON_CLEAR_1DAE:
    NStr    "F1: Home               F6: Clear"
DATA_ED2_STR_F2_COLON_LINE_SLASH_PAGE_MODE_F7_COL_1DAF:
    NStr    "F2: Line/Page mode     F7: Insert Line"
DATA_ED2_CMD_F3_COLON_CENTER_F8_COLON_DELETE_LINE_1DB0:
    NStr    "F3: Center             F8: Delete Line"
DATA_ED2_STR_F4_COLON_LEFT_JUSTIFY_F9_COLON_APPLY_1DB1:
    NStr    "F4: Left Justify       F9: Apply Color"
DATA_ED2_STR_F5_COLON_RIGHT_JUSTIFY_F10_COLON_INS_1DB2:
    NStr    "F5: Right Justify     F10: Insert char"
Global_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR:
    NStr    "Shift ->: next Ad     DEL: Delete char"
Global_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE:
    NStr    "Shift <-: prev Ad   CTRLC: Color Mode"
Global_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND:
    NStr    "CTRLF: Foreground   CTRLB: Background"
