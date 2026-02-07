; ========== CLEANUP.c ==========

Global_STR_CLEANUP_C_1:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_2:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_3:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_4:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_5:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_6:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_7:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_8:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_9:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_10:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_11:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_12:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_13:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_14:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_15:
    NStr    "CLEANUP.c"
Global_STR_CLEANUP_C_16:
    NStr    "CLEANUP.c"
; Frame countdown for alert retry attempts.
CLEANUP_AlertCooldownTicks:
    DS.L    1
; Non-zero while CLEANUP_ProcessAlerts is running to avoid re-entry.
CLEANUP_AlertProcessingFlag:
    DS.L    1
; Counts down frames before cycling banner palette.
CLEANUP_BannerTickCounter:
    DC.L    $0000003c
