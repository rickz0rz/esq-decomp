    XDEF    _Global_STR_LOCAVAIL_C_1
    XDEF    Global_STR_LOCAVAIL_C_2
    XDEF    Global_STR_LOCAVAIL_C_3
    XDEF    Global_STR_LOCAVAIL_C_4
    XDEF    Global_STR_LOCAVAIL_C_5
    XDEF    LOCAVAIL_TAG_FV
    XDEF    Global_STR_LOCAVAIL_C_6
    XDEF    LOCAVAIL_STR_YYLLZ_FilterGateCheck
    XDEF    LOCAVAIL_TAG_UVGTI
    XDEF    LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save
    XDEF    LOCAVAIL_STR_LA_VER_1_COLON_CURDAY
    XDEF    LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY
    XDEF    LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load
    XDEF    LOCAVAIL_STR_LA_VER
    XDEF    Global_STR_LOCAVAIL_C_7
    XDEF    Global_STR_LOCAVAIL_C_8
    XDEF    LOCAVAIL_STR_YYLLZ_FilterStateUpdate
    XDEF    _NEWGRID_MainRastPortPtr
    XDEF    _NEWGRID_HeaderRastPortPtr
    XDEF    _NEWGRID_GridResourcesInitializedFlag
; ========== LOCAVAIL.c ==========

_Global_STR_LOCAVAIL_C_1:
    NStr    "LOCAVAIL.c"
Global_STR_LOCAVAIL_C_2:
    NStr    "LOCAVAIL.c"
Global_STR_LOCAVAIL_C_3:
    NStr    "LOCAVAIL.c"
Global_STR_LOCAVAIL_C_4:
    NStr    "LOCAVAIL.c"
Global_STR_LOCAVAIL_C_5:
    NStr    "LOCAVAIL.c"
LOCAVAIL_TAG_FV:
    NStr    "FV"
Global_STR_LOCAVAIL_C_6:
    NStr    "LOCAVAIL.c"
LOCAVAIL_STR_YYLLZ_FilterGateCheck:
    NStr    "YyLlZ"
LOCAVAIL_TAG_UVGTI:
    NStr    "UVGTI"
LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Save:
    NStr    "DF0:LocAvail.dat"
LOCAVAIL_STR_LA_VER_1_COLON_CURDAY:
    NStr    "LA_VER_1:  curday"
LOCAVAIL_STR_LA_VER_1_COLON_NXTDAY:
    NStr    "LA_VER_1:  nxtday"
LOCAVAIL_PATH_DF0_COLON_LOCAVAIL_DOT_DAT_Load:
    NStr    "DF0:LocAvail.dat"
LOCAVAIL_STR_LA_VER:
    NStr    "LA_VER"
Global_STR_LOCAVAIL_C_7:
    NStr    "LOCAVAIL.c"
Global_STR_LOCAVAIL_C_8:
    NStr    "LOCAVAIL.c"
LOCAVAIL_STR_YYLLZ_FilterStateUpdate:
    NStr    "YyLlZ"
;------------------------------------------------------------------------------
; SYM: _NEWGRID_MainRastPortPtr/_NEWGRID_HeaderRastPortPtr   (grid rastport pointers)
; TYPE: pointer/pointer (RastPort)
; PURPOSE: Primary NEWGRID body rastport and secondary header/top-bar rastport.
; USED BY: NEWGRID_InitGridResources, _NEWGRID_DrawTopBorderLine, _CLEANUP_DrawGridTimeBanner, PARSEINI command font updates
; NOTES:
;   `_NEWGRID_MainRastPortPtr` binds to `_Global_REF_696_400_BITMAP`.
;   `_NEWGRID_HeaderRastPortPtr` binds to `WDISP_BannerGridBitmapStruct`.
;------------------------------------------------------------------------------
_NEWGRID_MainRastPortPtr:
    DS.L    1
_NEWGRID_HeaderRastPortPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _NEWGRID_GridResourcesInitializedFlag   (grid resource init guard)
; TYPE: u16
; PURPOSE: Guards NEWGRID resource allocation so init runs once per active session.
; USED BY: NEWGRID_InitGridResources, _NEWGRID_ShutdownGridResources
; NOTES: Set to 1 after successful init path, cleared during grid shutdown.
;------------------------------------------------------------------------------
_NEWGRID_GridResourcesInitializedFlag:
    DS.W    1
