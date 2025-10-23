; ========== ESQFUNC.c ==========

GLOB_STR_ESQFUNC_C_1:
    NStr    "ESQFUNC.c"
GLOB_STR_VERTICAL_BLANK_INT:
    NStr    "Vertical Blank Int"
GLOB_STR_ESQFUNC_C_2:
    NStr    "ESQFUNC.c"
GLOB_STR_JOYSTICK_INT:
    NStr    "JoyStick Int"
GLOB_STR_ESQFUNC_C_3:
    NStr    "ESQFUNC.c"
GLOB_STR_ESQFUNC_C_4:
    NStr    "ESQFUNC.c"
GLOB_STR_RS232_RECEIVE_HANDLER:
    NStr    "RS232 Receive Handler"
GLOB_STR_ESQFUNC_C_5:
    NStr    "ESQFUNC.c"
GLOB_STR_ESQFUNC_C_6:
    NStr    "ESQFUNC.c"
GLOB_STR_DISK_0_IS_WRITE_PROTECTED:
    NStr    "Disk 0 is write protected"
GLOB_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0:
    NStr    "You MUST re-insert SYSTEM disk into drive 0!"

; Strings for: ESC -> Version Screen
GLOB_STR_BUILD_NUMBER_FORMATTED:
    NStr    "Build Number: '%ld%s'"
GLOB_STR_ROM_VERSION_FORMATTED:
    NStr    " ROM Version: '%s'"
GLOB_STR_ROM_VERSION_1_3:
    NStr    "1.3"
GLOB_STR_ROM_VERSION_2_04:
    NStr    "2.04"
GLOB_STR_PUSH_ANY_KEY_TO_CONTINUE_1:
    NStr    "Push any key to continue."

; Strings for: ESC -> Diagnostic Mode
GLOB_STR_DATA_CMDS_CERRS_LERRS:
    NStr    "DATA: Cmds:%08ld CErrs:%03ld LErrs:%03ld"
GLOB_STR_CTRL_CMDS_CERRS_LERRS:
    NStr    "CTRL: Cmds:%08ld CErrs:%03ld LErrs:%03ld"
GLOB_STR_L_CHIP_FAST_MAX:
    NStr    "L_CHIP:%7ld  FAST:%8ld  MAX:%8ld"
GLOB_STR_CHIP_PLACEHOLDER:
    NStr    "CHIP:%7ld                             "
GLOB_STR_FAST_PLACEHOLDER:
    NStr    "              FAST:%8ld              "
GLOB_STR_MAX_PLACEHOLDER:
    NStr    "                             MAX:%8ld"
GLOB_STR_MEMORY_TYPES_DISABLED:
    NStr    "Memory types disabled (use CTRL C/F/M/A)."
GLOB_STR_DATA_OVERRUNS_FORMATTED:
    NStr    "DATA Overruns: %ld"
GLOB_STR_DATA_H_T_C_MAX_FORMATTED:
    NStr    "DATA: H:%05ld  T:%05ld  C:%05ld  MAX:%05ld"
GLOB_STR_CTRL_H_T_C_MAX_FORMATTED:
    NStr    "CTRL: H:%05ld  T:%05ld  C:%05ld  MAX:%05ld"

GLOB_STR_JULIAN_DAY_NEXT_FORMATTED:
    NStr    "julian day = %3ld    next = %3ld"
GLOB_STR_JDAY1_JDAY2_FORMATTED:
    NStr    "jday1 = %3ld     jday2 =  %3ld"
GLOB_STR_CURCLU_NXTCLU_FORMATTED:
    NStr    " curclu =%2ld nxtclu =%2ld "
GLOB_STR_C_DATE_C_MONTH_LP_YR_FORMATTED:
    NStr    "C.date=%2ld C.month=%2ld lp=%4ld yr=%4ld"
GLOB_STR_B_DATE_B_MONTH_LP_YR_FORMATTED:
    NStr    "B.date=%2ld B.month=%2ld lp=%4ld yr=%4ld"
GLOB_STR_C_DST_B_DST_PSHIFT_FORMATTED:
    NStr    "C.dst =%2ld B.dst =%2ld pshift =%2ld"
GLOB_STR_C_HOUR_B_HOUR_CS_FORMATTED:
    NStr    "C.hour =%3ld B.hour =%3ld cs=%2ld"
LAB_1EB1:
    DS.L    1
LAB_1EB2:
    NStr    "VIDEO_INSERTION_INACTIVE"
LAB_1EB3:
    NStr    "VIDEO_INSERTION_START"
LAB_1EB4:
    NStr    "VIDEO_INSERTION_INPROGRESS"
LAB_1EB5:
    NStr    "VIDEO_INSERTION_STOP"
LAB_1EB6:
    DC.L    LAB_1EB2
    DC.L    LAB_1EB3
    DC.L    LAB_1EB4
    DC.L    LAB_1EB5
LAB_1EB7:
    NStr    "  CartSW: %s CartREL: %s VidSW: %s on_air: %s "
LAB_1EB8:
    NStr    "CLOSED (ENABLED)"
LAB_1EB9:
    NStr    "OPEN (DISABLED)"
LAB_1EBA:
    NStr    "CLOSED"
LAB_1EBB:
    NStr    "OPEN"
LAB_1EBC:
    NStr    "CLOSED (ON AIR)"
LAB_1EBD:
    NStr    "OPEN (OFF AIR)"
LAB_1EBE:
    NStr    "ON_AIR"
LAB_1EBF:
    NStr    "OFF_AIR"
LAB_1EC0:
    NStr    "NO_DETECT"
LAB_1EC1:
    NStr    " insertime = %s,  WINIT = 0x%04X "
LAB_1EC2:
    NStr    " local_mode=%ld local_update=%ld LA_(mode=%d state=%d curEv=%d) laCur(curType=%d curEvent=%d) "
LAB_1EC3:
    NStr    " CTime = %02d/%02d/%04d %2d:%02d:%02d%s, LATime = %04d "
LAB_1EC4:
    NStr    "pm"
LAB_1EC5:
    NStr    "am"
LAB_1EC6:
    NStr    " L_CHIP:%07ld  FAST:%08ld  MAX:%08ld "
LAB_1EC7:
    NStr    " DATA: CMD CNT:%08ld CRC ERRS:%03ld LEN ERRS:%03ld BUF MAX:%05ld BUF CNT:%05ld"
LAB_1EC8:
    NStr    " CTRL: CMD CNT:%08ld CRC ERRS:%03ld LEN ERRS:%03ld BUF MAX:%05ld BUF CNT:%05ld "
LAB_1EC9:
    NStr    "  %05ld: PEP:%ld REUSED CLU:%s DISPATCH ERRS:%03ld EDSTATE:%ld  "
GLOB_STR_TRUE_2:
    NStr    "TRUE"
GLOB_STR_FALSE_2:
    NStr    "FALSE"
LAB_1ECC:
    DC.L    $0000030c,$0c0c0000,$000c0c00,$05010201
    DC.L    $060a0505,$05000003
LAB_1ECD:
    DC.W    1
GLOB_STR_DF0_LOGO_LST:
    NStr    "df0:logo.lst"
GLOB_PTR_STR_DF0_LOGO_LST:
    DC.L    GLOB_STR_DF0_LOGO_LST
LAB_1ED0:
    DS.L    1
LAB_1ED1:
    DS.L    1
LAB_1ED2:
    DS.L    1
LAB_1ED3:
    DS.L    1
LAB_1ED4:
    DS.L    1
GLOB_STR_GFX_G_ADS:
    NStr    "gfx:g.ads"
GLOB_PTR_STR_GFX_G_ADS:
    DC.L    GLOB_STR_GFX_G_ADS
LAB_1ED7:
    NStr    "pwbrush"
LAB_1ED8:
    NStr    "pwi1"
LAB_1ED9:
    NStr    "pwi2"
LAB_1EDA:
    NStr    "pwi3"
LAB_1EDB:
    NStr    "pwi4"
LAB_1EDC:
    Str     "pw"
LAB_1EDD:
    NStr    "i5"
LAB_1EDE:
    DC.L    LAB_1ED7
LAB_1EDF:
    DC.L    LAB_1ED8
    DC.L    LAB_1ED9
    DC.L    LAB_1EDA
    DC.L    LAB_1EDB
    DC.L    LAB_1EDC
GLOB_REF_LONG_GFX_G_ADS_FILESIZE:
    DS.L    1
GLOB_REF_LONG_GFX_G_ADS_DATA:
    DS.L    1
GLOB_REF_LONG_DF0_LOGO_LST_FILESIZE:
    DS.L    1
GLOB_REF_LONG_DF0_LOGO_LST_DATA:
    DS.L    1
LAB_1EE4:
    DS.W    1
    DS.B    1
LAB_1EE5:
    DS.B    1
LAB_1EE6:
    NStr    "00"
LAB_1EE7:
    NStr    "11"
