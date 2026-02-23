; ========== KYBD.c ==========

Global_STR_KYBD_C:
    NStr    "KYBD.c"
    DS.W    1
DATA_KYBD_PATH_DF0_COLON_LOCAL_DOT_ADS_1FB6:
    DC.B    "df0:local.ads"
;------------------------------------------------------------------------------
; SYM: KYBD_CustomPaletteCaptureScratchBase   (ED palette-capture scratch base)
; TYPE: u8 (head of scratch region)
; PURPOSE: Start of ED capture scratch region before palette-table commit.
; USED BY: ED_CaptureKeySequence
; NOTES:
;   ED writes nibble-capture bytes via indexed stores from this base.
;   Downstream read path is not directly confirmed yet; keep conservative.
;------------------------------------------------------------------------------
KYBD_CustomPaletteCaptureScratchBase:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: KYBD_CustomPaletteTriplesRBase/KYBD_CustomPaletteTriplesGBase/KYBD_CustomPaletteTriplesBBase   (custom palette RGB triples)
; TYPE: u8[24] (interleaved RGB triplets for 8 pens)
; PURPOSE: Custom palette buffer used by ESC/ADS workflows and color parsing.
; USED BY: ED1_EnterEscMenu, LADFUNC_DrawTextAdsPreview, PARSEINI_ParseColorTable
; NOTES:
;   Layout is contiguous and interleaved:
;     R(i) = KYBD_CustomPaletteTriplesRBase + i*3
;     G(i) = KYBD_CustomPaletteTriplesGBase + i*3
;     B(i) = KYBD_CustomPaletteTriplesBBase + i*3
;   Total size is 24 bytes (8 * RGB).
;------------------------------------------------------------------------------
KYBD_CustomPaletteTriplesRBase:
    DC.B    0
KYBD_CustomPaletteTriplesGBase:
    DC.B    0
KYBD_CustomPaletteTriplesBBase:
    DC.B    3
    DC.B    12,12,12
    DC.B    0,0,0
    DC.B    12,12,0
    DC.B    5,1,2
    DC.B    1,6,10
    DC.B    5,5,5
    DC.B    0,0,3
