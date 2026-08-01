    XDEF    _KYBD_PATH_DF0_LOCAL_ADS
    XDEF    _KYBD_CustomPaletteCaptureScratchBase
    XDEF    _KYBD_CustomPaletteTriplesRBase
    XDEF    _KYBD_CustomPaletteTriplesGBase
_KYBD_PATH_DF0_LOCAL_ADS:
    DC.B    "df0:local.ads"
;------------------------------------------------------------------------------
; SYM: _KYBD_CustomPaletteCaptureScratchBase   (ED palette-capture scratch base)
; TYPE: u8 (head of scratch region)
; PURPOSE: Start of ED capture scratch region before palette-table commit.
; USED BY: _ED_CaptureKeySequence
; NOTES:
;   ED writes nibble-capture bytes via indexed stores from this base.
;   Downstream read path is not directly confirmed yet; keep conservative.
;------------------------------------------------------------------------------
_KYBD_CustomPaletteCaptureScratchBase:
    DS.B    1
;------------------------------------------------------------------------------
; SYM: _KYBD_CustomPaletteTriplesRBase/_KYBD_CustomPaletteTriplesGBase/_KYBD_CustomPaletteTriplesBBase   (custom palette RGB triples)
; TYPE: u8[24] (interleaved RGB triplets for 8 pens)
; PURPOSE: Custom palette buffer used by ESC/ADS workflows and color parsing.
; USED BY: _ED1_EnterEscMenu, LADFUNC_DrawTextAdsPreview, _PARSEINI_ParseColorTable
; NOTES:
;   Layout is contiguous and interleaved:
;     R(i) = _KYBD_CustomPaletteTriplesRBase + i*3
;     G(i) = _KYBD_CustomPaletteTriplesGBase + i*3
;     B(i) = _KYBD_CustomPaletteTriplesBBase + i*3
;   Total size is 24 bytes (8 * RGB).
;------------------------------------------------------------------------------
_KYBD_CustomPaletteTriplesRBase:
    DC.B    0
_KYBD_CustomPaletteTriplesGBase:
    DC.B    0