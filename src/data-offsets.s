; Fixed offsets between DATA-section labels.
; Previously written inline as label-difference expressions, which resolved only
; because the whole program was a single assembly unit. All six operand labels
; live in SECTION S_1 (DATA), so each difference is link-invariant.
; Values verified against the reference build.
Offset_RastPort2_FromDisplayContextBase       = 8
Offset_TopazFontName_FromIntuitionLibraryRef  = 52
Offset_TopazGuardRastPortAnchor_FromTopazFont = 84
Offset_SecondaryLineHeadHiWord_FromTopazFont  = 184
; Offset of the CTRL bit-3 capture gate byte within the status packet the
; serial handler points A4 at. It lived inside app.s and resolved by accident
; while that module was one file; splitting ESQ_PollCtrlInput out of it made
; the reference cross-unit, and vasm silently drops XDEF of an equate.
ESQ_StatusPacket__Bit3CaptureGateChar         = 18
