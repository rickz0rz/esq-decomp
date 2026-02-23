; ========== LOCAVAIL.c ==========

Global_STR_LOCAVAIL_C_1:
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
; SYM: NEWGRID_MainRastPortPtr/NEWGRID_HeaderRastPortPtr   (grid rastport pointers)
; TYPE: pointer/pointer (RastPort)
; PURPOSE: Primary NEWGRID body rastport and secondary header/top-bar rastport.
; USED BY: NEWGRID_InitGridResources, NEWGRID_DrawTopBorderLine, CLEANUP_DrawGridTimeBanner, PARSEINI command font updates
; NOTES:
;   `NEWGRID_MainRastPortPtr` binds to `Global_REF_696_400_BITMAP`.
;   `NEWGRID_HeaderRastPortPtr` binds to `WDISP_BannerGridBitmapStruct`.
;------------------------------------------------------------------------------
NEWGRID_MainRastPortPtr:
    DS.L    1
NEWGRID_HeaderRastPortPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: NEWGRID_GridResourcesInitializedFlag   (grid resource init guard)
; TYPE: u16
; PURPOSE: Guards NEWGRID resource allocation so init runs once per active session.
; USED BY: NEWGRID_InitGridResources, NEWGRID_ShutdownGridResources
; NOTES: Set to 1 after successful init path, cleared during grid shutdown.
;------------------------------------------------------------------------------
NEWGRID_GridResourcesInitializedFlag:
    DS.W    1
