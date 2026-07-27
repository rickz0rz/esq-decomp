    XDEF    BRUSH_StreamFontChunk


; Streams D6 bytes of font data into A3 in 2048-byte chunks.
;------------------------------------------------------------------------------
; FUNC: BRUSH_StreamFontChunk   (Routine at BRUSH_StreamFontChunk)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A2/A3/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _LVORead
; READS:
;   Global_REF_DOS_LIBRARY_2
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_StreamFontChunk:
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVE.L  32(A7),D7
    MOVE.L  36(A7),D6
    MOVE.L  40(A7),D5
    MOVEA.L 44(A7),A3
    MOVEA.L 48(A7),A2

    CMP.L   D5,D6
    BLE.S   .streamfont_args_valid

    MOVEQ   #-1,D0
    BRA.S   .return

.streamfont_args_valid:
    MOVE.L  D6,186(A2)

.streamfont_read_full_chunks_loop:
    CMPI.L  #2048,D6
    BLE.S   .streamfont_read_tail_chunk

    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  #2048,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMPI.L  #2048,D0
    BEQ.S   .streamfont_after_full_chunk

    MOVEQ   #-1,D0
    BRA.S   .return

.streamfont_after_full_chunk:
    ADDA.W  #2048,A3
    SUBI.L  #2048,D6
    BRA.S   .streamfont_read_full_chunks_loop

.streamfont_read_tail_chunk:
    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  D6,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   D3,D0
    BEQ.S   .streamfont_success

    MOVEQ   #-1,D0
    BRA.S   .return

.streamfont_success:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    RTS

;!======