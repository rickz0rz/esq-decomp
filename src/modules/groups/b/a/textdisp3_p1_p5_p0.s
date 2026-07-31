    XDEF    _TEXTDISP_UpdateChannelRangeFlags


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_UpdateChannelRangeFlags   (Update channel range flags)
; ARGS:
;   none
; RET:
;   none
; CLOBBERS:
;   D0-D7
; CALLS:
;   _TEXTDISP_FindEntryMatchIndex
; READS:
;   _TEXTDISP_ChannelSourceMode, _TEXTDISP_PrimaryChannelCode/234E, _CLOCK_CurrentDayOfWeekIndex
; WRITES:
;   _TEXTDISP_BannerCharFallback, _TEXTDISP_BannerCharSelected
; DESC:
;   Validates current channel and updates flags used by text display.
; NOTES:
;   Falls back to defaults when channel is out of range.
;------------------------------------------------------------------------------
_TEXTDISP_UpdateChannelRangeFlags:
    LINK.W  A5,#-8
    MOVEM.L D2/D7,-(A7)
    MOVE.W  _TEXTDISP_ChannelSourceMode,D0
    SUBQ.W  #1,D0
    BNE.S   .use_alt_channel_source

    MOVE.L  #_TEXTDISP_PrimarySearchText,-4(A5)
    MOVE.W  _TEXTDISP_PrimaryChannelCode,D7
    BRA.S   .ensure_channel_default

.use_alt_channel_source:
    LEA     _TEXTDISP_SecondarySearchText,A0
    MOVE.W  _TEXTDISP_SecondaryChannelCode,D7
    MOVE.L  A0,-4(A5)

.ensure_channel_default:
    TST.W   D7
    BNE.S   .check_channel_range_primary

    MOVEQ   #48,D7

.check_channel_range_primary:
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BLT.S   .check_channel_range_alt

    MOVEQ   #67,D0
    CMP.W   D0,D7
    BLE.S   .channel_enabled

.check_channel_range_alt:
    MOVEQ   #72,D0
    CMP.W   D0,D7
    BLT.S   .fallback_defaults

    MOVEQ   #77,D0
    CMP.W   D0,D7
    BGT.S   .fallback_defaults

.channel_enabled:
    MOVE.L  D7,D0
    EXT.L   D0
    LEA     _Global_STR_TEXTDISP_C_3,A0
    ADDA.L  D0,A0
    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    MOVEQ   #1,D1
    MOVE.L  D1,D2
    ASL.L   D0,D2
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    AND.L   D2,D0
    TST.L   D0
    BEQ.S   .fallback_defaults

    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _TEXTDISP_FindEntryMatchIndex

    LEA     12(A7),A7
    MOVE.B  D0,_TEXTDISP_BannerCharFallback
    BRA.S   .return

.fallback_defaults:
    MOVE.B  #$64,_TEXTDISP_BannerCharSelected
    MOVE.B  #$31,_TEXTDISP_BannerCharFallback

.return:
    MOVEM.L (A7)+,D2/D7
    UNLK    A5
    RTS

;!======