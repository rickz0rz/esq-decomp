    XDEF    _ED1_DrawStatusLine1


;------------------------------------------------------------------------------
; FUNC: _ED1_DrawStatusLine1   (Render status line 1uncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0
; CALLS:
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   _ESQPARS2_StateIndex, _WDISP_DisplayContextBase
; WRITES:
;   (none observed)
; DESC:
;   Formats and draws a status string in rastport 2.
; NOTES:
;   Local printf buffer is 41 bytes (-41(A5)..-1(A5).
;------------------------------------------------------------------------------
_ED1_DrawStatusLine1:

.statusLine   = -41

    LINK.W  A5,#-44

    MOVE.W  _ESQPARS2_StateIndex,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     _ED2_FMT_SCRSPD_PCT_D
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     210.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    UNLK    A5
    RTS

;!======