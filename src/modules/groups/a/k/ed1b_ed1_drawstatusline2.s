    XDEF    _ED1_DrawStatusLine2


;------------------------------------------------------------------------------
; FUNC: _ED1_DrawStatusLine2   (Render status line 2uncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2
; CALLS:
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines, _LVOSetRast
; READS:
;   _WDISP_DisplayContextBase, _CONFIG_NicheModeCycleBudget_Y/1BA5/1BAD/1BB7/1BBD/1BBE/1BC9
; WRITES:
;   (none observed)
; DESC:
;   Formats and draws a multi-line status block in rastport 2.
; NOTES:
;   Local printf buffer is 51 bytes (-51(A5)..-1(A5), reused across three
;   _WDISP_SPrintf calls.
;------------------------------------------------------------------------------
_ED1_DrawStatusLine2:

.statusLine   = -51

    LINK.W  A5,#-52
    MOVE.L  D2,-(A7)
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #2,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVE.B  _CONFIG_NicheModeCycleBudget_Y,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.B  _CONFIG_NicheModeCycleBudget_Static,D1
    EXT.W   D1
    EXT.L   D1
    MOVE.B  _CONFIG_NicheModeCycleBudget_Custom,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     120.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.B  _CONFIG_ModeCycleEnabledFlag,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  _CONFIG_TimeWindowMinutes,(A7)
    MOVE.L  _CONFIG_ModeCycleGateDuration,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     150.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.B  _CTASKS_STR_1,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _Global_STR_CLOCKCMD_EQUALS_PCT_C
    PEA     .statusLine(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     68(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     180.W
    PEA     .statusLine(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.L  -56(A5),D2
    UNLK    A5
    RTS
