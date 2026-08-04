; The dos.library name string that shared a module with ESQ_StartupEntry.
; It stays in ASSEMBLY on purpose: it lives in the CODE section in the
; original, reached with LEA <sym>(PC),A1, and a C string literal lands in
; `data`. AGENTS.md records that a DATA hunk which grows by even four bytes
; shifts every symbol after it and froze the display. Splitting it out is
; what lets the three FUNCTIONS become C.
    XDEF    _ESQ_STR_DosLibrary

_ESQ_STR_DosLibrary:
    NStr    "dos.library"
