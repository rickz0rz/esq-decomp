; -----------------------------------------------------------------------------
; Brush.c routines
; -----------------------------------------------------------------------------
; These helpers load, cache, and tear down raster brush assets that back the
; on-screen paint tools. The original binary exported them as unnamed entry
; points (LAB_xxxx). We keep the legacy symbols for reference but introduce
; descriptive aliases below to aid navigation while we continue annotating.
; -----------------------------------------------------------------------------
BRUSH_LoadColorTextFont:
    LINK.W  A5,#-16
    MOVEM.L D2-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3

    PEA     (MEMF_PUBLIC).W
    PEA     Struct_ColorTextFont_Size.W
    PEA     396.W
    PEA     GLOB_STR_BRUSH_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-14(A5)
    BNE.S   .LAB_010C

    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_010C:
    MOVEQ   #Struct_ColorTextFont_Size,D0
    CMP.L   D0,D6
    BLE.S   .LAB_010D

    MOVE.L  D0,-(A7)
    MOVE.L  -14(A5),-(A7)
    PEA     416.W
    PEA     GLOB_STR_BRUSH_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .return

.LAB_010D:
    MOVE.L  D7,D1
    MOVE.L  D6,D3
    MOVE.L  -14(A5),D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   D3,D0
    BEQ.S   .LAB_010E

    PEA     Struct_ColorTextFont_Size.W
    MOVE.L  D2,-(A7)
    PEA     431.W
    PEA     GLOB_STR_BRUSH_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_010E:
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    MOVE.L  -14(A5),-4(A5)

.LAB_010F:
    MOVE.L  D4,D0
    EXT.L   D0
    CMP.L   D6,D0
    BGE.S   .LAB_0112

    CLR.W   -10(A5)

.LAB_0110:
    CMPI.W  #3,-10(A5)
    BGE.S   .LAB_0111

    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0)+,D0
    ASR.L   #4,D0
    MOVEQ   #15,D1
    AND.L   D1,D0
    MOVE.B  D0,0(A3,D5.W)
    ADDQ.W  #1,D5
    MOVE.L  A0,-4(A5)
    ADDQ.W  #1,-10(A5)
    BRA.S   .LAB_0110

.LAB_0111:
    ADDQ.W  #3,D4
    BRA.S   .LAB_010F

.LAB_0112:
    PEA     96.W
    MOVE.L  -14(A5),-(A7)
    PEA     445.W
    PEA     GLOB_STR_BRUSH_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #1,D0

.return:
    MOVEM.L -44(A5),D2-D7/A3
    UNLK    A5
    RTS

;!======

; Streams D6 bytes of font data into A3 in 2048-byte chunks.
BRUSH_StreamFontChunk:
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)
    MOVE.L  32(A7),D7
    MOVE.L  36(A7),D6
    MOVE.L  40(A7),D5
    MOVEA.L 44(A7),A3
    MOVEA.L 48(A7),A2

    CMP.L   D5,D6
    BLE.S   .LAB_0115

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_0115:
    MOVE.L  D6,186(A2)

.LAB_0116:
    CMPI.L  #2048,D6
    BLE.S   .LAB_0118

    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  #2048,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMPI.L  #2048,D0
    BEQ.S   .LAB_0117

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_0117:
    ADDA.W  #2048,A3
    SUBI.L  #2048,D6
    BRA.S   .LAB_0116

.LAB_0118:
    MOVE.L  D7,D1
    MOVE.L  A3,D2
    MOVE.L  D6,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   D3,D0
    BEQ.S   .LAB_0119

    MOVEQ   #-1,D0
    BRA.S   .return

.LAB_0119:
    MOVEQ   #1,D0

.return:
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    RTS

;!======

; Walks the BRUSH list at (A3), releasing rasters and child allocations.
BRUSH_FreeBrushList:
    LINK.W  A5,#-20
    MOVEM.L D2-D3/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-16(A5)
    TST.L   (A3)
    BEQ.W   LAB_0122

    MOVE.L  (A3),-8(A5)

LAB_011C:
    TST.L   -8(A5)
    BEQ.W   LAB_0121

    MOVEA.L -8(A5),A0
    MOVE.L  368(A0),-12(A5)
    MOVEQ   #0,D6

LAB_011D:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BGE.S   LAB_011E

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,D3
    ADDI.L  #$90,D3
    MOVE.L  0(A0,D3.L),-(A7)
    PEA     549.W
    PEA     GLOB_STR_BRUSH_C_5
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D6
    BRA.S   LAB_011D

LAB_011E:
    MOVEA.L -8(A5),A0
    MOVE.L  364(A0),-16(A5)

LAB_011F:
    TST.L   -16(A5)
    BEQ.S   LAB_0120

    MOVEA.L -16(A5),A0
    MOVE.L  8(A0),-20(A5)
    PEA     12.W
    MOVE.L  A0,-(A7)
    PEA     561.W
    PEA     GLOB_STR_BRUSH_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -20(A5),-16(A5)
    BRA.S   LAB_011F

LAB_0120:
    PEA     372.W
    MOVE.L  -8(A5),-(A7)
    PEA     567.W
    PEA     GLOB_STR_BRUSH_C_7
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -12(A5),-8(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.W   LAB_011C

LAB_0121:
    MOVE.L  -8(A5),(A3)

LAB_0122:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

; Evaluate the tile slot a brush should occupy, adjusting bounds and offsets.
BRUSH_SelectBrushSlot:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 28(A5),A2

    MOVE.L  A3,D0
    BEQ.W   LAB_013D

    MOVE.L  D5,D0
    SUB.L   D7,D0
    MOVE.L  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  348(A3),D2
    CMP.L   D1,D2
    BLE.S   LAB_0128

    MOVE.L  D7,-4(A5)
    MOVE.L  356(A3),D1
    MOVEQ   #2,D3
    CMP.L   D3,D1
    BNE.S   LAB_0124

    MOVE.L  D2,D4
    SUB.L   D0,D4
    SUBQ.L  #1,D4
    MOVE.L  D4,-20(A5)
    BRA.W   LAB_012E

LAB_0124:
    MOVEQ   #1,D0
    CMP.L   D0,D1
    BNE.S   LAB_0127

    MOVE.L  D2,D4
    TST.L   D4
    BPL.S   LAB_0125

    ADDQ.L  #1,D4

LAB_0125:
    ASR.L   #1,D4
    MOVE.L  D5,D1
    SUB.L   D7,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   LAB_0126

    ADDQ.L  #1,D1

LAB_0126:
    ASR.L   #1,D1
    SUB.L   D1,D4
    MOVE.L  D4,-20(A5)
    BRA.S   LAB_012E

LAB_0127:
    MOVE.L  340(A3),D4
    MOVE.L  D4,-20(A5)
    BRA.S   LAB_012E

LAB_0128:
    MOVE.L  D5,D0
    SUB.L   D7,D0
    ADDQ.L  #1,D0
    CMP.L   D0,D2
    BGE.S   LAB_012D

    MOVE.L  340(A3),D0
    MOVE.L  D0,-20(A5)
    MOVE.L  356(A3),D1
    MOVEQ   #2,D3
    CMP.L   D3,D1
    BNE.S   LAB_0129

    MOVE.L  D5,D4
    SUB.L   D2,D4
    ADDQ.L  #1,D4
    MOVE.L  D4,-4(A5)
    BRA.S   LAB_012E

LAB_0129:
    SUBQ.L  #1,D1
    BNE.S   LAB_012C

    MOVE.L  D5,D1
    SUB.L   D7,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   LAB_012A

    ADDQ.L  #1,D1

LAB_012A:
    ASR.L   #1,D1
    ADD.L   D7,D1
    MOVE.L  D2,D4
    TST.L   D4
    BPL.S   LAB_012B

    ADDQ.L  #1,D4

LAB_012B:
    ASR.L   #1,D4
    SUB.L   D4,D1
    MOVE.L  D1,-4(A5)
    BRA.S   LAB_012E

LAB_012C:
    MOVE.L  D7,-4(A5)
    BRA.S   LAB_012E

LAB_012D:
    MOVE.L  340(A3),D0
    MOVE.L  D7,D1
    MOVE.L  D0,-20(A5)
    MOVE.L  D1,-4(A5)

LAB_012E:
    MOVE.L  24(A5),D0
    MOVE.L  D0,D1
    SUB.L   D6,D1
    MOVE.L  D1,D3
    ADDQ.L  #1,D3
    MOVE.L  352(A3),D4
    CMP.L   D3,D4
    BLE.S   LAB_0133

    MOVE.L  D6,-8(A5)
    MOVE.L  360(A3),D3
    MOVEQ   #2,D2
    CMP.L   D2,D3
    BNE.S   LAB_012F

    MOVE.L  D4,D0
    SUB.L   D1,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-24(A5)
    BRA.W   LAB_0139

LAB_012F:
    MOVEQ   #1,D1
    CMP.L   D1,D3
    BNE.S   LAB_0132

    MOVE.L  D4,D3
    TST.L   D3
    BPL.S   LAB_0130

    ADDQ.L  #1,D3

LAB_0130:
    ASR.L   #1,D3
    MOVE.L  D0,D4
    SUB.L   D6,D4
    ADDQ.L  #1,D4
    TST.L   D4
    BPL.S   LAB_0131

    ADDQ.L  #1,D4

LAB_0131:
    ASR.L   #1,D4
    SUB.L   D4,D3
    MOVE.L  D3,-24(A5)
    BRA.S   LAB_0139

LAB_0132:
    MOVE.L  344(A3),D2
    MOVE.L  D2,-24(A5)
    BRA.S   LAB_0139

LAB_0133:
    MOVE.L  D0,D1
    SUB.L   D6,D1
    ADDQ.L  #1,D1
    CMP.L   D1,D4
    BGE.S   LAB_0138

    MOVE.L  344(A3),D1
    MOVE.L  D1,-24(A5)
    MOVE.L  360(A3),D3
    MOVEQ   #2,D2
    CMP.L   D2,D3
    BNE.S   LAB_0134

    MOVE.L  D0,D1
    SUB.L   D4,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-8(A5)
    BRA.S   LAB_0139

LAB_0134:
    SUBQ.L  #1,D3
    BNE.S   LAB_0137

    MOVE.L  D0,D3
    SUB.L   D6,D3
    ADDQ.L  #1,D3
    TST.L   D3
    BPL.S   LAB_0135

    ADDQ.L  #1,D3

LAB_0135:
    ASR.L   #1,D3
    ADD.L   D6,D3
    MOVE.L  D4,D2
    TST.L   D2
    BPL.S   LAB_0136

    ADDQ.L  #1,D2

LAB_0136:
    ASR.L   #1,D2
    SUB.L   D2,D3
    MOVE.L  D3,-8(A5)
    BRA.S   LAB_0139

LAB_0137:
    MOVE.L  D6,-8(A5)
    BRA.S   LAB_0139

LAB_0138:
    MOVE.L  344(A3),D1
    MOVE.L  D6,D3
    MOVE.L  D1,-24(A5)
    MOVE.L  D3,-8(A5)

LAB_0139:
    MOVE.L  D5,D0
    SUB.L   D7,D0
    ADDQ.L  #1,D0
    MOVE.L  348(A3),D1
    CMP.L   D1,D0
    BLE.S   LAB_013A

    MOVE.L  D1,D0

LAB_013A:
    MOVE.L  24(A5),D1
    SUB.L   D6,D1
    ADDQ.L  #1,D1
    MOVEM.L D0,-12(A5)
    MOVE.L  352(A3),D2
    CMP.L   D2,D1
    BLE.S   LAB_013B

    MOVE.L  D2,D1

LAB_013B:
    LEA     136(A3),A0
    MOVE.L  D1,-16(A5)
    MOVE.L  32(A5),D2
    TST.L   D2
    BGT.S   LAB_013C

    MOVE.L  -24(A5),D2

LAB_013C:
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AD_JMPTBL_LAB_1ADA(PC)

LAB_013D:
    MOVEM.L -56(A5),D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Returns the first brush node for which LAB_1968 (predicate) reports success.
BRUSH_FindBrushByPredicate:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  (A2),-4(A5)

.LAB_013F:
    TST.L   -4(A5)
    BEQ.S   .LAB_0141

    MOVE.L  A3,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUP_AA_JMPTBL_LAB_1968(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .LAB_0140

    MOVE.L  -4(A5),D0
    BRA.S   .return

.LAB_0140:
    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .LAB_013F

.LAB_0141:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

; Walk the brush list and return the first entry whose type byte (offset 32) is 3.
BRUSH_FindType3Brush:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  (A3),-4(A5)
    MOVEQ   #0,D7

.LAB_0144:
    TST.L   -4(A5)
    BEQ.S   .LAB_0146

    TST.L   D7
    BNE.S   .LAB_0146

    MOVEQ   #3,D0
    MOVEA.L -4(A5),A0
    CMP.B   32(A0),D0
    BNE.S   .LAB_0145

    MOVEQ   #1,D7

.LAB_0145:
    TST.L   D7
    BNE.S   .LAB_0144

    MOVE.L  368(A0),-4(A5)
    BRA.S   .LAB_0144

.LAB_0146:
    TST.L   D7
    BEQ.S   .LAB_0147

    MOVEA.L -4(A5),A0
    BRA.S   .LAB_0148

.LAB_0147:
    SUBA.L  A0,A0

.LAB_0148:
    MOVE.L  A0,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

; Load every brush descriptor reachable via the singly linked list rooted at A3.
; Successful loads are appended to the list pointed at A2.
BRUSH_PopulateBrushList:
    LINK.W  A5,#-12
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    SUBA.L  A0,A0
    MOVE.L  A0,-12(A5)
    MOVE.L  A0,-8(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEQ   #1,D0
    MOVE.L  D0,BRUSH_LoadInProgressFlag
    JSR     _LVOPermit(A6)

    CLR.L   (A2)

.LAB_014A:
    MOVE.L  A3,D0
    BEQ.S   .LAB_014D

    MOVE.L  A3,-(A7)
    BSR.W   BRUSH_LoadBrushAsset

    MOVE.L  234(A3),-12(A5)
    PEA     238.W
    MOVE.L  A3,-(A7)
    PEA     845.W
    PEA     GLOB_STR_BRUSH_C_8
    MOVE.L  D0,-4(A5)
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEA.L -12(A5),A3
    TST.L   -4(A5)
    BEQ.S   .LAB_014A

    TST.L   (A2)
    BNE.S   .LAB_014B

    MOVEA.L -4(A5),A0
    MOVE.L  A0,(A2)
    BRA.S   .LAB_014C

.LAB_014B:
    MOVEA.L -4(A5),A0
    MOVEA.L -8(A5),A1
    MOVE.L  A0,368(A1)

.LAB_014C:
    MOVE.L  A0,-8(A5)
    BRA.S   .LAB_014A

.LAB_014D:
    CLR.L   LAB_1B1F
    MOVE.L  A2,-(A7)
    BSR.W   BRUSH_NormalizeBrushNames

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,BRUSH_LoadInProgressFlag
    JSR     _LVOPermit(A6)

    MOVEM.L -20(A5),A2-A3
    UNLK    A5
    RTS

;!======

; Release auxiliary allocations attached to each brush node in the list at A3.
BRUSH_FreeBrushResources:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)

    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVE.L  (A3),-8(A5)

.LAB_014F:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVEA.L -8(A5),A0
    MOVE.L  234(A0),-4(A5)
    PEA     238.W
    MOVE.L  A0,-(A7)
    PEA     887.W
    PEA     GLOB_STR_BRUSH_C_9
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -4(A5),-8(A5)
    BRA.S   .LAB_014F

.return:
    CLR.L   (A3)

    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

; Rewrite the brush filename strings in-place using GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator (path normaliser).
BRUSH_NormalizeBrushNames:
    LINK.W  A5,#-40
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  (A3),-4(A5)

.LAB_0152:
    TST.L   -4(A5)
    BEQ.S   .return

    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)
    MOVEA.L A0,A1
    LEA     -40(A5),A2

.LAB_0153:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .LAB_0153

    PEA     -40(A5)
    JSR     GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A0
    MOVEA.L -4(A5),A1

.LAB_0154:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0154

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .LAB_0152

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

; Open the brush file described by A3, load its ILBM payload, and prepare raster data.
BRUSH_LoadBrushAsset:
    LINK.W  A5,#-76
    MOVEM.L D2-D3/D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVEQ   #1,D5
    SUBA.L  A0,A0
    MOVEQ   #5,D0
    MOVE.L  D0,-54(A5)
    MOVE.L  #320,-58(A5)
    PEA     (MODE_OLDFILE).W
    MOVE.L  A3,-(A7)
    MOVE.L  A0,-50(A5)
    MOVE.L  A0,-46(A5)
    MOVE.L  A0,-16(A5)
    JSR     GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BEQ.W   .LAB_0159

    MOVE.L  D7,D1
    LEA     -64(A5),A0
    MOVE.L  A0,D2
    MOVEQ   #6,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    SUBQ.L  #6,D0
    BNE.W   .LAB_0159

    PEA     4.W
    PEA     LAB_1B34
    MOVE.L  D2,-(A7)
    JSR     GROUP_AA_JMPTBL_LAB_195B(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .LAB_0157

    MOVE.L  D7,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    BRA.S   .LAB_0159

; Seek to the start of the FORM payload and decode the ILBM image data.
.LAB_0157:
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #-1,D3
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOSeek(A6)

    ; Allocate 130k of memory
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  #130000,-(A7)
    PEA     977.W
    PEA     GLOB_STR_BRUSH_C_10
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-46(A5)
    MOVE.L  D0,-50(A5)
    TST.L   D0
    BEQ.S   .LAB_0158

    LEA     152(A3),A0
    LEA     32(A3),A1
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  #130000,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   PROCESS_ILBM_IMAGE

    LEA     24(A7),A7
    SUBQ.L  #1,D0
    BNE.S   .LAB_0158

    MOVEQ   #0,D5

.LAB_0158:
    MOVE.L  D7,D1
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.LAB_0159:
    BTST    #7,150(A3)
    BEQ.S   .LAB_015A

    MOVEQ   #4,D0
    MOVE.L  #640,D1
    MOVE.L  D0,-54(A5)
    MOVE.L  D1,-58(A5)

.LAB_015A:
    MOVEQ   #0,D0
    MOVE.B  136(A3),D0
    CMP.L   -54(A5),D0
    BGT.S   .LAB_015B

    MOVEQ   #0,D0
    MOVE.W  128(A3),D0
    CMP.L   -58(A5),D0
    BLE.S   .LAB_015F

.LAB_015B:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEQ   #0,D0
    MOVE.B  136(A3),D0
    CMP.L   -54(A5),D0
    BLE.S   .LAB_015C

    MOVEQ   #2,D1
    BRA.S   .LAB_015D

.LAB_015C:
    MOVEQ   #3,D1

.LAB_015D:
    MOVE.L  D1,BRUSH_PendingAlertCode      ; remember which cleanup alert to trigger
    MOVEQ   #0,D0
    MOVE.W  128(A3),D0
    MOVE.L  D0,BRUSH_SnapshotWidth
    MOVEQ   #0,D0
    MOVE.B  136(A3),D0
    MOVE.L  D0,BRUSH_SnapshotDepth
    MOVEA.L A3,A0
    LEA     BRUSH_SnapshotHeader,A1

.LAB_015E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_015E

    JSR     _LVOPermit(A6)

    MOVEQ   #1,D5

.LAB_015F:
    TST.L   D5
    BNE.W   .LAB_0178

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     372.W
    PEA     1064.W
    PEA     GLOB_STR_BRUSH_C_11
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   .LAB_0178

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.LAB_0160:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0160

    MOVEA.L -16(A5),A0
    ADDA.W  #176,A0
    LEA     128(A3),A1
    MOVEQ   #4,D0

.LAB_0161:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.LAB_0161

    MOVEA.L -16(A5),A0
    ADDA.W  #196,A0
    LEA     148(A3),A1
    MOVE.L  (A1)+,(A0)+
    MOVEA.L -16(A5),A0
    CLR.L   368(A0)
    LEA     136(A0),A1
    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVEA.L A1,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L -16(A5),A0
    MOVE.B  190(A3),32(A0)
    MOVE.L  194(A3),328(A0)
    MOVE.L  198(A3),332(A0)
    MOVE.L  202(A3),336(A0)
    MOVE.L  206(A3),340(A0)
    MOVE.L  210(A3),344(A0)
    MOVE.L  222(A3),356(A0)
    MOVE.L  226(A3),360(A0)
    MOVEQ   #0,D6

.LAB_0162:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .LAB_0163

    MOVE.L  D6,D0
    ASL.L   #3,D0
    MOVEA.L -16(A5),A0
    ADDA.L  D0,A0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    LEA     200(A0),A2
    LEA     152(A1),A0
    MOVE.L  (A0)+,(A2)+
    MOVE.L  (A0)+,(A2)+
    ADDQ.L  #1,D6
    BRA.S   .LAB_0162

.LAB_0163:
    MOVEA.L -16(A5),A0
    ADDA.W  #$21,A0
    LEA     191(A3),A1

.LAB_0164:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .LAB_0164

    MOVEA.L -16(A5),A0
    MOVE.L  230(A3),364(A0)
    TST.L   214(A3)
    BEQ.S   .LAB_0165

    MOVE.L  214(A3),348(A0)
    BRA.S   .LAB_0166

.LAB_0165:
    MOVEQ   #0,D0
    MOVE.W  176(A0),D0
    MOVE.L  D0,348(A0)

.LAB_0166:
    TST.L   218(A3)
    BEQ.S   .LAB_0167

    MOVE.L  218(A3),352(A0)
    BRA.S   .LAB_0168

.LAB_0167:
    MOVEQ   #0,D0
    MOVE.W  178(A0),D0
    MOVE.L  D0,352(A0)

.LAB_0168:
    MOVEQ   #0,D6

.LAB_0169:
    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BGE.W   .LAB_016D

    MOVEQ   #5,D0
    CMP.L   D0,D6
    BGE.W   .LAB_016D

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVE.L  D2,-(A7)                      ; Height
    MOVE.L  D1,-(A7)                      ; Width
    PEA     1134.W                        ; Line Number
    PEA     GLOB_STR_BRUSH_C_12           ; Calling file
    MOVE.L  D0,52(A7)
    MOVE.L  D0,48(A7)
    JSR     GROUP_AA_JMPTBL_UNKNOWN2B_AllocRaster(PC)

    LEA     16(A7),A7
    MOVE.L  36(A7),D1
    MOVE.L  D0,-42(A5,D1.L)
    MOVEA.L -16(A5),A0
    MOVE.L  32(A7),D1
    ADDI.L  #$90,D1
    MOVE.L  D0,0(A0,D1.L)
    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVE.L  D0,D1
    ADDI.L  #$90,D1
    TST.L   0(A0,D1.L)
    BNE.S   .LAB_016C

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.L   BRUSH_PendingAlertCode
    BNE.S   .LAB_016B

    MOVEQ   #1,D0
    MOVE.L  D0,BRUSH_PendingAlertCode      ; flag that cleanup should warn about oversized brushes
    MOVEA.L -16(A5),A0
    LEA     BRUSH_SnapshotHeader,A1

.LAB_016A:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_016A

.LAB_016B:
    JSR     _LVOPermit(A6)

    BRA.S   .LAB_016D

.LAB_016C:
    ADDQ.L  #1,D6
    BRA.W   .LAB_0169

.LAB_016D:
    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BNE.W   .LAB_0175

    LEA     36(A0),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L -16(A5),A0
    ADDA.W  #$88,A0
    MOVEA.L -16(A5),A1
    MOVE.L  A0,40(A1)
    MOVEQ   #0,D6

.LAB_016E:
    MOVEQ   #96,D0
    CMP.L   D0,D6
    BGE.S   .LAB_016F

    MOVEA.L -16(A5),A0
    MOVE.L  D6,D0
    ADDI.L  #$e8,D0
    MOVE.B  32(A3,D6.L),0(A0,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .LAB_016E

.LAB_016F:
    MOVEQ   #0,D0
    MOVE.W  128(A3),D0
    MOVEQ   #15,D1
    ADD.L   D1,D0
    MOVEQ   #16,D1
    JSR     GROUP_AG_JMPTBL_LAB_1A07(PC)

    ADD.L   D0,D0
    CLR.W   -18(A5)
    MOVE.W  D0,-22(A5)

.LAB_0170:
    MOVE.W  -18(A5),D0
    MOVEA.L -16(A5),A0
    CMP.W   178(A0),D0
    BGE.W   .LAB_0173

    CLR.W   -20(A5)

.LAB_0171:
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  136(A3),D1
    CMP.L   D1,D0
    BGE.S   .LAB_0172

    MOVE.W  -20(A5),D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.W  -22(A5),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVEA.L -16(A5),A0
    MOVE.L  D0,D2
    ADDI.L  #$90,D2
    MOVE.L  0(A0,D2.L),-(A7)
    MOVE.L  -46(A5),-(A7)
    JSR     ESQ_PackBitsDecode(PC)

    LEA     12(A7),A7
    MOVE.W  -20(A5),D1
    EXT.L   D1
    ASL.L   #2,D1
    MOVEA.L -16(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$90,D2
    MOVEA.L 0(A0,D2.L),A0
    ADDA.W  -22(A5),A0
    MOVEA.L -16(A5),A1
    MOVE.L  D1,D2
    ADDI.L  #$90,D2
    MOVE.L  A0,0(A1,D2.L)
    MOVE.L  D0,-46(A5)
    ADDQ.W  #1,-20(A5)
    BRA.S   .LAB_0171

.LAB_0172:
    ADDQ.W  #1,-18(A5)
    BRA.W   .LAB_0170

.LAB_0173:
    MOVEQ   #0,D6

.LAB_0174:
    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BGE.W   .LAB_0178

    MOVEQ   #5,D0
    CMP.L   D0,D6
    BGE.W   .LAB_0178

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVE.L  D0,D1
    ADDI.L  #$90,D1
    MOVE.L  -42(A5,D0.L),0(A0,D1.L)
    ADDQ.L  #1,D6
    BRA.S   .LAB_0174

.LAB_0175:
    MOVEA.L -16(A5),A0
    TST.B   184(A0)
    BEQ.S   .LAB_0177

    MOVEQ   #5,D0
    CMP.L   D0,D6
    BGE.S   .LAB_0177

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVE.L  D0,D1
    ADDI.L  #$90,D1
    TST.L   0(A0,D1.L)
    BEQ.S   .LAB_0176

    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,D3
    ADDI.L  #$90,D3
    MOVE.L  0(A0,D3.L),-(A7)
    PEA     1202.W
    PEA     GLOB_STR_BRUSH_C_13
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7

.LAB_0176:
    ADDQ.L  #1,D6
    BRA.S   .LAB_0175

.LAB_0177:
    PEA     372.W
    MOVE.L  -16(A5),-(A7)
    PEA     1205.W
    PEA     GLOB_STR_BRUSH_C_14
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   -16(A5)

.LAB_0178:
    MOVEQ   #11,D0
    CMP.B   190(A3),D0
    BNE.S   .LAB_017B

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     372.W
    PEA     1220.W
    PEA     GLOB_STR_BRUSH_C_15
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.S   .LAB_017B

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.LAB_0179:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0179

    MOVEA.L -16(A5),A0
    MOVE.B  190(A3),32(A0)
    LEA     176(A0),A1
    LEA     128(A3),A2
    MOVEQ   #4,D0

.LAB_017A:
    MOVE.L  (A2)+,(A1)+
    DBF     D0,.LAB_017A

    MOVEA.L -16(A5),A0
    ADDA.W  #196,A0
    LEA     148(A3),A1
    MOVE.L  (A1)+,(A0)+
    SUBA.L  A0,A0
    MOVEA.L -16(A5),A1
    MOVE.L  A0,368(A1)

.LAB_017B:
    TST.L   -50(A5)
    BEQ.S   .return

    MOVE.L  #130000,-(A7)
    MOVE.L  -50(A5),-(A7)
    PEA     1236.W
    PEA     GLOB_STR_BRUSH_C_16
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVE.L  -16(A5),D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Clone an in-memory brush definition, rebuilding its bitmap state.
BRUSH_CloneBrushRecord:
    LINK.W  A5,#-12
    MOVEM.L D2/D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -8(A5)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     372.W
    PEA     1248.W
    PEA     GLOB_STR_BRUSH_C_17
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   .return

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.LAB_017E:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_017E

    MOVEA.L -8(A5),A0
    ADDA.W  #$b0,A0
    LEA     128(A3),A1
    MOVEQ   #4,D0

.LAB_017F:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.LAB_017F

    MOVEA.L -8(A5),A0
    ADDA.W  #196,A0
    LEA     148(A3),A1
    MOVE.L  (A1)+,(A0)+
    MOVEA.L -8(A5),A0
    CLR.L   368(A0)
    LEA     136(A0),A1
    MOVEQ   #0,D0
    MOVE.B  184(A0),D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVEA.L A1,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitBitMap(A6)

    MOVEA.L -8(A5),A0
    MOVE.B  190(A3),32(A0)
    MOVE.L  194(A3),328(A0)
    MOVE.L  198(A3),332(A0)
    MOVE.L  202(A3),336(A0)
    MOVE.L  206(A3),340(A0)
    MOVE.L  210(A3),344(A0)
    MOVE.L  222(A3),356(A0)
    MOVE.L  226(A3),360(A0)
    MOVEQ   #0,D7

.LAB_0180:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .LAB_0181

    MOVE.L  D7,D0
    ASL.L   #3,D0
    MOVEA.L -8(A5),A0
    ADDA.L  D0,A0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    LEA     200(A0),A2
    LEA     152(A1),A0
    MOVE.L  (A0)+,(A2)+
    MOVE.L  (A0)+,(A2)+
    ADDQ.L  #1,D7
    BRA.S   .LAB_0180

.LAB_0181:
    MOVEA.L -8(A5),A0
    ADDA.W  #$21,A0
    LEA     191(A3),A1

.LAB_0182:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .LAB_0182

    MOVEA.L -8(A5),A0
    MOVE.L  230(A3),364(A0)
    TST.L   214(A3)
    BEQ.S   .LAB_0183

    MOVE.L  214(A3),348(A0)
    BRA.S   .LAB_0184

.LAB_0183:
    MOVEQ   #0,D0
    MOVE.W  176(A0),D0
    MOVE.L  D0,348(A0)

.LAB_0184:
    TST.L   218(A3)
    BEQ.S   .LAB_0185

    MOVE.L  218(A3),352(A0)
    BRA.S   .LAB_0186

.LAB_0185:
    MOVEQ   #0,D0
    MOVE.W  178(A0),D0
    MOVE.L  D0,352(A0)

.LAB_0186:
    MOVEQ   #0,D7

.LAB_0187:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D7
    BGE.W   .LAB_018B

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.W   .LAB_018B

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVE.L  D2,-(A7)                      ; Height
    MOVE.L  D1,-(A7)                      ; Width
    PEA     1302.W                        ; Line Number
    PEA     GLOB_STR_BRUSH_C_18           ; Calling file
    MOVE.L  D0,32(A7)
    JSR     GROUP_AA_JMPTBL_UNKNOWN2B_AllocRaster(PC)

    LEA     16(A7),A7
    MOVEA.L -8(A5),A0
    MOVE.L  16(A7),D1
    ADDI.L  #$90,D1
    MOVE.L  D0,0(A0,D1.L)
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVE.L  D0,D1
    ADDI.L  #$90,D1
    TST.L   0(A0,D1.L)
    BNE.S   .LAB_018A

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.L   BRUSH_PendingAlertCode
    BNE.S   .LAB_0189

    MOVEQ   #1,D0
    MOVE.L  D0,BRUSH_PendingAlertCode      ; capture snapshot so cleanup can restore UI hints
    MOVEA.L -8(A5),A0
    LEA     BRUSH_SnapshotHeader,A1

.LAB_0188:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_0188

.LAB_0189:
    JSR     _LVOPermit(A6)

    BRA.S   .LAB_018B

.LAB_018A:
    ADDQ.L  #1,D7
    BRA.W   .LAB_0187

.LAB_018B:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D7
    BNE.S   .return

    LEA     36(A0),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L -8(A5),A0
    ADDA.W  #$88,A0
    MOVEA.L -8(A5),A1
    MOVE.L  A0,40(A1)
    MOVEQ   #0,D7

.LAB_018C:
    MOVEQ   #96,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVEA.L -8(A5),A0
    MOVE.L  D7,D0
    ADDI.L  #232,D0
    MOVE.B  32(A3,D7.L),0(A0,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .LAB_018C

.return:
    MOVE.L  -8(A5),D0
    MOVEM.L (A7)+,D2/D7/A2-A3
    UNLK    A5
    RTS

;!======

; Allocate a linked brush node and splice it into the optional list at A2.
BRUSH_AllocBrushNode:
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     238.W
    PEA     1352.W
    PEA     GLOB_STR_BRUSH_C_19
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,BRUSH_LastAllocatedNode   ; expose allocation for cleanup/error handlers
    TST.L   D0
    BEQ.S   .LAB_0191

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.LAB_018F:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .LAB_018F

    MOVEQ   #1,D0
    MOVEA.L BRUSH_LastAllocatedNode,A0
    MOVE.L  D0,194(A0)
    CLR.B   190(A0)
    MOVEQ   #0,D0
    MOVE.L  D0,222(A0)
    MOVE.L  D0,226(A0)
    MOVE.L  A2,D0
    BEQ.S   .LAB_0190

    MOVE.L  A0,234(A2)

.LAB_0190:
    CLR.L   234(A0)

.LAB_0191:
    MOVE.L  BRUSH_LastAllocatedNode,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

; Convert a plane index (0-8) into the corresponding bitmask.
BRUSH_PlaneMaskForIndex:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    TST.L   D7
    BLE.S   .LAB_0193

    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   .LAB_0193

    MOVEQ   #1,D0
    ASL.L   D7,D0
    BRA.S   .LAB_0194

.LAB_0193:
    MOVEQ   #0,D0

.LAB_0194:
    MOVE.L  (A7)+,D7
    RTS

;!======

; Select a brush by its string label, updating BRUSH_SelectedNode.
BRUSH_SelectBrushByLabel:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L A3,A0
    LEA     BRUSH_LabelScratch,A1

LAB_0196:
    MOVE.B  (A0)+,(A1)+
    BNE.S   LAB_0196

    MOVE.L  LAB_1ED1,-4(A5)
    CLR.L   BRUSH_SelectedNode
    PEA     2.W
    PEA     LAB_1B3F
    MOVE.L  A3,-(A7)
    JSR     GROUP_AA_JMPTBL_LAB_195B(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   LAB_0197

    PEA     2.W
    PEA     LAB_1B40
    MOVE.L  A3,-(A7)
    JSR     GROUP_AA_JMPTBL_LAB_195B(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   LAB_0197

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -7(A5)
    JSR     LAB_0470(PC)

    LEA     12(A7),A7
    BRA.S   LAB_0198

LAB_0197:
    PEA     2.W
    PEA     LAB_1B41
    PEA     -7(A5)
    JSR     LAB_0470(PC)

    LEA     12(A7),A7

LAB_0198:
    CLR.B   -5(A5)

LAB_0199:
    TST.L   -4(A5)
    BEQ.S   LAB_019B

    MOVEA.L -4(A5),A0
    ADDA.W  #$21,A0
    PEA     2.W
    PEA     -7(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AA_JMPTBL_LAB_195B(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   LAB_019A

    MOVE.L  -4(A5),BRUSH_SelectedNode

LAB_019A:
    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   LAB_0199

LAB_019B:
    TST.L   BRUSH_SelectedNode
    BNE.S   LAB_019C

    PEA     LAB_1ED1
    PEA     LAB_1B42
    BSR.W   BRUSH_FindBrushByPredicate

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

LAB_019C:
    MOVEA.L BRUSH_SelectedNode,A0
    MOVE.L  A0,BRUSH_ScriptPrimarySelection   ; expose latest selection to script subsystem
    MOVE.L  A0,BRUSH_ScriptSecondarySelection ; and remember it as the fallback option
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

; Append brush node A2 to the tail of list A3 (tracking via offset 368).
BRUSH_AppendBrushNode:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BNE.S   .LAB_019E

    MOVEA.L A2,A3
    BRA.S   .LAB_01A1

.LAB_019E:
    MOVE.L  A3,-4(A5)

.LAB_019F:
    MOVEA.L -4(A5),A0
    TST.L   368(A0)
    BEQ.S   .LAB_01A0

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .LAB_019F

.LAB_01A0:
    MOVEA.L -4(A5),A0
    MOVE.L  A2,368(A0)

.LAB_01A1:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

; Remove the head brush from the list at 8(A5), returning the next node.
BRUSH_PopBrushHead:
    LINK.W  A5,#-4

    TST.L   8(A5)
    BNE.S   .LAB_01A3

    CLR.L   -4(A5)
    BRA.S   .LAB_01A4

.LAB_01A3:
    MOVEA.L 8(A5),A0
    MOVE.L  368(A0),-4(A5)
    PEA     1.W
    PEA     8(A5)
    BSR.W   BRUSH_FreeBrushList

    ADDQ.W  #8,A7

.LAB_01A4:
    MOVE.L  -4(A5),D0
    UNLK    A5
    RTS

