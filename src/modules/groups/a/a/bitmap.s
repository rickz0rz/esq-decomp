;------------------------------------------------------------------------------
; FUNC: BITMAP_ProcessIlbmImage
; ARGS:
;   stack +8:  fileHandleuncertain (loaded into D7)
;   stack +16: outPtrOrCtxuncertain (loaded into A3)
;   stack +20: dataLenOrModeuncertain (loaded into D6)
;   stack +24: auxPtruncertain (loaded into A2)
;   stack +28: ilbmInfoPtruncertain (loaded into A0)
; RET:
;   D0: status/bytes from final parser read path
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   dos.library Read, BRUSH_LoadColorTextFont
; READS:
;   A0+128/130/148/151/184/190 uncertain
; WRITES:
;   A0+128/130/148/151/184 uncertain, local temps
; DESC:
;   Parses ILBM/IFF chunks from a DOS file handle and populates an ILBM info block.
; NOTES:
;   Marks error state in D5; clamps BMHD height in some modes; uses chunk tags
;   like 'FORM', 'ILBM', 'BMHD', 'CMAP'.
;------------------------------------------------------------------------------
; Process ILBM (IFF Interleaved Bitmap) Image
BITMAP_ProcessIlbmImage:
    LINK.W  A5,#-20
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)

    MOVE.L  8(A5),D7
    MOVEA.L 16(A5),A3
    MOVE.L  20(A5),D6
    MOVEA.L 24(A5),A2
    MOVEQ   #0,D5
    MOVEQ   #-1,D0
    MOVE.L  D0,-14(A5)
    MOVEA.L 28(A5),A0
    CLR.W   184(A0)        ; A0+184 = uncertain (cleared before parsing)
    CLR.L   -18(A5)

.clear_crng_table_loop:
    MOVE.L  -18(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .read_chunk_id

    ASL.L   #3,D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #$0000009c,D1
    CLR.W   0(A0,D1.L)
    ADDQ.L  #1,-18(A5)
    BRA.S   .clear_crng_table_loop

.read_chunk_id:
    MOVE.L  D7,D1
    LEA     -4(A5),A0
    MOVE.L  A0,D2
    MOVEQ   #4,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    SUBQ.L  #4,D0
    BEQ.S   .read_chunk_size

    MOVEQ   #1,D5
    BRA.W   .return_result

.read_chunk_size:
    CMPI.L  #'ILBM',-4(A5)
    BEQ.W   .continue_or_exit

    MOVE.L  D7,D1
    LEA     -8(A5),A0
    MOVE.L  A0,D2
    JSR     _LVORead(A6)

    SUBQ.L  #4,D0
    BEQ.S   .validate_chunk_size_nonzero

    MOVEQ   #1,D5
    BRA.W   .return_result

.validate_chunk_size_nonzero:
    TST.L   -8(A5)
    BNE.S   .validate_chunk_size_signed

    MOVEQ   #1,D5
    BRA.W   .return_result

.validate_chunk_size_signed:
    MOVE.L  -8(A5),D0
    TST.L   D0
    BPL.S   .dispatch_chunk_tag
    MOVEQ   #1,D5

    BRA.W   .return_result

.dispatch_chunk_tag:
    MOVE.L  -4(A5),D1
    CMPI.L  #'FORM',D1
    BEQ.W   .continue_or_exit

    CMPI.L  #'BMHD',D1
    BNE.W   .check_chunk_cmap
    MOVEQ   #20,D1      ; Size of the BMHD header

    CMP.L   D1,D0
    BEQ.S   .read_bmhd_payload

    MOVEQ   #1,D5

.read_bmhd_payload:
    MOVEA.L 28(A5),A0
    ADDA.W  #$0080,A0
    MOVE.L  D7,D1
    MOVE.L  A0,D2
    MOVEQ   #20,D3
    JSR     _LVORead(A6)
    CMP.L   D3,D0
    BEQ.S   .post_bmhd_read

    MOVEQ   #1,D5

.post_bmhd_read:
    MOVEQ   #0,D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,148(A0)
    CMPI.W  #$0140,128(A0)
    BLS.S   .clamp_bmhd_height

    BSET    #15,D0
    MOVE.L  D0,148(A0)

.clamp_bmhd_height:
    MOVE.W  130(A0),D0
    CMPI.W  #$00c8,D0
    BLS.S   .check_lowres_height_clamp

    BSET    #2,151(A0)
    CMPI.W  #$00dc,130(A0)
    BLS.W   .continue_or_exit

    MOVE.B  190(A0),D0
    MOVEQ   #5,D1
    CMP.B   D1,D0
    BEQ.S   .clamp_height_to_220

    MOVEQ   #4,D2
    CMP.B   D2,D0
    BNE.W   .continue_or_exit

.clamp_height_to_220:
    MOVE.W  #$00dc,D2
    MOVE.W  D2,130(A0)
    BRA.W   .continue_or_exit

.check_lowres_height_clamp:
    MOVEQ   #110,D1
    CMP.W   D1,D0
    BLS.W   .continue_or_exit

    MOVE.B  190(A0),D0
    MOVEQ   #5,D2
    CMP.B   D2,D0
    BEQ.S   .clamp_height_to_110

    SUBQ.B  #4,D0
    BNE.W   .continue_or_exit

.clamp_height_to_110:
    MOVE.W  D1,130(A0)
    BRA.W   .continue_or_exit

.check_chunk_cmap:
    CMPI.L  #'CMAP',D1
    BNE.S   .check_chunk_body

    MOVE.L  28(A5),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   BRUSH_LoadColorTextFont

    LEA     16(A7),A7
    SUBQ.L  #1,D0
    BEQ.W   .continue_or_exit

    MOVEQ   #1,D5
    BRA.W   .continue_or_exit

.check_chunk_body:
    CMPI.L  #'BODY',D1
    BNE.S   .check_chunk_camg

    MOVE.L  28(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   BRUSH_StreamFontChunk

    LEA     20(A7),A7
    SUBQ.L  #1,D0
    BNE.S   .after_body_stream

    MOVEQ   #1,D0
    MOVE.L  D0,-14(A5)

.after_body_stream:
    MOVEQ   #1,D5
    BRA.W   .continue_or_exit

.check_chunk_camg:
    CMPI.L  #'CAMG',D1
    BNE.S   .check_chunk_crng

    MOVEA.L 28(A5),A0
    CLR.L   148(A0)
    CMP.L   -8(A5),D3
    BEQ.S   .read_camg_mode

    MOVEQ   #1,D5

.read_camg_mode:
    LEA     148(A0),A1
    MOVE.L  D7,D1
    MOVE.L  A1,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    SUBQ.L  #4,D0
    BEQ.W   .continue_or_exit

    MOVEQ   #1,D5
    MOVEQ   #0,D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,148(A0)
    CMPI.W  #$0140,128(A0)
    BLS.S   .post_camg_fallback_flags

    BSET    #15,D0
    MOVE.L  D0,148(A0)

.post_camg_fallback_flags:
    CMPI.W  #$00c8,130(A0)
    BLS.W   .continue_or_exit

    BSET    #2,D0
    MOVE.L  D0,148(A0)
    BRA.W   .continue_or_exit

.check_chunk_crng:
    CMPI.L  #'CRNG',D1
    BNE.W   .seek_skip_unknown_chunk

    MOVEA.L 28(A5),A0
    MOVE.W  184(A0),D0
    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGE.W   .seek_skip_unknown_chunk

    MOVEQ   #8,D1
    CMP.L   -8(A5),D1
    BEQ.S   .read_crng_entry

    MOVEQ   #1,D5
    BRA.W   .continue_or_exit

.read_crng_entry:
    MOVE.L  D0,D2
    EXT.L   D2
    ASL.L   #3,D2
    ADDA.L  D2,A0
    LEA     152(A0),A1
    MOVE.L  D7,D1
    MOVE.L  A1,D2
    MOVEQ   #8,D3
    JSR     _LVORead(A6)

    SUBQ.L  #8,D0
    BEQ.S   .validate_crng_bounds

    MOVEQ   #1,D5

.validate_crng_bounds:
    MOVEA.L 28(A5),A0
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009e,D1
    CMPI.B  #$1f,0(A0,D1.L)
    BLS.S   .clamp_crng_low_nibble

    MOVEQ   #0,D1
    MOVE.L  D0,D2
    ADDI.L  #$0000009e,D2
    MOVE.B  D1,0(A0,D2.L)

.clamp_crng_low_nibble:
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009f,D1
    CMPI.B  #$1f,0(A0,D1.L)
    BLS.S   .validate_crng_high_nibble

    MOVE.L  D0,D1
    ADDI.L  #$0000009f,D1
    CLR.B   0(A0,D1.L)

.validate_crng_high_nibble:
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009a,D1
    MOVE.W  0(A0,D1.L),D1
    TST.W   D1
    BLE.S   .disable_crng_entry

    MOVEQ   #36,D1
    MOVE.L  D0,D2
    ADDI.L  #$0000009a,D2
    CMP.W   0(A0,D2.L),D1
    BEQ.S   .disable_crng_entry

    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009e,D1
    MOVE.B  0(A0,D1.L),D1
    MOVE.L  D0,D2
    ADDI.L  #$0000009f,D2
    CMP.B   0(A0,D2.L),D1
    BCS.S   .increment_crng_count

.disable_crng_entry:
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009c,D1
    CLR.W   0(A0,D1.L)

.increment_crng_count:
    ADDQ.W  #1,184(A0)
    BRA.S   .continue_or_exit

.seek_skip_unknown_chunk:
    MOVE.L  D7,D1
    MOVE.L  -8(A5),D2
    MOVEQ   #0,D3
    JSR     _LVOSeek(A6)

.continue_or_exit:
    TST.W   D5
    BEQ.W   .read_chunk_id

.return_result:
    MOVE.L  -14(A5),D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS
