; ========== ED2.c ==========

LAB_1D16:
    NStr    " Page"
LAB_1D17:
    NStr    " Line"
LAB_1D18:
    DS.L    1
LAB_1D19:
    DS.L    1
LAB_1D1A:
    DC.L    $0000030c,$0c0c0000,$000c0c00,$05010201
    DC.L    $060a0505,$05000003

; Strings for ESC -> Special Functions -> Save ALL to disk
LAB_1D1B:
    NStr    "All data is to be saved."

; Strings for ESC -> Special Functions -> Save data to disk
LAB_1D1C:
    NStr    "TV Guide data is to be saved."

; Strings for ESC -> Special Functions -> Load text ads from disk
LAB_1D1D:
    NStr    "Text Ads will be loaded from DH2:"

; Strings for ESC -> Special Functions -> Reboot computer
GLOB_STR_COMPUTER_WILL_RESET:
    NStr    "Computer will reset!"
GLOB_STR_GO_OFF_AIR_FOR_1_2_MINS:
    NStr    "(go off-air for 1-2 mins)"

GLOB_STR_SAVING_EVERYTHING_TO_DISK:
    NStr    "Saving ""EVERYTHING"" to disk"
GLOB_STR_SAVING_PREVUE_DATA_TO_DISK:
    NStr    "Saving Prevue data to disk"
GLOB_STR_LOADING_TEXT_ADS_FROM_DH2:
    NStr    "Loading Text Ads from DH2:"

; Strings for ESC -> Special Functions -> Reboot computer
GLOB_STR_REBOOTING_COMPUTER:
    NStr    "Rebooting Computer........"

; Strings for ESC - Edit Attributes?
LAB_1D24:
    NStr    " Number too big        "
LAB_1D25:
    NStr    " Number too small      "
LAB_1D26:
    NStr    " Push ESC to exit Attribute Edit."
LAB_1D27:
    NStr    " Push RETURN to enter selection"
LAB_1D28:
    NStr    " Push any key to select"
LAB_1D29:
    NStr    "Local Edit not available"

; Version strings shown at the top of the ESC menu
GLOB_STR_VER_PERCENT_S_PERCENT_L_D:
    NStr    "Ver %s.%ld"
GLOB_STR_NINE_POINT_ZERO:
    NStr    "9.0"   ; Major/minor version string

; Strings for ESC -> Diagnostic Mode
GLOB_STR_BAUD_RATE_DIAGNOSTIC_MODE:
    NStr    "%ld baud"
GLOB_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS:
    NStr    "Disk 0 is %2ld%% full with %2ld Errors"
LAB_1D2E:
    DS.W    1
LAB_1D2F:
    DS.W    1
GLOB_STR_PUSH_ANY_KEY_TO_CONTINUE_2:
    NStr    "Push any key to continue."
LAB_1D31:
    DS.W    1
LAB_1D32:
    DS.L    1
LAB_1D33:
    DS.L    1
LAB_1D34:
    NStr    "SCRSPD=%d"
LAB_1D35:
    NStr    "MR=%d SBS=%d Sport=%d"
LAB_1D36:
    NStr    "Cycle=%c CycleFreq=%d AftrOrdr=%d"
GLOB_STR_CLOCKCMD_EQUALS_PCT_C:
    NStr    "ClockCmd=%c"
GLOB_STR_ED2_C_1:
    NStr    "ED2.c"
GLOB_STR_PI_CLU_POS1:
    NStr    "PI[%d] Clu_pos1=%d"
GLOB_STR_CHAN_SOURCE_CALLLTRS_1:
    NStr    "Chan=%s Source=%s CallLtrs=%s"
LAB_1D3B:
    NStr    "NULL"
LAB_1D3C:
    NStr    "NULL"
LAB_1D3D:
    NStr    "NULL"
GLOB_STR_TS_TITLE_TIME:
    NStr    "TS=%d Title='%s' Time=%s"
LAB_1D3F:
    NStr    "NULL"
LAB_1D40:
    NStr    "None "
LAB_1D41:
    NStr    "Movie "
LAB_1D42:
    NStr    "ALTHILITEPROG "
LAB_1D43:
    NStr    "TAGPROG "
LAB_1D44:
    NStr    "SPORTSPROG "
LAB_1D45:
    NStr    "DVIEW_USED "
LAB_1D46:
    NStr    "REPEATPROG "
LAB_1D47:
    NStr    "PREVDAYSDATA "
GLOB_STR_ED2_C_2:
    NStr    "ED2.c"
GLOB_STR_CLU_CLU_POS1:
    NStr    "CLU[%d] Clu_pos1=%d"
GLOB_STR_CHAN_SOURCE_CALLLTRS_2:
    NStr    "Chan=%s Source=%s CallLtrs=%s"
LAB_1D4B:
    NStr    "None "
LAB_1D4C:
    NStr    "HILITESRC "
LAB_1D4D:
    NStr    "SUMBYSRC "
LAB_1D4E:
    NStr    "VIDEO_TAG_DISABLE "
LAB_1D4F:
    NStr    "CAF_PPVSRC "
LAB_1D50:
    NStr    "DITTO "
LAB_1D51:
    NStr    "ALTHILITESRC "
LAB_1D52:
    NStr    "STEREO "
LAB_1D53:
    NStr    "Grid "
LAB_1D54:
    NStr    "MR "
LAB_1D55:
    NStr    "DNICHE "
LAB_1D56:
    NStr    "DMPLEX "
LAB_1D57:
    NStr    "CF2_DPPV "
    DS.W    1
LAB_1D58:
    NStr    "CTime"
LAB_1D59:
    NStr    "BTime"
GLOB_STR_DF0_CLOCK_CMD:
    NStr    "df0:clock.cmd"
LAB_1D5B:
    NStr3   TextLineFeed,"ED.C: Short DUMP OF CLU",TextLineFeed
LAB_1D5C:
    NStr2   "    clu_pos1=%ld, curclu=%s, jdclu1=%ld, curjd=%ld",TextLineFeed
GLOB_STR_TRUE_1:
    NStr    "TRUE"
GLOB_STR_FALSE_1:
    NStr    "FALSE"
LAB_1D5F:
    NStr3   "ED.C: END OF DUMP OF CLU",TextLineFeed,TextLineFeed
LAB_1D60:
    NStr2   "wicon = %ld",TextLineFeed
LAB_1D61:
    NStr2   "w_min = %ld minutes",TextLineFeed
LAB_1D62:
    NStr2   "wdcnt = every %ld times     (%ld)",TextLineFeed
LAB_1D63:
    NStr2   "cwcnt = %ld times from now  (%ld)",TextLineFeed
LAB_1D64:
    NStr2   "WData = $%08lx",TextLineFeed
LAB_1D65:
    NStr2   "WCity = '%s'",TextLineFeed
LAB_1D66:
    NStr2   "Weather_ID = '%s'",TextLineFeed
LAB_1D67:
    NStr2   "cwcolor = %ld",TextLineFeed
LAB_1D68:
    NStr3   TextLineFeed,"banner_for_weather = %d",TextLineFeed
LAB_1D69:
    NStr    "BitPlane1 =%8lx  "
GLOB_STR_DF0_GRADIENT_INI_1:
    NStr    "df0:Gradient.ini"
LAB_1D6B:
    NStr    "NRLS"
LAB_1D6C:
    NStr    "NYyLlZ"
LAB_1D6D:
    NStr    "NYLRS"
LAB_1D6E:
    NStr    "  Silence "
LAB_1D6F:
    NStr    "Left      "
LAB_1D70:
    NStr    "     Right"
LAB_1D71:
    NStr    "Background"
LAB_1D72:
    NStr    "  Ext. Video Only "
LAB_1D73:
    NStr    "  Computer Only   "
LAB_1D74:
    NStr    "Overlay Ext. Video"
LAB_1D75:
    NStr    "Negative Video"
LAB_1D76:
    NStr    "Video Switch "
LAB_1D77:
    NStr    "Open  "
LAB_1D78:
    NStr    "Closed"
LAB_1D79:
    NStr    "Start TAPE Video   "
LAB_1D7A:
    NStr    "Stop  "
    DS.W    1
GLOB_REF_BOOL_IS_TEXT_OR_CURSOR:
    DC.L    $00000001

; Strings for the ESC menu
GLOB_STR_EDIT_ADS:
    NStr    "Edit Ads"
GLOB_STR_EDIT_ATTRIBUTES:
    NStr    "Edit Attributes"
GLOB_STR_CHANGE_SCROLL_SPEED:
    NStr    "Change Scroll Speed"
GLOB_STR_DIAGNOSTIC_MODE:
    NStr    "Diagnostic Mode"
GLOB_STR_SPECIAL_FUNCTIONS:
    NStr    "Special Functions"
GLOB_STR_VERSIONS_SCREEN:
    NStr    "Versions Screen"
GLOB_STR_PUSH_ESC_TO_RESUME:
    NStr    " Push ESC to resume"
GLOB_STR_PUSH_RETURN_TO_ENTER_SELECTION_1:
    NStr    " Push RETURN to enter selection"
GLOB_STR_PUSH_ANY_KEY_TO_SELECT_1:
    NStr    " Push any key to select"

; Some strings for ESC -> Diagnostic Mode
GLOB_STR_VIN_BCK_FWD_SSPD_AD_LINE:
    NStr    "VIN:  BCK:  FWD:  SSPD:  #AD:   LINE:"
GLOB_STR_TZ_DST_CONT_TXT_GRPH:
    NStr    "TZ :  DST:  CONT:  TEXT:  GRPH:"
GLOB_STR_PUSH_RETURN_TO_ENTER_SELECTION_3:
    NStr    " Push RETURN to enter selection"
GLOB_STR_PUSH_ANY_KEY_TO_SELECT_2:
    NStr    " Push any key to select"

; Strings for ESC -> Change Scroll Speed
GLOB_STR_SATELLITE_DELIVERED_SCROLL_SPEED_PCT_C:
    NStr    "Satellite Delivered scroll speed (%c)"
GLOB_STR_SPEED_ZERO_NOT_AVAILABLE:
    NStr    "Speed 0 not available"
GLOB_STR_SPEED_ONE_NOT_AVAILABLE:
    NStr    "Speed 1 not available"
GLOB_STR_SCROLL_SPEED_2:
    NStr    "Scroll speed = 2 (fastest)"
GLOB_STR_SCROLL_SPEED_3:
    NStr    "Scroll speed = 3 (default)"
GLOB_STR_SCROLL_SPEED_4:
    NStr    "Scroll speed = 4"
GLOB_STR_SCROLL_SPEED_5:
    NStr    "Scroll speed = 5"
GLOB_STR_SCROLL_SPEED_6:
    NStr    "Scroll speed = 6"
GLOB_STR_SCROLL_SPEED_7:
    NStr    "Scroll speed = 7 (slowest)"

; Strings for ESC -> Special Functions
GLOB_STR_SAVE_ALL_TO_DISK:
    NStr    "Save ALL to disk"
GLOB_STR_SAVE_DATA_TO_DISK:
    NStr    "Save data to disk"
GLOB_STR_LOAD_TEXT_ADS_FROM_DISK:
    NStr    "Load text ads from disk"
GLOB_STR_REBOOT_COMPUTER:
    NStr    "Reboot computer"

; Strings for ESC - Edit Ads?
GLOB_STR_REGISTER:
    NStr    "register "
GLOB_STR_R_EQUALS:
    NStr    "R= "
GLOB_STR_G_EQUALS:
    NStr    "G= "
GLOB_STR_B_EQUALS:
    NStr    "B= "
GLOB_STR_ARE_YOU_SURE:
    NStr    " Are you sure? (Y/N)"
GLOB_STR_ENTER_AD_NUMBER_ONE_HYPHEN:
    NStr    " Enter ad number (1-"
GLOB_STR_LEFT_PARENTHESIS_THEN:
    NStr    ") then"
GLOB_STR_PUSH_RETURN_TO_ENTER_SELECTION_2:
    NStr    " push RETURN to enter selection"
GLOB_STR_SINGLE_SPACE_4:
    NStr    " "
GLOB_STR_AD_NUMBER_QUESTIONMARK:
    NStr    "Ad Number? "
GLOB_STR_CURRENT_COLOR_FORMATTED:
    NStr    " Current Color %02X "
GLOB_STR_TEXT:
    NStr    "   Text"
GLOB_STR_CURSOR:
    NStr    " Cursor"
GLOB_STR_LINE:
    NStr    " Line"
GLOB_STR_PAGE:
    NStr    " Page"
GLOB_STR_AD_NUMBER_FORMATTED:
    NStr    "Ad Number %2ld"
GLOB_STR_ACTIVE_INACTIVE:
    NStr    "Active Inactive"
GLOB_STR_PUSH_ESC_TO_MAKE_ANOTHER_SELECTION:
    NStr    " Push ESC to make another selection."
GLOB_STR_PUSH_HELP_FOR_OTHER_EDIT_FUNCTIONS:
    NStr    " Push HELP for other edit functions."
GLOB_STR_LINE_MODE_ON_TEXT_COLOR_MODE:
    NStr    " Line mode on       Text color mode "
GLOB_STR_EDITING_AD_NUMBER_FORMATTED_1:
    NStr    "Editing Ad Number %2ld"
GLOB_STR_EDITING_AD_NUMBER_FORMATTED_2:
    NStr    "Editing Ad Number %2ld"
LAB_1DAC:
    NStr    "Push any key to continue."
LAB_1DAD:
    NStr    "     ** Line/Page Commands **"
LAB_1DAE:
    NStr    "F1: Home               F6: Clear"
LAB_1DAF:
    NStr    "F2: Line/Page mode     F7: Insert Line"
LAB_1DB0:
    NStr    "F3: Center             F8: Delete Line"
LAB_1DB1:
    NStr    "F4: Left Justify       F9: Apply Color"
LAB_1DB2:
    NStr    "F5: Right Justify     F10: Insert char"
GLOB_STR_SHIFT_RIGHT_NEXT_AD_DEL_DELETE_CHAR:
    NStr    "Shift ->: next Ad     DEL: Delete char"
GLOB_STR_SHIFT_LEFT_PREV_AD_CTRLC_COLOR_MODE:
    NStr    "Shift <-: prev Ad   CTRLC: Color Mode"
GLOB_STR_CTRLF_FOREGROUND_CTRLB_BACKGROUND:
    NStr    "CTRLF: Foreground   CTRLB: Background"
