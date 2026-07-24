; Fixed offsets between DATA-section labels.
; Previously written inline as label-difference expressions, which resolved only
; because the whole program was a single assembly unit. All six operand labels
; live in SECTION S_1 (DATA), so each difference is link-invariant.
; Values verified against the reference build.
Offset_RastPort2_FromDisplayContextBase       = 8
Offset_TopazFontName_FromIntuitionLibraryRef  = 52
Offset_TopazGuardRastPortAnchor_FromTopazFont = 84
Offset_SecondaryLineHeadHiWord_FromTopazFont  = 184
