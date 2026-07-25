    XDEF    _SCRIPT_ClearSearchTextsAndChannels

;------------------------------------------------------------------------------
; FUNC: _SCRIPT_ClearSearchTextsAndChannels   (ClearSearchTextsAndChannels)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode
; DESC:
;   Clears both search strings and both channel-code selectors.
;------------------------------------------------------------------------------
_SCRIPT_ClearSearchTextsAndChannels:
    MOVEQ   #0,D0
    MOVE.B  D0,_TEXTDISP_SecondarySearchText
    MOVE.B  D0,_TEXTDISP_PrimarySearchText
    MOVEQ   #0,D0
    MOVE.W  D0,_TEXTDISP_SecondaryChannelCode
    MOVE.W  D0,_TEXTDISP_PrimaryChannelCode
    RTS

;!======
