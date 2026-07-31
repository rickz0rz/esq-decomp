    XDEF    _Global_STR_CLEANUP_C_1
    XDEF    _Global_STR_CLEANUP_C_2
    XDEF    _Global_STR_CLEANUP_C_3
    XDEF    _Global_STR_CLEANUP_C_4
    XDEF    _Global_STR_CLEANUP_C_5
    XDEF    _Global_STR_CLEANUP_C_6
    XDEF    _Global_STR_CLEANUP_C_7
    XDEF    _Global_STR_CLEANUP_C_8
    XDEF    _Global_STR_CLEANUP_C_9
    XDEF    _Global_STR_CLEANUP_C_10
    XDEF    _Global_STR_CLEANUP_C_11
    XDEF    _Global_STR_CLEANUP_C_12
    XDEF    _Global_STR_CLEANUP_C_13
    XDEF    _Global_STR_CLEANUP_C_14
    XDEF    _Global_STR_CLEANUP_C_15
    XDEF    _Global_STR_CLEANUP_C_16
    XDEF    _CLEANUP_AlertCooldownTicks
    XDEF    _CLEANUP_AlertProcessingFlag
    XDEF    _CLEANUP_BannerTickCounter
; ========== CLEANUP.c ==========

_Global_STR_CLEANUP_C_1:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_2:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_3:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_4:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_5:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_6:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_7:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_8:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_9:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_10:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_11:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_12:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_13:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_14:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_15:
    NStr    "CLEANUP.c"
_Global_STR_CLEANUP_C_16:
    NStr    "CLEANUP.c"
; Frame countdown for alert retry attempts.
_CLEANUP_AlertCooldownTicks:
    DS.L    1
; Non-zero while _CLEANUP_ProcessAlerts is running to avoid re-entry.
_CLEANUP_AlertProcessingFlag:
    DS.L    1
; Counts down frames before cycling banner palette.
_CLEANUP_BannerTickCounter:
    DC.L    60
