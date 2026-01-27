
GLB_STR_PLEASE_STANDBY_1:
    NStr    "Please Standby..."
GLOB_STR_ATTENTION_SYSTEM_ENGINEER_1:
    NStr    "ATTENTION! SYSTEM ENGINEER"
GLOB_STR_REPORT_CODE_ER003:
    NStr    "Report Code ER003 to TV Guide Technical Services."
GLOB_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE:
    NStr2   "YOU CANNOT RE-RUN THE SOFTWARE IN THIS MANNER.  PLEASE RE-BOOT!!",TextLineFeed
LAB_1AF4:
    DS.W    1
GLOB_STR_DISK_ERRORS_FORMATTED:
    NStr2   "Disk Errors: %ld",TextLineFeed
LAB_1AF6:
    DS.W    1
GLOB_STR_DISK_IS_FULL_FORMATTED:
    NStr    "Disk is %ld%% full"
LAB_1AF8:
    DS.W    1
LAB_1AF9:
    DS.W    1
LAB_1AFA:
    DS.W    1
LAB_1AFB:
    DS.W    1
LAB_1AFC:
    DS.W    1
LAB_1AFD:
    DS.W    1
LAB_1AFE:
    DS.L    2
LAB_1AFF:
    DS.L    2
LAB_1B00:
    DS.W    1
LAB_1B01:
    DS.B    1
LAB_1B02:
    DS.B    1
    DS.W    1
LAB_1B03:
    DS.W    1
LAB_1B04:
    DS.L    1
    DS.W    1
LAB_1B05:
    NStr    "?"
LAB_1B06:
    DS.L    1
LAB_1B07:
    DS.L    1
LAB_1B08:
    DS.L    1
LAB_1B09:
    DS.W    1
LAB_1B0A:
    DS.W    1
LAB_1B0B:
    DS.W    1
LAB_1B0C:
    DS.W    1
LAB_1B0D:
    DS.W    1
LAB_1B0E:
    DS.W    1
LAB_1B0F:
    DS.W    1
LAB_1B10:
    DS.W    1
LAB_1B11:
    DS.W    1
LAB_1B12:
    DS.W    1
LAB_1B13:
    DS.W    1
LAB_1B14:
    DS.W    1
LAB_1B15:
    DS.W    1
LAB_1B16:
    DS.W    1
LAB_1B17:
    DS.W    1
LAB_1B18:
    DS.L    2
    DS.W    1
LAB_1B19:
    DS.W    1
LAB_1B1A:
    DS.W    1
LAB_1B1B:
    DS.W    1
LAB_1B1C:
    DS.W    1
LAB_1B1D:
    DC.L    $001f001c,$001f001e,$001f001e,$001f001f
    DC.L    $001e001f,$001e001f,$001f001d,$001f001e
    DC.L    $001f001e,$001f001f,$001e001f,$001e001f
LAB_1B1E:
    DC.L    $2728292a,$2b2c2d2e,$2f300102,$03040506
    DC.L    $0708090a,$0b0c0d0e,$0f101112,$13141516
    DC.L    $1718191a,$1b1c1d1e,$1f202122,$23242526
LAB_1B1F:
    DS.L    1
LAB_1B20:
    DS.L    1
LAB_1B21:
    DS.L    1
LAB_1B22:
    DS.L    1
LAB_1B23:
    DS.L    1
LAB_1B24:
    DS.L    1
LAB_1B25:
    DS.L    1
; Points to the most recently loaded brush node (shared across modules).
BRUSH_SelectedNode:
    DS.L    1
LAB_1B27:
    DS.L    1
LAB_1B28:
    DS.L    1
; Non-zero while BRUSH_PopulateBrushList is mutating the brush list.
BRUSH_LoadInProgressFlag:
    DS.L    1
; Tracks which cleanup alert message (if any) should be shown after brush loads.
BRUSH_PendingAlertCode:
    DS.L    1