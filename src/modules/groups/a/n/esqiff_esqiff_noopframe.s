    XDEF    _ESQIFF_NoOpFrame


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_NoOpFrame   (Empty stack frame, no work)
; DESC:
;   Opens and closes a zero-size frame and returns. The disassembly documented
;   this block but gave it no label, so refbytes.py read it as the tail of
;   _ESQIFF_QueueIffBrushLoad and reported that function as 298 bytes, not 292.
;   The label is byte-neutral and needs no XDEF -- nothing outside the module
;   refers to it.
;------------------------------------------------------------------------------
_ESQIFF_NoOpFrame:
    LINK.W  A5,#0
    UNLK    A5
    RTS

;!======