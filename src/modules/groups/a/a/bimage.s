;------------------------------------------------------------------------------
; FUNC: PROCESS_ILBM_IMAGE   (ProcessIlbmImage)
; ARGS:
;   stack +8:  fileHandle?? (loaded into D7)
;   stack +16: outPtrOrCtx?? (loaded into A3)
;   stack +20: dataLenOrMode?? (loaded into D6)
;   stack +24: auxPtr?? (loaded into A2)
;   stack +28: ilbmInfoPtr?? (loaded into A0)
; RET:
;   D0: ?? (status/bytes??)
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   dos.library Read, BRUSH_LoadColorTextFont
; READS:
;   A0+128/130/148/151/184/190 ??
; WRITES:
;   A0+128/130/148/151/184 ??, local temps
; DESC:
;   Parses ILBM/IFF chunks from a DOS file handle and populates an ILBM info block.
; NOTES:
;   Marks error state in D5; clamps BMHD height in some modes; uses chunk tags
;   like 'FORM', 'ILBM', 'BMHD', 'CMAP'.
;------------------------------------------------------------------------------
; Process ILBM (IFF Interleaved Bitmap) Image
PROCESS_ILBM_IMAGE:
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
    CLR.W   184(A0)        ; A0+184 = ?? (cleared before parsing)
    CLR.L   -18(A5)

.LAB_00EF:
    MOVE.L  -18(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .LAB_00F0

    ASL.L   #3,D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,D1
    ADDI.L  #$0000009c,D1
    CLR.W   0(A0,D1.L)
    ADDQ.L  #1,-18(A5)
    BRA.S   .LAB_00EF

.LAB_00F0:
    MOVE.L  D7,D1
    LEA     -4(A5),A0
    MOVE.L  A0,D2
    MOVEQ   #4,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    SUBQ.L  #4,D0
    BEQ.S   .LAB_00F1

    MOVEQ   #1,D5
    BRA.W   .LAB_010A

.LAB_00F1:
    CMPI.L  #'ILBM',-4(A5)
    BEQ.W   .LAB_0109

    MOVE.L  D7,D1
    LEA     -8(A5),A0
    MOVE.L  A0,D2
    JSR     _LVORead(A6)

    SUBQ.L  #4,D0
    BEQ.S   .LAB_00F2

    MOVEQ   #1,D5
    BRA.W   .LAB_010A

.LAB_00F2:
    TST.L   -8(A5)
    BNE.S   .LAB_00F3

    MOVEQ   #1,D5
    BRA.W   .LAB_010A

.LAB_00F3:
    MOVE.L  -8(A5),D0
    TST.L   D0
    BPL.S   .LAB_00F4
    MOVEQ   #1,D5

    BRA.W   .LAB_010A

.LAB_00F4:
    MOVE.L  -4(A5),D1
    CMPI.L  #'FORM',D1
    BEQ.W   .LAB_0109

    CMPI.L  #'BMHD',D1
    BNE.W   .LAB_00FB
    MOVEQ   #20,D1      ; Size of the BMHD header

    CMP.L   D1,D0
    BEQ.S   .LAB_00F5

    MOVEQ   #1,D5

.LAB_00F5:
    MOVEA.L 28(A5),A0
    ADDA.W  #$0080,A0
    MOVE.L  D7,D1
    MOVE.L  A0,D2
    MOVEQ   #20,D3
    JSR     _LVORead(A6)
    CMP.L   D3,D0
    BEQ.S   .LAB_00F6

    MOVEQ   #1,D5

.LAB_00F6:
    MOVEQ   #0,D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,148(A0)
    CMPI.W  #$0140,128(A0)
    BLS.S   .LAB_00F7

    BSET    #15,D0
    MOVE.L  D0,148(A0)

.LAB_00F7:
    MOVE.W  130(A0),D0
    CMPI.W  #$00c8,D0
    BLS.S   .LAB_00F9

    BSET    #2,151(A0)
    CMPI.W  #$00dc,130(A0)
    BLS.W   .LAB_0109

    MOVE.B  190(A0),D0
    MOVEQ   #5,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_00F8

    MOVEQ   #4,D2
    CMP.B   D2,D0
    BNE.W   .LAB_0109

.LAB_00F8:
    MOVE.W  #$00dc,D2
    MOVE.W  D2,130(A0)
    BRA.W   .LAB_0109

.LAB_00F9:
    MOVEQ   #110,D1
    CMP.W   D1,D0
    BLS.W   .LAB_0109

    MOVE.B  190(A0),D0
    MOVEQ   #5,D2
    CMP.B   D2,D0
    BEQ.S   .LAB_00FA

    SUBQ.B  #4,D0
    BNE.W   .LAB_0109

.LAB_00FA:
    MOVE.W  D1,130(A0)
    BRA.W   .LAB_0109

.LAB_00FB:
    CMPI.L  #'CMAP',D1
    BNE.S   .LAB_00FC

    MOVE.L  28(A5),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   BRUSH_LoadColorTextFont

    LEA     16(A7),A7
    SUBQ.L  #1,D0
    BEQ.W   .LAB_0109

    MOVEQ   #1,D5
    BRA.W   .LAB_0109

.LAB_00FC:
    CMPI.L  #'BODY',D1
    BNE.S   .LAB_00FE

    MOVE.L  28(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   BRUSH_StreamFontChunk

    LEA     20(A7),A7
    SUBQ.L  #1,D0
    BNE.S   .LAB_00FD

    MOVEQ   #1,D0
    MOVE.L  D0,-14(A5)

.LAB_00FD:
    MOVEQ   #1,D5
    BRA.W   .LAB_0109

.LAB_00FE:
    CMPI.L  #'CAMG',D1
    BNE.S   .LAB_0101

    MOVEA.L 28(A5),A0
    CLR.L   148(A0)
    CMP.L   -8(A5),D3
    BEQ.S   .LAB_00FF

    MOVEQ   #1,D5

.LAB_00FF:
    LEA     148(A0),A1
    MOVE.L  D7,D1
    MOVE.L  A1,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    SUBQ.L  #4,D0
    BEQ.W   .LAB_0109

    MOVEQ   #1,D5
    MOVEQ   #0,D0
    MOVEA.L 28(A5),A0
    MOVE.L  D0,148(A0)
    CMPI.W  #$0140,128(A0)
    BLS.S   .LAB_0100

    BSET    #15,D0
    MOVE.L  D0,148(A0)

.LAB_0100:
    CMPI.W  #$00c8,130(A0)
    BLS.W   .LAB_0109

    BSET    #2,D0
    MOVE.L  D0,148(A0)
    BRA.W   .LAB_0109

.LAB_0101:
    CMPI.L  #'CRNG',D1
    BNE.W   .LAB_0108

    MOVEA.L 28(A5),A0
    MOVE.W  184(A0),D0
    MOVEQ   #4,D1
    CMP.W   D1,D0
    BGE.W   .LAB_0108

    MOVEQ   #8,D1
    CMP.L   -8(A5),D1
    BEQ.S   .LAB_0102

    MOVEQ   #1,D5
    BRA.W   .LAB_0109

.LAB_0102:
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
    BEQ.S   .LAB_0103

    MOVEQ   #1,D5

.LAB_0103:
    MOVEA.L 28(A5),A0
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009e,D1
    CMPI.B  #$1f,0(A0,D1.L)
    BLS.S   .LAB_0104

    MOVEQ   #0,D1
    MOVE.L  D0,D2
    ADDI.L  #$0000009e,D2
    MOVE.B  D1,0(A0,D2.L)

.LAB_0104:
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009f,D1
    CMPI.B  #$1f,0(A0,D1.L)
    BLS.S   .LAB_0105

    MOVE.L  D0,D1
    ADDI.L  #$0000009f,D1
    CLR.B   0(A0,D1.L)

.LAB_0105:
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009a,D1
    MOVE.W  0(A0,D1.L),D1
    TST.W   D1
    BLE.S   .LAB_0106

    MOVEQ   #36,D1
    MOVE.L  D0,D2
    ADDI.L  #$0000009a,D2
    CMP.W   0(A0,D2.L),D1
    BEQ.S   .LAB_0106

    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009e,D1
    MOVE.B  0(A0,D1.L),D1
    MOVE.L  D0,D2
    ADDI.L  #$0000009f,D2
    CMP.B   0(A0,D2.L),D1
    BCS.S   .LAB_0107

.LAB_0106:
    MOVE.W  184(A0),D0
    EXT.L   D0
    ASL.L   #3,D0
    MOVE.L  D0,D1
    ADDI.L  #$0000009c,D1
    CLR.W   0(A0,D1.L)

.LAB_0107:
    ADDQ.W  #1,184(A0)
    BRA.S   .LAB_0109

.LAB_0108:
    MOVE.L  D7,D1
    MOVE.L  -8(A5),D2
    MOVEQ   #0,D3
    JSR     _LVOSeek(A6)

.LAB_0109:
    TST.W   D5
    BEQ.W   .LAB_00F0

.LAB_010A:
    MOVE.L  -14(A5),D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS
