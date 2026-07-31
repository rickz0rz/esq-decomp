    XDEF    _ED_UpdateAdNumberDisplay


;------------------------------------------------------------------------------
; FUNC: _ED_UpdateAdNumberDisplay   (Update ad number displayuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _DISPLIB_DisplayTextAtPosition,
;   _ED_UpdateActiveInactiveIndicator
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _ED_AdRecordPtrTable
; WRITES:
;   _ED_AdActiveFlag, _ED_ViewportOffset, _ED_AdDisplayResetFlag, _ED_AdDisplayStateLatchBlockB, _ED_ActiveIndicatorCachedState, _ED_AdDisplayStateLatchA
; DESC:
;   Displays the current ad number and resets editing state for the ad.
; NOTES:
;   Initializes _ED_AdActiveFlag based on the ad's active flag.
;   Local display buffer is 40 bytes (-40(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_UpdateAdNumberDisplay:

.adLabel = -40

    LINK.W  A5,#-40

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,-(A7)
    PEA     _Global_STR_AD_NUMBER_FORMATTED
    PEA     .adLabel(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .adLabel(A5)
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D0
    MOVE.L  D0,_ED_AdActiveFlag
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D1
    ASL.L   #2,D1
    LEA     _ED_AdRecordPtrTable,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.W  (A1),D1
    TST.W   D1
    BLE.S   .after_active_check

    MOVEQ   #1,D1
    MOVE.L  D1,_ED_AdActiveFlag

.after_active_check:
    MOVEQ   #1,D1
    MOVE.L  D1,_ED_AdDisplayResetFlag
    MOVE.L  D0,_ED_ViewportOffset
    MOVEQ   #-1,D0
    MOVE.L  D0,_ED_AdDisplayStateLatchBlockB
    MOVE.L  D0,_ED_ActiveIndicatorCachedState
    MOVE.L  D0,_ED_AdDisplayStateLatchA
    BSR.W   _ED_UpdateActiveInactiveIndicator

    UNLK    A5
    RTS

;!======