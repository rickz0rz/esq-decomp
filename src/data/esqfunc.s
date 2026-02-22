; ========== ESQFUNC.c ==========

Global_STR_ESQFUNC_C_1:
    NStr    "ESQFUNC.c"
Global_STR_VERTICAL_BLANK_INT:
    NStr    "Vertical Blank Int"
Global_STR_ESQFUNC_C_2:
    NStr    "ESQFUNC.c"
Global_STR_JOYSTICK_INT:
    NStr    "JoyStick Int"
Global_STR_ESQFUNC_C_3:
    NStr    "ESQFUNC.c"
Global_STR_ESQFUNC_C_4:
    NStr    "ESQFUNC.c"
Global_STR_RS232_RECEIVE_HANDLER:
    NStr    "RS232 Receive Handler"
Global_STR_ESQFUNC_C_5:
    NStr    "ESQFUNC.c"
Global_STR_ESQFUNC_C_6:
    NStr    "ESQFUNC.c"
Global_STR_DISK_0_IS_WRITE_PROTECTED:
    NStr    "Disk 0 is write protected"
Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0:
    NStr    "You MUST re-insert SYSTEM disk into drive 0!"

; Strings for: ESC -> Version Screen
Global_STR_BUILD_NUMBER_FORMATTED:
    NStr    "Build Number: '%ld%s'"
Global_STR_ROM_VERSION_FORMATTED:
    NStr    " ROM Version: '%s'"
Global_STR_ROM_VERSION_1_3:
    NStr    "1.3"
Global_STR_ROM_VERSION_2_04:
    NStr    "2.04"
Global_STR_PUSH_ANY_KEY_TO_CONTINUE_1:
    NStr    "Push any key to continue."

; Strings for: ESC -> Diagnostic Mode
Global_STR_DATA_CMDS_CERRS_LERRS:
    NStr    "DATA: Cmds:%08ld CErrs:%03ld LErrs:%03ld"
Global_STR_CTRL_CMDS_CERRS_LERRS:
    NStr    "CTRL: Cmds:%08ld CErrs:%03ld LErrs:%03ld"
Global_STR_L_CHIP_FAST_MAX:
    NStr    "L_CHIP:%7ld  FAST:%8ld  MAX:%8ld"
Global_STR_CHIP_PLACEHOLDER:
    NStr    "CHIP:%7ld                             "
Global_STR_FAST_PLACEHOLDER:
    NStr    "              FAST:%8ld              "
Global_STR_MAX_PLACEHOLDER:
    NStr    "                             MAX:%8ld"
Global_STR_MEMORY_TYPES_DISABLED:
    NStr    "Memory types disabled (use CTRL C/F/M/A)."
Global_STR_DATA_OVERRUNS_FORMATTED:
    NStr    "DATA Overruns: %ld"
Global_STR_DATA_H_T_C_MAX_FORMATTED:
    NStr    "DATA: H:%05ld  T:%05ld  C:%05ld  MAX:%05ld"
Global_STR_CTRL_H_T_C_MAX_FORMATTED:
    NStr    "CTRL: H:%05ld  T:%05ld  C:%05ld  MAX:%05ld"

Global_STR_JULIAN_DAY_NEXT_FORMATTED:
    NStr    "julian day = %3ld    next = %3ld"
Global_STR_JDAY1_JDAY2_FORMATTED:
    NStr    "jday1 = %3ld     jday2 =  %3ld"
Global_STR_CURCLU_NXTCLU_FORMATTED:
    NStr    " curclu =%2ld nxtclu =%2ld "
Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED:
    NStr    "C.date=%2ld C.month=%2ld lp=%4ld yr=%4ld"
Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED:
    NStr    "B.date=%2ld B.month=%2ld lp=%4ld yr=%4ld"
Global_STR_C_DST_B_DST_PSHIFT_FORMATTED:
    NStr    "C.dst =%2ld B.dst =%2ld pshift =%2ld"
Global_STR_C_HOUR_B_HOUR_CS_FORMATTED:
    NStr    "C.hour =%3ld B.hour =%3ld cs=%2ld"
DATA_ESQFUNC_BSS_LONG_1EB1:
    DS.L    1
DATA_ESQFUNC_STR_VIDEO_INSERTION_INACTIVE_1EB2:
    NStr    "VIDEO_INSERTION_INACTIVE"
DATA_ESQFUNC_STR_VIDEO_INSERTION_START_1EB3:
    NStr    "VIDEO_INSERTION_START"
DATA_ESQFUNC_STR_VIDEO_INSERTION_INPROGRESS_1EB4:
    NStr    "VIDEO_INSERTION_INPROGRESS"
DATA_ESQFUNC_STR_VIDEO_INSERTION_STOP_1EB5:
    NStr    "VIDEO_INSERTION_STOP"
DATA_ESQFUNC_CONST_LONG_1EB6:
    DC.L    DATA_ESQFUNC_STR_VIDEO_INSERTION_INACTIVE_1EB2
    DC.L    DATA_ESQFUNC_STR_VIDEO_INSERTION_START_1EB3
    DC.L    DATA_ESQFUNC_STR_VIDEO_INSERTION_INPROGRESS_1EB4
Global_PTR_DATA_ESQFUNC_STR_VIDEO_INSERTION_STOP_1EB5
    DC.L    DATA_ESQFUNC_STR_VIDEO_INSERTION_STOP_1EB5
DATA_ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT_1EB7:
    NStr    "  CartSW: %s CartREL: %s VidSW: %s on_air: %s "
DATA_ESQFUNC_STR_CLOSED_ENABLED_1EB8:
    NStr    "CLOSED (ENABLED)"
DATA_ESQFUNC_STR_OPEN_DISABLED_1EB9:
    NStr    "OPEN (DISABLED)"
DATA_ESQFUNC_TAG_CLOSED_1EBA:
    NStr    "CLOSED"
DATA_ESQFUNC_TAG_OPEN_1EBB:
    NStr    "OPEN"
DATA_ESQFUNC_STR_CLOSED_ON_AIR_1EBC:
    NStr    "CLOSED (ON AIR)"
DATA_ESQFUNC_STR_OPEN_OFF_AIR_1EBD:
    NStr    "OPEN (OFF AIR)"
DATA_ESQFUNC_STR_ON_AIR_1EBE:
    NStr    "ON_AIR"
DATA_ESQFUNC_STR_OFF_AIR_1EBF:
    NStr    "OFF_AIR"
DATA_ESQFUNC_STR_NO_DETECT_1EC0:
    NStr    "NO_DETECT"
DATA_ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X_1EC1:
    NStr    " insertime = %s,  WINIT = 0x%04X "
DATA_ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L_1EC2:
    NStr    " local_mode=%ld local_update=%ld LA_(mode=%d state=%d curEv=%d) laCur(curType=%d curEvent=%d) "
DATA_ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC_1EC3:
    NStr    " CTime = %02d/%02d/%04d %2d:%02d:%02d%s, LATime = %04d "
DATA_ESQFUNC_STR_PM_1EC4:
    NStr    "pm"
DATA_ESQFUNC_STR_AM_1EC5:
    NStr    "am"
DATA_ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT_1EC6:
    NStr    " L_CHIP:%07ld  FAST:%08ld  MAX:%08ld "
DATA_ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR_1EC7:
    NStr    " DATA: CMD CNT:%08ld CRC ERRS:%03ld LEN ERRS:%03ld BUF MAX:%05ld BUF CNT:%05ld"
DATA_ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR_1EC8:
    NStr    " CTRL: CMD CNT:%08ld CRC ERRS:%03ld LEN ERRS:%03ld BUF MAX:%05ld BUF CNT:%05ld "
DATA_ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS_1EC9:
    NStr    "  %05ld: PEP:%ld REUSED CLU:%s DISPATCH ERRS:%03ld EDSTATE:%ld  "
Global_STR_TRUE_2:
    NStr    "TRUE"
Global_STR_FALSE_2:
    NStr    "FALSE"
ESQFUNC_BasePaletteRgbTriples:
    DC.B    0,0,3       ; Dark Blue
    DC.B    12,12,12    ; Light Gray
    DC.B    0,0,0       ; Black
    DC.B    12,12,0     ; Yellow
    DC.B    5,1,2       ; Dark Red/Brown
    DC.B    1,6,10      ; Cyan/Blue
    DC.B    5,5,5       ; Medium Gray
    DC.B    0,0,3       ; Dark Blue (Repeat of pen 0)
DATA_ESQFUNC_CONST_WORD_1ECD:
    DC.W    1
Global_STR_DF0_LOGO_LST:
    NStr    "df0:logo.lst"
Global_PTR_STR_DF0_LOGO_LST:
    DC.L    Global_STR_DF0_LOGO_LST
DATA_ESQFUNC_BSS_LONG_1ED0:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_BrushIniListHead/ESQIFF_GAdsBrushListHead/ESQIFF_LogoBrushListHead/ESQFUNC_PwBrushListHead   (brush list heads)
; TYPE: pointer/pointer/pointer/pointer
; PURPOSE: Head pointers for brush-node lists sourced from brush.ini, g.ads, logo.lst, and pw* tag tables.
; USED BY: ESQIFF_*, ESQFUNC_*, GCOMMAND_SaveBrushResult, CLEANUP_*, WDISP_*
; NOTES: Lists are freed/repopulated by BRUSH_* helpers during source refresh and mode transitions.
;------------------------------------------------------------------------------
ESQIFF_BrushIniListHead:
    DS.L    1
ESQIFF_GAdsBrushListHead:
    DS.L    1
ESQIFF_LogoBrushListHead:
    DS.L    1
ESQFUNC_PwBrushListHead:
    DS.L    1
Global_STR_GFX_G_ADS:
    NStr    "gfx:g.ads"
Global_PTR_STR_GFX_G_ADS:
    DC.L    Global_STR_GFX_G_ADS
DATA_ESQFUNC_STR_PWBRUSH_1ED7:
    NStr    "pwbrush"
DATA_ESQFUNC_STR_PWI1_1ED8:
    NStr    "pwi1"
DATA_ESQFUNC_STR_PWI2_1ED9:
    NStr    "pwi2"
DATA_ESQFUNC_STR_PWI3_1EDA:
    NStr    "pwi3"
DATA_ESQFUNC_STR_PWI4_1EDB:
    NStr    "pwi4"
DATA_ESQFUNC_STR_1EDC:
    Str     "pw"
DATA_ESQFUNC_STR_I5_1EDD:
    NStr    "i5"
;------------------------------------------------------------------------------
; SYM: ESQFUNC_PwBrushNamePtrTable   (weather-status brush-name pointer table)
; TYPE: array<u32 ptr>
; PURPOSE: Maps normalized brush index to brush-name strings used by brush lookup.
; USED BY: ESQIFF_DrawWeatherStatusOverlayIntoBrush, WDISP_DrawWeatherStatusOverlay
; NOTES: Callers normalize index with -1 before scaling by 4.
;------------------------------------------------------------------------------
ESQFUNC_PwBrushNamePtrTable:
DATA_ESQFUNC_CONST_LONG_1EDE:
    DC.L    DATA_ESQFUNC_STR_PWBRUSH_1ED7
DATA_ESQFUNC_CONST_LONG_1EDF:
    DC.L    DATA_ESQFUNC_STR_PWI1_1ED8
    DC.L    DATA_ESQFUNC_STR_PWI2_1ED9
    DC.L    DATA_ESQFUNC_STR_PWI3_1EDA
    DC.L    DATA_ESQFUNC_STR_PWI4_1EDB
    DC.L    DATA_ESQFUNC_STR_1EDC
Global_REF_LONG_GFX_G_ADS_FILESIZE:
    DS.L    1
Global_REF_LONG_GFX_G_ADS_DATA:
    DS.L    1
Global_REF_LONG_DF0_LOGO_LST_FILESIZE:
    DS.L    1
Global_REF_LONG_DF0_LOGO_LST_DATA:
    DS.L    1
DATA_ESQFUNC_BSS_WORD_1EE4:
    DS.W    1
    DS.B    1
DATA_ESQFUNC_BSS_BYTE_1EE5:
    DS.B    1
DATA_ESQFUNC_TAG_00_1EE6:
    NStr    "00"
DATA_ESQFUNC_TAG_11_1EE7:
    NStr    "11"
