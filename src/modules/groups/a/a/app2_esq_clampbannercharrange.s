    XDEF    _ESQ_ClampBannerCharRange


;------------------------------------------------------------------------------
; FUNC: _ESQ_ClampBannerCharRange   (ClampBannerCharRangeuncertain)
; ARGS:
;   stack +4: value0
;   stack +8: value1
;   stack +12: value2
; RET:
;   (none)
; CLOBBERS:
;   D0-D4
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   _WDISP_BannerCharRangeStart, _WDISP_BannerCharRangeEnd
; DESC:
;   Normalizes values into a bounded A..C/I range and writes two globals.
; NOTES:
;   Heavily context-dependent; likely relates to banner character bounds.
;------------------------------------------------------------------------------
_ESQ_ClampBannerCharRange:
    MOVE.L  4(A7),D0
    MOVE.L  8(A7),D1
    MOVEA.L 12(A7),A0
    MOVEM.L D2-D4,-(A7)
    MOVE.L  A0,D2
    MOVEQ   #65,D3
    CMP.W   D3,D1
    BLT.S   .force_low_char

    MOVEQ   #67,D3
    CMP.W   D3,D1
    BLT.S   .force_high_char

.force_low_char:
    MOVEQ   #65,D1

.force_high_char:
    MOVEQ   #65,D3
    CMP.W   D3,D2
    BLT.S   .force_second_default

    MOVEQ   #73,D3
    CMP.W   D3,D2
    BLE.S   .normalize_chars

.force_second_default:
    MOVEQ   #69,D2

.normalize_chars:
    MOVEQ   #65,D3
    SUB.W   D3,D1
    SUB.W   D3,D2
    ADDQ.W  #1,D2
    MOVEQ   #48,D4
    MOVE.W  D0,D3
    TST.W   D1
    BEQ.S   .wrap_first_char

    SUB.W   D1,D0
    CMPI.W  #1,D0
    BGE.S   .wrap_first_char

    ADD.W   D4,D0

.wrap_first_char:
    ADD.W   D2,D3
    CMP.W   D4,D3
    BLE.S   .return

    SUB.W   D4,D3

.return:
    MOVE.W  D0,_WDISP_BannerCharRangeStart
    MOVE.W  D3,_WDISP_BannerCharRangeEnd
    MOVEM.L (A7)+,D2-D4
    RTS

;!======