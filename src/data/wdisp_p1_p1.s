    XDEF    Global_REF_DOS_LIBRARY_2
    XDEF    _DOSBase
    XDEF    WDISP_FMT_CTRLH_STATUS_MAX
; Through a bit of manual work, I was able to figure out this points to dos.library
_DOSBase:
Global_REF_DOS_LIBRARY_2:
    DS.L    55

    if includeCustomAriAssembly
; XDEF must stay inside the conditional: with includeCustomAriAssembly = 0 the
; label below does not exist, and exporting an undefined symbol is an error.
WDISP_FMT_CTRLH_STATUS_MAX:
    NStr    "CTRL H:%04ld Cnt:%ld CRC:%02x State:%ld Byte:%02x"
    endif
