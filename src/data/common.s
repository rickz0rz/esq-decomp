
GLB_STR_PLEASE_STANDBY_1:
    NStr    "Please Standby..."
GLOB_STR_ATTENTION_SYSTEM_ENGINEER_1:
    NStr    "ATTENTION! SYSTEM ENGINEER"
GLOB_STR_REPORT_CODE_ER003:
    NStr    "Report Code ER003 to TV Guide Technical Services."
GLOB_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE:
    NStr2   "YOU CANNOT RE-RUN THE SOFTWARE IN THIS MANNER.  PLEASE RE-BOOT!!",TextLineFeed
DATA_COMMON_BSS_WORD_1AF4:
    DS.W    1
GLOB_STR_DISK_ERRORS_FORMATTED:
    NStr2   "Disk Errors: %ld",TextLineFeed
DATA_COMMON_BSS_WORD_1AF6:
    DS.W    1
GLOB_STR_DISK_IS_FULL_FORMATTED:
    NStr    "Disk is %ld%% full"
DATA_COMMON_BSS_WORD_1AF8:
    DS.W    1
DATA_COMMON_BSS_WORD_1AF9:
    DS.W    1
DATA_COMMON_BSS_WORD_1AFA:
    DS.W    1
DATA_COMMON_BSS_WORD_1AFB:
    DS.W    1
DATA_COMMON_BSS_WORD_1AFC:
    DS.W    1
DATA_COMMON_BSS_WORD_1AFD:
    DS.W    1
DATA_COMMON_BSS_LONG_1AFE:
    DS.L    2
DATA_COMMON_BSS_LONG_1AFF:
    DS.L    2
DATA_COMMON_BSS_WORD_1B00:
    DS.W    1
DATA_COMMON_BSS_BYTE_1B01:
    DS.B    1
DATA_COMMON_BSS_BYTE_1B02:
    DS.B    1
    DS.W    1
DATA_COMMON_BSS_WORD_1B03:
    DS.W    1
DATA_COMMON_BSS_LONG_1B04:
    DS.L    1
    DS.W    1
DATA_COMMON_STR_VALUE_1B05:
    NStr    "?"
DATA_COMMON_BSS_LONG_1B06:
    DS.L    1
DATA_COMMON_BSS_LONG_1B07:
    DS.L    1
DATA_COMMON_BSS_LONG_1B08:
    DS.L    1
DATA_COMMON_BSS_WORD_1B09:
    DS.W    1
DATA_COMMON_BSS_WORD_1B0A:
    DS.W    1
DATA_COMMON_BSS_WORD_1B0B:
    DS.W    1
DATA_COMMON_BSS_WORD_1B0C:
    DS.W    1
DATA_COMMON_BSS_WORD_1B0D:
    DS.W    1
DATA_COMMON_BSS_WORD_1B0E:
    DS.W    1
DATA_COMMON_BSS_WORD_1B0F:
    DS.W    1
DATA_COMMON_BSS_WORD_1B10:
    DS.W    1
DATA_COMMON_BSS_WORD_1B11:
    DS.W    1
DATA_COMMON_BSS_WORD_1B12:
    DS.W    1
DATA_COMMON_BSS_WORD_1B13:
    DS.W    1
DATA_COMMON_BSS_WORD_1B14:
    DS.W    1
DATA_COMMON_BSS_WORD_1B15:
    DS.W    1
DATA_COMMON_BSS_WORD_1B16:
    DS.W    1
DATA_COMMON_BSS_WORD_1B17:
    DS.W    1
DATA_COMMON_BSS_LONG_1B18:
    DS.L    2
    DS.W    1
DATA_COMMON_BSS_WORD_1B19:
    DS.W    1
DATA_COMMON_BSS_WORD_1B1A:
    DS.W    1
DATA_COMMON_BSS_WORD_1B1B:
    DS.W    1
DATA_COMMON_BSS_WORD_1B1C:
    DS.W    1
DATA_COMMON_CONST_LONG_1B1D:
    DC.L    $001f001c,$001f001e,$001f001e,$001f001f
    DC.L    $001e001f,$001e001f,$001f001d,$001f001e
    DC.L    $001f001e,$001f001f,$001e001f,$001e001f
DATA_COMMON_CONST_LONG_1B1E:
    DC.L    $2728292a,$2b2c2d2e,$2f300102,$03040506
    DC.L    $0708090a,$0b0c0d0e,$0f101112,$13141516
    DC.L    $1718191a,$1b1c1d1e,$1f202122,$23242526
;------------------------------------------------------------------------------
; SYM: PARSEINI_ParsedDescriptorListHead ... WDISP_WeatherStatusBrushListHead   (brush descriptor/list head pointers)
; TYPE: pointer fields
; PURPOSE: Shared heads used for parsed brush descriptor chains, pending CTASKS handoff nodes, and weather-status brush lists.
; USED BY: PARSEINI_*, ESQIFF_*, ESQFUNC_*, CTASKS_IFFTaskCleanup, WDISP_*
; NOTES: Most entries are transient handoff pointers consumed by BRUSH_PopulateBrushList or task cleanup.
;------------------------------------------------------------------------------
PARSEINI_ParsedDescriptorListHead:
    DS.L    1
CTASKS_PendingLogoBrushDescriptor:
    DS.L    1
CTASKS_PendingGAdsBrushDescriptor:
    DS.L    1
ESQFUNC_PwBrushDescriptorHead:
    DS.L    1
PARSEINI_BannerBrushResourceHead:
    DS.L    1
CTASKS_PendingIffBrushDescriptor:
    DS.L    1
WDISP_WeatherStatusBrushListHead:
    DS.L    1
; Points to the most recently loaded brush node (shared across modules).
BRUSH_SelectedNode:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: ESQIFF_GAdsBrushListCount/ESQIFF_LogoBrushListCount   (brush list node counts)
; TYPE: u32/u32
; PURPOSE: Track active node counts in the G-Ads and Logo brush lists.
; USED BY: ESQIFF_*, ESQFUNC_*, GCOMMAND_SaveBrushResult
; NOTES: Counters are incremented on append and decremented on pop; selection paths gate on thresholds (G-Ads >=2, Logo >=1).
;------------------------------------------------------------------------------
ESQIFF_GAdsBrushListCount:
    DS.L    1
ESQIFF_LogoBrushListCount:
    DS.L    1
; Non-zero while BRUSH_PopulateBrushList is mutating the brush list.
BRUSH_LoadInProgressFlag:
    DS.L    1
; Tracks which cleanup alert message (if any) should be shown after brush loads.
BRUSH_PendingAlertCode:
    DS.L    1
