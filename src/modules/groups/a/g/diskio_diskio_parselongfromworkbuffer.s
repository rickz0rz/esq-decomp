    XDEF    _DISKIO_ParseLongFromWorkBuffer


;------------------------------------------------------------------------------
; FUNC: _DISKIO_ParseLongFromWorkBuffer   (Routine at _DISKIO_ParseLongFromWorkBuffer)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0
; CALLS:
;   _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   ffff
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_ParseLongFromWorkBuffer:
    LINK.W  A5,#-4

    BSR.S   _DISKIO_ConsumeCStringFromWorkBuffer

    MOVEA.W #$ffff,A0
    MOVE.L  D0,-4(A5)
    CMP.L   A0,D0
    BNE.S   .lab_03B7

    MOVE.L  A0,D0
    BRA.S   .return

.lab_03B7:
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AG_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

.return:
    UNLK    A5
    RTS

;!======