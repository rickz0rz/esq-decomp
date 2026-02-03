;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_AllocRaster   (AllocRaster wrapper)
; ARGS:
;   stack +16: D7 = width
;   stack +20: D6 = height
; RET:
;   D0: raster pointer (or 0)
; CLOBBERS:
;   D0-D1/A6 ??
; CALLS:
;   _LVOAllocRaster
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   ??
; DESC:
;   Allocates a raster via graphics.library.
; NOTES:
;   ??
;------------------------------------------------------------------------------
UNKNOWN2B_AllocRaster:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  16(A5),D7   ; Width
    MOVE.L  20(A5),D6   ; Height

    MOVE.L  D7,D0       ; Width
    MOVE.L  D6,D1       ; Height
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOAllocRaster(A6)

    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_FreeRaster   (FreeRaster wrapper)
; ARGS:
;   stack +16: A3 = raster pointer
;   stack +20: D7 = width
;   stack +24: D6 = height
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D1/A6 ??
; CALLS:
;   _LVOFreeRaster
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   ??
; DESC:
;   Frees a raster via graphics.library.
; NOTES:
;   ??
;------------------------------------------------------------------------------
UNKNOWN2B_FreeRaster:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A3,-(A7)

    MOVEA.L 16(A5),A3
    MOVE.L  20(A5),D7
    MOVE.L  24(A5),D6

    MOVEA.L A3,A0
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOFreeRaster(A6)

    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_OpenFileWithAccessMode   (Open wrapper)
; ARGS:
;   stack +8: A3 = filename pointer
;   stack +12: D7 = access mode
; RET:
;   D0: file handle (or 0)
; CLOBBERS:
;   D0-D2/A6 ??
; CALLS:
;   _LVOOpen
; READS:
;   GLOB_REF_DOS_LIBRARY_2
; WRITES:
;   ??
; DESC:
;   Opens a file via dos.library using the provided access mode.
; NOTES:
;   ??
;------------------------------------------------------------------------------
UNKNOWN2B_OpenFileWithAccessMode:
    MOVEM.L D2/D6-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7

    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_190F   (Stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   none
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Empty stub.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_190F:
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1910   (Stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   none
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Empty stub.
; NOTES:
;   ??
;------------------------------------------------------------------------------
LAB_1910:
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1911   (Buffered write of string??)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: string length
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_1916
; READS:
;   -1074(A4), -1082(A4)
; WRITES:
;   -1074(A4), -1082(A4), -1086(A4)
; DESC:
;   Writes a NUL-terminated string into a buffer, flushing via LAB_1916 on overflow.
; NOTES:
;   Uses DBF-style loop over bytes until NUL.
;------------------------------------------------------------------------------
LAB_1911:
    MOVEM.L D6-D7/A3,-(A7)

    SetOffsetForStack 3

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L A3,A0

.incrementAddressForStringLength:
    TST.B   (A0)+
    BNE.S   .incrementAddressForStringLength

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D6   ; String length

.LAB_1913:
    MOVEQ   #0,D7
    MOVE.B  (A3)+,D7
    TST.L   D7
    BEQ.S   .LAB_1915

    SUBQ.L  #1,-1074(A4)
    BLT.S   .LAB_1914

    MOVEA.L -1082(A4),A0
    LEA     1(A0),A1
    MOVE.L  A1,-1082(A4)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_1913

.LAB_1914:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    PEA     -1086(A4)
    MOVE.L  D1,-(A7)
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1
    BRA.S   .LAB_1913

.LAB_1915:
    PEA     -1086(A4)
    PEA     -1.W
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1916   (Buffered putc/flush handler??)
; ARGS:
;   stack +8: D7 = byte or -1
;   stack +12: A3 = handle/struct pointer??
; RET:
;   D0: status or byte??
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_1A8E, LAB_1A34, LAB_19B3, LAB_1AA9, LAB_1934
; READS:
;   A3+4/8/12/16/20/24/26/27/28, -1124(A4), -640(A4)
; WRITES:
;   A3+4/8/12/27, -640(A4)
; DESC:
;   Handles buffered output, flushing or writing directly based on flags and mode.
; NOTES:
;   Booleanize pattern: SNE/NEG/EXT. Uses 0x1A/0x0D handling.
;------------------------------------------------------------------------------
LAB_1916:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)

    SetOffsetForStackAfterLink 20,6

    MOVE.L  .stackOffsetBytes+4(A7),D7
    MOVEA.L .stackOffsetBytes+8(A7),A3
    MOVE.L  D7,D4
    MOVEQ   #49,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1917

    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1917:
    BTST    #7,26(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    TST.L   20(A3)
    BNE.W   .LAB_191D

    BTST    #2,27(A3)
    BNE.S   .LAB_191D

    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVEQ   #-1,D1
    CMP.L   D1,D7
    BEQ.W   .return

    MOVE.L  A3,-(A7)
    JSR     LAB_1A8E(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .LAB_1918

    BSET    #5,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1918:
    BSET    #1,27(A3)
    TST.B   D6
    BEQ.S   .LAB_1919

    MOVE.L  20(A3),D0
    MOVE.L  D0,D1
    NEG.L   D1
    MOVE.L  D1,12(A3)
    BRA.S   .LAB_191A

.LAB_1919:
    MOVE.L  20(A3),D0
    MOVE.L  D0,12(A3)

.LAB_191A:
    SUBQ.L  #1,12(A3)
    BLT.S   .LAB_191B

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_191C

.LAB_191B:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_1916

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.LAB_191C:
    MOVE.L  D1,D0
    BRA.W   .return

.LAB_191D:
    BTST    #2,27(A3)
    BEQ.S   .LAB_1921

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .LAB_191E

    MOVEQ   #0,D0
    BRA.W   .return

.LAB_191E:
    MOVE.L  D7,D0
    MOVE.B  D0,-1(A5)
    TST.B   D6
    BEQ.S   .LAB_191F

    MOVEQ   #10,D1
    CMP.L   D1,D7
    BNE.S   .LAB_191F

    MOVEQ   #2,D1
    MOVE.L  D1,-(A7)
    PEA     LAB_1933(PC)
    MOVE.L  28(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .LAB_1920

.LAB_191F:
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  28(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

.LAB_1920:
    MOVEQ   #-1,D7
    BRA.W   .LAB_1928

.LAB_1921:
    BSET    #1,27(A3)
    TST.B   D6
    BEQ.S   .LAB_1924

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .LAB_1924

    ADDQ.L  #2,12(A3)
    MOVEQ   #10,D1
    CMP.L   D1,D7
    BNE.S   .LAB_1923

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.B  #$d,(A0)
    MOVE.L  12(A3),D1
    TST.L   D1
    BMI.S   .LAB_1922

    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   LAB_1916

    ADDQ.W  #8,A7

.LAB_1922:
    ADDQ.L  #1,12(A3)

.LAB_1923:
    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVE.L  12(A3),D1
    TST.L   D1
    BMI.W   .return

    MOVEQ   #-1,D7

.LAB_1924:
    MOVE.L  4(A3),D0
    SUB.L   16(A3),D0
    MOVE.L  D0,-16(A5)
    BEQ.S   .LAB_1927

    BTST    #6,26(A3)
    BEQ.S   .LAB_1926

    PEA     2.W
    CLR.L   -(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_19B3(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-20(A5)
    TST.B   D6
    BEQ.S   .LAB_1926

.LAB_1925:
    SUBQ.L  #1,-20(A5)
    BLT.S   .LAB_1926

    CLR.L   -(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_19B3(PC)

    PEA     1.W
    PEA     -3(A5)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1AA9(PC)

    LEA     24(A7),A7
    TST.L   -640(A4)
    BNE.S   .LAB_1926

    MOVE.B  -3(A5),D0
    MOVEQ   #26,D1
    CMP.B   D1,D0
    BEQ.S   .LAB_1925

.LAB_1926:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1A34(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .LAB_1928

.LAB_1927:
    MOVEQ   #0,D5

.LAB_1928:
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .LAB_1929

    BSET    #5,27(A3)
    BRA.S   .LAB_192A

.LAB_1929:
    CMP.L   -16(A5),D5
    BEQ.S   .LAB_192A

    BSET    #4,27(A3)

.LAB_192A:
    TST.B   D6
    BEQ.S   .LAB_192B

    MOVE.L  20(A3),D1
    MOVE.L  D1,D2
    NEG.L   D2
    MOVE.L  D2,12(A3)
    BRA.S   .LAB_192D

.LAB_192B:
    BTST    #2,27(A3)
    BEQ.S   .LAB_192C

    MOVEQ   #0,D1
    MOVE.L  D1,12(A3)
    BRA.S   .LAB_192D

.LAB_192C:
    MOVE.L  20(A3),D1
    MOVE.L  D1,12(A3)

.LAB_192D:
    MOVEA.L 16(A3),A0
    MOVE.L  A0,4(A3)
    CMP.L   D0,D7
    BEQ.S   .LAB_192F

    SUBQ.L  #1,12(A3)
    BLT.S   .LAB_192E

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .LAB_192F

.LAB_192E:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   LAB_1916

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.LAB_192F:
    MOVEQ   #48,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1930

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1930:
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .LAB_1931

    MOVEQ   #0,D0
    BRA.S   .return

.LAB_1931:
    MOVE.L  D4,D0

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1933   (Callback: MOVEP.W 0(A2)->D6)
; ARGS:
;   A2 = source pointer??
; RET:
;   D6: word loaded via MOVEP
; CLOBBERS:
;   D6
; CALLS:
;   none
; READS:
;   (A2)
; WRITES:
;   D6
; DESC:
;   Tiny helper used as a callback to read a word via MOVEP.
; NOTES:
;   Followed by padding word.
;------------------------------------------------------------------------------
LAB_1933:
    MOVEP.W 0(A2),D6
    DC.W    $0000

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: LAB_1934   (Buffered read/getc handler??)
; ARGS:
;   stack +8: A3 = handle/struct pointer??
; RET:
;   D0: byte or -1 on error/EOF
; CLOBBERS:
;   D0-D7/A0-A3 ??
; CALLS:
;   LAB_1916, LAB_1A8E, LAB_1AA9
; READS:
;   A3+4/8/16/20/24/26/27/28
; WRITES:
;   A3+4/8/20/27
; DESC:
;   Ensures buffer is ready and returns next byte, refilling as needed.
; NOTES:
;   Handles 0x1A and 0x0D specially; uses SNE/NEG/EXT booleanization.
;------------------------------------------------------------------------------
LAB_1934:
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    BTST    #7,26(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVEQ   #48,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1935

    CLR.L   8(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1935:
    BTST    #7,27(A3)
    BEQ.S   .LAB_1936

    BTST    #6,27(A3)
    BEQ.S   .LAB_1936

    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     LAB_1916(PC)

    ADDQ.W  #8,A7

.LAB_1936:
    TST.L   20(A3)
    BNE.S   .LAB_1938

    CLR.L   8(A3)
    BTST    #2,27(A3)
    BEQ.S   .LAB_1937

    MOVEQ   #1,D0
    MOVE.L  D0,20(A3)
    LEA     32(A3),A0
    MOVE.L  A0,16(A3)
    BRA.W   .LAB_193C

.LAB_1937:
    MOVE.L  A3,-(A7)
    JSR     LAB_1A8E(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .LAB_193C

    BSET    #5,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_1938:
    TST.B   D7
    BEQ.S   .LAB_193C

    ADDQ.L  #2,8(A3)
    MOVE.L  8(A3),D0
    TST.L   D0
    BGT.S   .LAB_193C

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D6
    MOVE.B  (A0),D6
    MOVE.L  D6,D0
    CMPI.L  #$1a,D0
    BEQ.S   .LAB_193A

    CMPI.L  #$d,D0
    BNE.S   .LAB_193B

    SUBQ.L  #1,8(A3)
    BLT.S   .LAB_1939

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.W   .return

.LAB_1939:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1934

    ADDQ.W  #4,A7
    BRA.W   .return

.LAB_193A:
    BSET    #4,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_193B:
    MOVE.L  D6,D0
    BRA.W   .return

.LAB_193C:
    BTST    #1,27(A3)
    BNE.S   .LAB_1941

    BSET    #0,27(A3)
    MOVE.L  20(A3),-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     LAB_1AA9(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   D5
    BPL.S   .LAB_193D

    BSET    #5,27(A3)

.LAB_193D:
    TST.L   D5
    BNE.S   .LAB_193E

    BSET    #4,27(A3)

.LAB_193E:
    TST.L   D5
    BLE.S   .LAB_1941

    TST.B   D7
    BEQ.S   .LAB_193F

    MOVE.L  D5,D0
    NEG.L   D0
    MOVE.L  D0,8(A3)
    BRA.S   .LAB_1940

.LAB_193F:
    MOVE.L  D5,8(A3)

.LAB_1940:
    MOVEA.L 16(A3),A0
    MOVE.L  A0,4(A3)

.LAB_1941:
    MOVEQ   #50,D0
    AND.L   24(A3),D0
    BEQ.S   .LAB_1944

    TST.B   D7
    BEQ.S   .LAB_1942

    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    BRA.S   .LAB_1943

.LAB_1942:
    MOVEQ   #0,D0
    MOVE.L  D0,8(A3)

.LAB_1943:
    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_1944:
    SUBQ.L  #1,8(A3)
    BLT.S   .LAB_1945

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.S   .return

.LAB_1945:
    MOVE.L  A3,-(A7)
    BSR.W   LAB_1934

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
