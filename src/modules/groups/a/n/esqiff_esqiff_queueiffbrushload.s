    XDEF    _ESQIFF_QueueIffBrushLoad


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_QueueIffBrushLoad   (Queue weather-status brush load or render path)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1/D7
; CALLS:
;   _ESQIFF_JMPTBL_BRUSH_AllocBrushNode, _ESQIFF_JMPTBL_BRUSH_CloneBrushRecord, _ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess, _ESQIFF_JMPTBL_MEMORY_DeallocateMemory, _ESQIFF_JMPTBL_STRING_CompareNoCase, _ESQIFF_DrawWeatherStatusOverlayIntoBrush
; READS:
;   _Global_STR_ESQIFF_C_2, _PARSEINI_BannerBrushResourceHead, _CTASKS_PendingIffBrushDescriptor, _ESQIFF_BannerBrushResourceCursor, _ESQIFF_STR_WEATHER, _WDISP_WeatherStatusCountdown, _WDISP_WeatherStatusDigitChar
; WRITES:
;   _CTASKS_PendingIffBrushDescriptor, _WDISP_WeatherStatusBrushListHead, _CTASKS_IffTaskState, _ESQIFF_BannerBrushResourceCursor
; DESC:
;   Resolves next banner brush resource and either queues an async IFF brush load,
;   or allocates/clones a brush and renders weather-status overlay text immediately.
; NOTES:
;   Mode arg `2` keeps current resource cursor; other modes advance linked cursor.
;------------------------------------------------------------------------------
_ESQIFF_QueueIffBrushLoad:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7
    TST.L   _ESQIFF_BannerBrushResourceCursor
    BEQ.S   .seed_resource_cursor

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .skip_resource_seed

.seed_resource_cursor:
    MOVE.L  _PARSEINI_BannerBrushResourceHead,_ESQIFF_BannerBrushResourceCursor

.skip_resource_seed:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.W   .queue_standard_iff_task

    PEA     _ESQIFF_STR_WEATHER
    MOVE.L  _ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     _ESQIFF_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .render_weather_overlay_now

    MOVEQ   #2,D0
    CMP.L   D0,D7
    BNE.W   .queue_standard_iff_task

.render_weather_overlay_now:
    MOVE.B  _WDISP_WeatherStatusCountdown,D0
    MOVEQ   #0,D1
    CMP.B   D1,D0
    BLS.W   .finalize_and_advance_resource_cursor

    MOVE.W  _WDISP_WeatherStatusDigitChar,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BEQ.W   .finalize_and_advance_resource_cursor

    CLR.L   -(A7)
    MOVE.L  _ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,_CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #11,190(A0)
    MOVEA.L _CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #$280,128(A0)
    MOVEA.L _CTASKS_PendingIffBrushDescriptor,A0
    MOVE.W  #160,130(A0)
    MOVEA.L _CTASKS_PendingIffBrushDescriptor,A0
    MOVE.B  #3,136(A0)
    MOVE.L  _CTASKS_PendingIffBrushDescriptor,(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(PC)

    MOVE.L  D0,_WDISP_WeatherStatusBrushListHead
    MOVE.L  D0,(A7)
    BSR.W   _ESQIFF_DrawWeatherStatusOverlayIntoBrush

    PEA     238.W
    MOVE.L  _CTASKS_PendingIffBrushDescriptor,-(A7)
    PEA     724.W
    PEA     _Global_STR_ESQIFF_C_2
    JSR     _ESQIFF_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     24(A7),A7
    BRA.S   .finalize_and_advance_resource_cursor

.queue_standard_iff_task:
    TST.L   _ESQIFF_BannerBrushResourceCursor
    BEQ.S   .finalize_and_advance_resource_cursor

    TST.L   _ESQIFF_BannerBrushResourceCursor
    BEQ.S   .finalize_and_advance_resource_cursor

    CLR.L   -(A7)
    MOVE.L  _ESQIFF_BannerBrushResourceCursor,-(A7)
    JSR     _ESQIFF_JMPTBL_BRUSH_AllocBrushNode(PC)

    MOVE.L  D0,_CTASKS_PendingIffBrushDescriptor
    MOVEA.L D0,A0
    MOVE.B  #$6,190(A0)
    MOVE.W  #6,_CTASKS_IffTaskState
    JSR     _ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(PC)

    ADDQ.W  #8,A7

.finalize_and_advance_resource_cursor:
    MOVEQ   #2,D0
    CMP.L   D0,D7
    BEQ.S   .return

    MOVEA.L _ESQIFF_BannerBrushResourceCursor,A0
    MOVE.L  234(A0),_ESQIFF_BannerBrushResourceCursor

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======