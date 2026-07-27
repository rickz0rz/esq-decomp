    XDEF    _DISKIO_GetFilesizeFromHandle


;------------------------------------------------------------------------------
; FUNC: _DISKIO_GetFilesizeFromHandle   (Routine at _DISKIO_GetFilesizeFromHandle)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A6/A7/D0/D1/D2/D3/D6
; CALLS:
;   _LVOSeek
; READS:
;   Global_REF_DOS_LIBRARY_2, OFFSET_BEGINNING, OFFSET_END
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_GetFilesizeFromHandle:
    MOVEM.L D2-D3/D6-D7,-(A7)

    SetOffsetForStack 4
    UseStackLong    MOVE.L,1,D7

    ; Jump to the end of the file.
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #(OFFSET_END),D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOSeek(A6)

    ; Seek to the current (end) of the file
    ; so that the oldPosition is set in D0
    MOVE.L  D7,D1
    MOVE.L  D2,D3   ; D2 is 0, so this is OFFSET_CURRENT
    JSR     _LVOSeek(A6)

    ; Copy the oldPosition to D6 then seek to the beginning
    ; of the file again.
    MOVE.L  D0,D6
    MOVE.L  D7,D1
    MOVEQ   #(OFFSET_BEGINNING),D3
    JSR     _LVOSeek(A6)

    ; Return the total size of the file in D0
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D2-D3/D6-D7
    RTS

;!======