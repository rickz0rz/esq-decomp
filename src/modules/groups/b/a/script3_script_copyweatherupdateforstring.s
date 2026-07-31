    XDEF    _SCRIPT_CopyWeatherUpdateForString


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_CopyWeatherUpdateForString   (CopyWeatherUpdateForStringuncertain)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1/A3
; CALLS:
;   (none)
; READS:
;   _Global_STR_WEATHER_UPDATE_FOR
; WRITES:
;   outBuffer
; DESC:
;   Copies the "Weather Update For" string into outBuffer.
; NOTES:
;   Previously unlabeled; appears unused in current build.
;------------------------------------------------------------------------------
;   This block carried no label. The extract for whatever precedes it ran
;   on into it and reported that function as larger than it is. The label
;   below is byte-neutral and separates the two again. It is deliberately
;   not XDEF'd: no other module refers to it.
;------------------------------------------------------------------------------
_SCRIPT_CopyWeatherUpdateForString:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    LEA     _Global_STR_WEATHER_UPDATE_FOR,A0
    MOVEA.L A3,A1

.copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_loop

    MOVEA.L (A7)+,A3
    RTS

;!======