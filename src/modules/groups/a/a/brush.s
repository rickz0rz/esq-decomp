; -----------------------------------------------------------------------------
; Brush.c routines
; -----------------------------------------------------------------------------
; These helpers load, cache, and tear down raster brush assets that back the
; on-screen paint tools. The original binary exported them as unnamed entry
; points (LAB_xxxx). We keep the legacy symbols for reference but introduce
; descriptive aliases below to aid navigation while we continue annotating.
; -----------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: BRUSH_LoadColorTextFont   (Routine at BRUSH_LoadColorTextFont)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +10: arg_4 (via 14(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +40: arg_6 (via 44(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVORead
; READS:
;   Global_REF_DOS_LIBRARY_2, Global_STR_BRUSH_C_1, Global_STR_BRUSH_C_2, Global_STR_BRUSH_C_3, Global_STR_BRUSH_C_4, MEMF_PUBLIC, Struct_ColorTextFont_Size, return
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_LoadColorTextFont:
    LINK.W  A5,#-16
    MOVEM.L D2-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3

    PEA     (MEMF_PUBLIC).W
    PEA     Struct_ColorTextFont_Size.W
    PEA     396.W
    PEA     Global_STR_BRUSH_C_1
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-14(A5)
    BNE.S   .font_alloc_ok

    MOVEQ   #-1,D0
    BRA.W   .return

.font_alloc_ok:
    MOVEQ   #Struct_ColorTextFont_Size,D0
    CMP.L   D0,D6
    BLE.S   .font_size_valid

    MOVE.L  D0,-(A7)
    MOVE.L  -14(A5),-(A7)
    PEA     416.W
    PEA     Global_STR_BRUSH_C_2
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.W   .return

.font_size_valid:
    MOVE.L  D7,D1
    MOVE.L  D6,D3
    MOVE.L  -14(A5),D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    CMP.L   D3,D0
    BEQ.S   .font_read_ok

    PEA     Struct_ColorTextFont_Size.W
    MOVE.L  D2,-(A7)
    PEA     431.W
    PEA     Global_STR_BRUSH_C_3
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #-1,D0
    BRA.S   .return

.font_read_ok:
    MOVEQ   #0,D5
    MOVEQ   #0,D4
    MOVE.L  -14(A5),-4(A5)

.font_unpack_outer_loop:
    MOVE.L  D4,D0
    EXT.L   D0
    CMP.L   D6,D0
    BGE.S   .font_free_temp_and_success

    CLR.W   -10(A5)

.font_unpack_nibble_triplet_loop:
    CMPI.W  #3,-10(A5)
    BGE.S   .font_unpack_next_triplet

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
    BRA.S   .font_unpack_nibble_triplet_loop

.font_unpack_next_triplet:
    ADDQ.W  #3,D4
    BRA.S   .font_unpack_outer_loop

.font_free_temp_and_success:
    PEA     96.W
    MOVE.L  -14(A5),-(A7)
    PEA     445.W
    PEA     Global_STR_BRUSH_C_4
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #1,D0

.return:
    MOVEM.L -44(A5),D2-D7/A3
    UNLK    A5
    RTS

;!======

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

; Walks the BRUSH list at (A3), releasing rasters and child allocations.
;------------------------------------------------------------------------------
; FUNC: BRUSH_FreeBrushList   (Routine at BRUSH_FreeBrushList)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_BRUSH_C_5, Global_STR_BRUSH_C_6, Global_STR_BRUSH_C_7, BRUSH_FreeBrushList_Return, branch, lab_0121
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_FreeBrushList:
    LINK.W  A5,#-20
    MOVEM.L D2-D3/D6-D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)
    MOVE.L  A0,-16(A5)
    TST.L   (A3)
    BEQ.W   BRUSH_FreeBrushList_Return

    MOVE.L  (A3),-8(A5)

.branch:
    TST.L   -8(A5)
    BEQ.W   .lab_0121

    MOVEA.L -8(A5),A0
    MOVE.L  368(A0),-12(A5)
    MOVEQ   #0,D6

.lab_011D:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BGE.S   .lab_011E

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
    PEA     Global_STR_BRUSH_C_5
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7
    ADDQ.L  #1,D6
    BRA.S   .lab_011D

.lab_011E:
    MOVEA.L -8(A5),A0
    MOVE.L  364(A0),-16(A5)

.branch_1:
    TST.L   -16(A5)
    BEQ.S   .branch_2

    MOVEA.L -16(A5),A0
    MOVE.L  8(A0),-20(A5)
    PEA     12.W
    MOVE.L  A0,-(A7)
    PEA     561.W
    PEA     Global_STR_BRUSH_C_6
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -20(A5),-16(A5)
    BRA.S   .branch_1

.branch_2:
    PEA     372.W
    MOVE.L  -8(A5),-(A7)
    PEA     567.W
    PEA     Global_STR_BRUSH_C_7
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -12(A5),-8(A5)
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.W   .branch

.lab_0121:
    MOVE.L  -8(A5),(A3)

;------------------------------------------------------------------------------
; FUNC: BRUSH_FreeBrushList_Return   (Routine at BRUSH_FreeBrushList_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_FreeBrushList_Return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    UNLK    A5
    RTS

;!======

; Evaluate the tile slot a brush should occupy, adjusting bounds and offsets.
;------------------------------------------------------------------------------
; FUNC: BRUSH_SelectBrushSlot   (Routine at BRUSH_SelectBrushSlot)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +28: arg_7 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
; READS:
;   BRUSH_SelectBrushSlot_Return, branch_12, lab_012E
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_SelectBrushSlot:
    LINK.W  A5,#-24
    MOVEM.L D2-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 28(A5),A2

    MOVE.L  A3,D0
    BEQ.W   BRUSH_SelectBrushSlot_Return

    MOVE.L  D5,D0
    SUB.L   D7,D0
    MOVE.L  D0,D1
    ADDQ.L  #1,D1
    MOVE.L  348(A3),D2
    CMP.L   D1,D2
    BLE.S   .lab_0128

    MOVE.L  D7,-4(A5)
    MOVE.L  356(A3),D1
    MOVEQ   #2,D3
    CMP.L   D3,D1
    BNE.S   .lab_0124

    MOVE.L  D2,D4
    SUB.L   D0,D4
    SUBQ.L  #1,D4
    MOVE.L  D4,-20(A5)
    BRA.W   .lab_012E

.lab_0124:
    MOVEQ   #1,D0
    CMP.L   D0,D1
    BNE.S   .lab_0127

    MOVE.L  D2,D4
    TST.L   D4
    BPL.S   .lab_0125

    ADDQ.L  #1,D4

.lab_0125:
    ASR.L   #1,D4
    MOVE.L  D5,D1
    SUB.L   D7,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .lab_0126

    ADDQ.L  #1,D1

.lab_0126:
    ASR.L   #1,D1
    SUB.L   D1,D4
    MOVE.L  D4,-20(A5)
    BRA.S   .lab_012E

.lab_0127:
    MOVE.L  340(A3),D4
    MOVE.L  D4,-20(A5)
    BRA.S   .lab_012E

.lab_0128:
    MOVE.L  D5,D0
    SUB.L   D7,D0
    ADDQ.L  #1,D0
    CMP.L   D0,D2
    BGE.S   .lab_012D

    MOVE.L  340(A3),D0
    MOVE.L  D0,-20(A5)
    MOVE.L  356(A3),D1
    MOVEQ   #2,D3
    CMP.L   D3,D1
    BNE.S   .lab_0129

    MOVE.L  D5,D4
    SUB.L   D2,D4
    ADDQ.L  #1,D4
    MOVE.L  D4,-4(A5)
    BRA.S   .lab_012E

.lab_0129:
    SUBQ.L  #1,D1
    BNE.S   .lab_012C

    MOVE.L  D5,D1
    SUB.L   D7,D1
    ADDQ.L  #1,D1
    TST.L   D1
    BPL.S   .branch

    ADDQ.L  #1,D1

.branch:
    ASR.L   #1,D1
    ADD.L   D7,D1
    MOVE.L  D2,D4
    TST.L   D4
    BPL.S   .branch_1

    ADDQ.L  #1,D4

.branch_1:
    ASR.L   #1,D4
    SUB.L   D4,D1
    MOVE.L  D1,-4(A5)
    BRA.S   .lab_012E

.lab_012C:
    MOVE.L  D7,-4(A5)
    BRA.S   .lab_012E

.lab_012D:
    MOVE.L  340(A3),D0
    MOVE.L  D7,D1
    MOVE.L  D0,-20(A5)
    MOVE.L  D1,-4(A5)

.lab_012E:
    MOVE.L  24(A5),D0
    MOVE.L  D0,D1
    SUB.L   D6,D1
    MOVE.L  D1,D3
    ADDQ.L  #1,D3
    MOVE.L  352(A3),D4
    CMP.L   D3,D4
    BLE.S   .branch_6

    MOVE.L  D6,-8(A5)
    MOVE.L  360(A3),D3
    MOVEQ   #2,D2
    CMP.L   D2,D3
    BNE.S   .branch_2

    MOVE.L  D4,D0
    SUB.L   D1,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-24(A5)
    BRA.W   .branch_12

.branch_2:
    MOVEQ   #1,D1
    CMP.L   D1,D3
    BNE.S   .branch_5

    MOVE.L  D4,D3
    TST.L   D3
    BPL.S   .branch_3

    ADDQ.L  #1,D3

.branch_3:
    ASR.L   #1,D3
    MOVE.L  D0,D4
    SUB.L   D6,D4
    ADDQ.L  #1,D4
    TST.L   D4
    BPL.S   .branch_4

    ADDQ.L  #1,D4

.branch_4:
    ASR.L   #1,D4
    SUB.L   D4,D3
    MOVE.L  D3,-24(A5)
    BRA.S   .branch_12

.branch_5:
    MOVE.L  344(A3),D2
    MOVE.L  D2,-24(A5)
    BRA.S   .branch_12

.branch_6:
    MOVE.L  D0,D1
    SUB.L   D6,D1
    ADDQ.L  #1,D1
    CMP.L   D1,D4
    BGE.S   .branch_11

    MOVE.L  344(A3),D1
    MOVE.L  D1,-24(A5)
    MOVE.L  360(A3),D3
    MOVEQ   #2,D2
    CMP.L   D2,D3
    BNE.S   .branch_7

    MOVE.L  D0,D1
    SUB.L   D4,D1
    ADDQ.L  #1,D1
    MOVE.L  D1,-8(A5)
    BRA.S   .branch_12

.branch_7:
    SUBQ.L  #1,D3
    BNE.S   .branch_10

    MOVE.L  D0,D3
    SUB.L   D6,D3
    ADDQ.L  #1,D3
    TST.L   D3
    BPL.S   .branch_8

    ADDQ.L  #1,D3

.branch_8:
    ASR.L   #1,D3
    ADD.L   D6,D3
    MOVE.L  D4,D2
    TST.L   D2
    BPL.S   .branch_9

    ADDQ.L  #1,D2

.branch_9:
    ASR.L   #1,D2
    SUB.L   D2,D3
    MOVE.L  D3,-8(A5)
    BRA.S   .branch_12

.branch_10:
    MOVE.L  D6,-8(A5)
    BRA.S   .branch_12

.branch_11:
    MOVE.L  344(A3),D1
    MOVE.L  D6,D3
    MOVE.L  D1,-24(A5)
    MOVE.L  D3,-8(A5)

.branch_12:
    MOVE.L  D5,D0
    SUB.L   D7,D0
    ADDQ.L  #1,D0
    MOVE.L  348(A3),D1
    CMP.L   D1,D0
    BLE.S   .branch_13

    MOVE.L  D1,D0

.branch_13:
    MOVE.L  24(A5),D1
    SUB.L   D6,D1
    ADDQ.L  #1,D1
    MOVEM.L D0,-12(A5)
    MOVE.L  352(A3),D2
    CMP.L   D2,D1
    BLE.S   .branch_14

    MOVE.L  D2,D1

.branch_14:
    LEA     136(A3),A0
    MOVE.L  D1,-16(A5)
    MOVE.L  32(A5),D2
    TST.L   D2
    BGT.S   .branch_15

    MOVE.L  -24(A5),D2

.branch_15:
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -8(A5),-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(PC)

;------------------------------------------------------------------------------
; FUNC: BRUSH_SelectBrushSlot_Return   (Routine at BRUSH_SelectBrushSlot_Return)
; ARGS:
;   stack +52: arg_1 (via 56(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_SelectBrushSlot_Return:
    MOVEM.L -56(A5),D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Returns the first brush node for which STRING_CompareNoCase (predicate) reports success.
;------------------------------------------------------------------------------
; FUNC: BRUSH_FindBrushByPredicate   (Routine at BRUSH_FindBrushByPredicate)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0
; CALLS:
;   GROUP_AA_JMPTBL_STRING_CompareNoCase
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_FindBrushByPredicate:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  (A2),-4(A5)

.findbrush_iterate_list:
    TST.L   -4(A5)
    BEQ.S   .findbrush_not_found

    MOVE.L  A3,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .findbrush_next_node

    MOVE.L  -4(A5),D0
    BRA.S   .return

.findbrush_next_node:
    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .findbrush_iterate_list

.findbrush_not_found:
    MOVEQ   #0,D0

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

; Walk the brush list and return the first entry whose type byte (offset 32) is 3.
;------------------------------------------------------------------------------
; FUNC: BRUSH_FindType3Brush   (Routine at BRUSH_FindType3Brush)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A5/A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_FindType3Brush:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  (A3),-4(A5)
    MOVEQ   #0,D7

.findtype3_scan_loop:
    TST.L   -4(A5)
    BEQ.S   .findtype3_after_scan

    TST.L   D7
    BNE.S   .findtype3_after_scan

    MOVEQ   #3,D0
    MOVEA.L -4(A5),A0
    CMP.B   32(A0),D0
    BNE.S   .findtype3_after_type_check

    MOVEQ   #1,D7

.findtype3_after_type_check:
    TST.L   D7
    BNE.S   .findtype3_scan_loop

    MOVE.L  368(A0),-4(A5)
    BRA.S   .findtype3_scan_loop

.findtype3_after_scan:
    TST.L   D7
    BEQ.S   .findtype3_not_found

    MOVEA.L -4(A5),A0
    BRA.S   .findtype3_return

.findtype3_not_found:
    SUBA.L  A0,A0

.findtype3_return:
    MOVE.L  A0,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

; Load every brush descriptor reachable via the singly linked list rooted at A3.
; Successful loads are appended to the list pointed at A2.
;------------------------------------------------------------------------------
; FUNC: BRUSH_PopulateBrushList   (Routine at BRUSH_PopulateBrushList)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +16: arg_3 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0
; CALLS:
;   BRUSH_LoadBrushAsset, BRUSH_NormalizeBrushNames, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVOForbid, _LVOPermit
; READS:
;   AbsExecBase, Global_STR_BRUSH_C_8
; WRITES:
;   BRUSH_LoadInProgressFlag, PARSEINI_ParsedDescriptorListHead
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
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

.populate_loop_next_descriptor:
    MOVE.L  A3,D0
    BEQ.S   .populate_finalize

    MOVE.L  A3,-(A7)
    BSR.W   BRUSH_LoadBrushAsset

    MOVE.L  234(A3),-12(A5)
    PEA     238.W
    MOVE.L  A3,-(A7)
    PEA     845.W
    PEA     Global_STR_BRUSH_C_8
    MOVE.L  D0,-4(A5)
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     20(A7),A7
    MOVEA.L -12(A5),A3
    TST.L   -4(A5)
    BEQ.S   .populate_loop_next_descriptor

    TST.L   (A2)
    BNE.S   .populate_append_to_tail

    MOVEA.L -4(A5),A0
    MOVE.L  A0,(A2)
    BRA.S   .populate_record_tail

.populate_append_to_tail:
    MOVEA.L -4(A5),A0
    MOVEA.L -8(A5),A1
    MOVE.L  A0,368(A1)

.populate_record_tail:
    MOVE.L  A0,-8(A5)
    BRA.S   .populate_loop_next_descriptor

.populate_finalize:
    CLR.L   PARSEINI_ParsedDescriptorListHead
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
;------------------------------------------------------------------------------
; FUNC: BRUSH_FreeBrushResources   (Routine at BRUSH_FreeBrushResources)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A5/A7
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_DeallocateMemory
; READS:
;   Global_STR_BRUSH_C_9
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_FreeBrushResources:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)

    MOVEA.L 8(A5),A3
    CLR.L   -4(A5)
    MOVE.L  (A3),-8(A5)

.free_resources_loop:
    TST.L   -8(A5)
    BEQ.S   .return

    MOVEA.L -8(A5),A0
    MOVE.L  234(A0),-4(A5)
    PEA     238.W
    MOVE.L  A0,-(A7)
    PEA     887.W
    PEA     Global_STR_BRUSH_C_9
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  -4(A5),-8(A5)
    BRA.S   .free_resources_loop

.return:
    CLR.L   (A3)

    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

; Rewrite the brush filename strings in-place using GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator (path normaliser).
;------------------------------------------------------------------------------
; FUNC: BRUSH_NormalizeBrushNames   (Routine at BRUSH_NormalizeBrushNames)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +36: arg_2 (via 40(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7
; CALLS:
;   GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_NormalizeBrushNames:
    LINK.W  A5,#-40
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  (A3),-4(A5)

.normalize_names_loop:
    TST.L   -4(A5)
    BEQ.S   .return

    MOVEA.L -4(A5),A0
    MOVE.L  A0,-8(A5)
    MOVEA.L A0,A1
    LEA     -40(A5),A2

.normalize_copy_to_scratch:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .normalize_copy_to_scratch

    PEA     -40(A5)
    JSR     GROUP_AA_JMPTBL_GCOMMAND_FindPathSeparator(PC)

    ADDQ.W  #4,A7
    MOVEA.L D0,A0
    MOVEA.L -4(A5),A1

.normalize_copy_back:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .normalize_copy_back

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .normalize_names_loop

.return:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

; Open the brush file described by A3, load its ILBM payload, and prepare raster data.
;------------------------------------------------------------------------------
; FUNC: BRUSH_LoadBrushAsset   (Routine at BRUSH_LoadBrushAsset)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +18: arg_5 (via 22(A5))
;   stack +42: arg_6 (via 46(A5))
;   stack +46: arg_7 (via 50(A5))
;   stack +50: arg_8 (via 54(A5))
;   stack +54: arg_9 (via 58(A5))
;   stack +60: arg_10 (via 64(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   BITMAP_ProcessIlbmImage, ESQ_PackBitsDecode, GROUP_AA_JMPTBL_STRING_CompareN, GROUP_AA_JMPTBL_UNKNOWN2B_AllocRaster, GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster, GROUP_AG_JMPTBL_MATH_DivS32, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, GROUP_AG_JMPTBL_UNKNOWN2B_OpenFileWithAccessMode, _LVOClose, _LVOForbid, _LVOInitBitMap, _LVOInitRastPort, _LVOPermit, _LVORead, _LVOSeek
; READS:
;   AbsExecBase, BRUSH_PendingAlertCode, BRUSH_SnapshotHeader, Global_REF_DOS_LIBRARY_2, Global_REF_GRAPHICS_LIBRARY, Global_STR_BRUSH_C_10, Global_STR_BRUSH_C_11, Global_STR_BRUSH_C_12, Global_STR_BRUSH_C_13, Global_STR_BRUSH_C_14, Global_STR_BRUSH_C_15, Global_STR_BRUSH_C_16, BRUSH_STR_IFF_FORM, MEMF_CLEAR, MEMF_PUBLIC, MODE_OLDFILE
; WRITES:
;   BRUSH_PendingAlertCode, BRUSH_SnapshotDepth, BRUSH_SnapshotWidth
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
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
    BEQ.W   .loadasset_after_file_stage

    MOVE.L  D7,D1
    LEA     -64(A5),A0
    MOVE.L  A0,D2
    MOVEQ   #6,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVORead(A6)

    SUBQ.L  #6,D0
    BNE.W   .loadasset_after_file_stage

    PEA     4.W
    PEA     BRUSH_STR_IFF_FORM
    MOVE.L  D2,-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .loadasset_form_header_ok

    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    BRA.S   .loadasset_after_file_stage

; Seek to the start of the FORM payload and decode the ILBM image data.
.loadasset_form_header_ok:
    MOVE.L  D7,D1
    MOVEQ   #0,D2
    MOVEQ   #-1,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOSeek(A6)

    ; Allocate 130k of memory
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  #130000,-(A7)
    PEA     977.W
    PEA     Global_STR_BRUSH_C_10
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-46(A5)
    MOVE.L  D0,-50(A5)
    TST.L   D0
    BEQ.S   .loadasset_after_ilbm_decode

    LEA     152(A3),A0
    LEA     32(A3),A1
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  #130000,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   BITMAP_ProcessIlbmImage

    LEA     24(A7),A7
    SUBQ.L  #1,D0
    BNE.S   .loadasset_after_ilbm_decode

    MOVEQ   #0,D5

.loadasset_after_ilbm_decode:
    MOVE.L  D7,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

.loadasset_after_file_stage:
    BTST    #7,150(A3)
    BEQ.S   .loadasset_after_mode_clamp

    MOVEQ   #4,D0
    MOVE.L  #640,D1
    MOVE.L  D0,-54(A5)
    MOVE.L  D1,-58(A5)

.loadasset_after_mode_clamp:
    MOVEQ   #0,D0
    MOVE.B  136(A3),D0
    CMP.L   -54(A5),D0
    BGT.S   .loadasset_reject_oversize

    MOVEQ   #0,D0
    MOVE.W  128(A3),D0
    CMP.L   -58(A5),D0
    BLE.S   .loadasset_allocate_brush_node

.loadasset_reject_oversize:
    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    MOVEQ   #0,D0
    MOVE.B  136(A3),D0
    CMP.L   -54(A5),D0
    BLE.S   .loadasset_alert_depth_exceeded

    MOVEQ   #2,D1
    BRA.S   .loadasset_capture_alert_snapshot

.loadasset_alert_depth_exceeded:
    MOVEQ   #3,D1

.loadasset_capture_alert_snapshot:
    MOVE.L  D1,BRUSH_PendingAlertCode      ; remember which cleanup alert to trigger
    MOVEQ   #0,D0
    MOVE.W  128(A3),D0
    MOVE.L  D0,BRUSH_SnapshotWidth
    MOVEQ   #0,D0
    MOVE.B  136(A3),D0
    MOVE.L  D0,BRUSH_SnapshotDepth
    MOVEA.L A3,A0
    LEA     BRUSH_SnapshotHeader,A1

.loadasset_copy_snapshot_header_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loadasset_copy_snapshot_header_loop

    JSR     _LVOPermit(A6)

    MOVEQ   #1,D5

.loadasset_allocate_brush_node:
    TST.L   D5
    BNE.W   .loadasset_maybe_clone_type11

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     372.W
    PEA     1064.W
    PEA     Global_STR_BRUSH_C_11
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.W   .loadasset_maybe_clone_type11

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.loadasset_copy_node_header_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loadasset_copy_node_header_loop

    MOVEA.L -16(A5),A0
    ADDA.W  #176,A0
    LEA     128(A3),A1
    MOVEQ   #4,D0

.loadasset_copy_bitmap_dims_loop:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.loadasset_copy_bitmap_dims_loop

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
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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

.loadasset_copy_row_offsets_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D6
    BGE.S   .loadasset_copy_label

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
    BRA.S   .loadasset_copy_row_offsets_loop

.loadasset_copy_label:
    MOVEA.L -16(A5),A0
    ADDA.W  #$21,A0
    LEA     191(A3),A1

.loadasset_copy_label_loop:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .loadasset_copy_label_loop

    MOVEA.L -16(A5),A0
    MOVE.L  230(A3),364(A0)
    TST.L   214(A3)
    BEQ.S   .loadasset_default_width_limit

    MOVE.L  214(A3),348(A0)
    BRA.S   .loadasset_after_width_limit

.loadasset_default_width_limit:
    MOVEQ   #0,D0
    MOVE.W  176(A0),D0
    MOVE.L  D0,348(A0)

.loadasset_after_width_limit:
    TST.L   218(A3)
    BEQ.S   .loadasset_default_height_limit

    MOVE.L  218(A3),352(A0)
    BRA.S   .loadasset_after_height_limit

.loadasset_default_height_limit:
    MOVEQ   #0,D0
    MOVE.W  178(A0),D0
    MOVE.L  D0,352(A0)

.loadasset_after_height_limit:
    MOVEQ   #0,D6

.loadasset_alloc_planes_loop:
    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BGE.W   .loadasset_after_plane_alloc

    MOVEQ   #5,D0
    CMP.L   D0,D6
    BGE.W   .loadasset_after_plane_alloc

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVE.L  D2,-(A7)                      ; Height
    MOVE.L  D1,-(A7)                      ; Width
    PEA     1134.W                        ; Line Number
    PEA     Global_STR_BRUSH_C_12           ; Calling file
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
    BNE.S   .loadasset_next_plane_alloc

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.L   BRUSH_PendingAlertCode
    BNE.S   .loadasset_alert_already_set

    MOVEQ   #1,D0
    MOVE.L  D0,BRUSH_PendingAlertCode      ; flag that cleanup should warn about oversized brushes
    MOVEA.L -16(A5),A0
    LEA     BRUSH_SnapshotHeader,A1

.loadasset_copy_snapshot_for_alert_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loadasset_copy_snapshot_for_alert_loop

.loadasset_alert_already_set:
    JSR     _LVOPermit(A6)

    BRA.S   .loadasset_after_plane_alloc

.loadasset_next_plane_alloc:
    ADDQ.L  #1,D6
    BRA.W   .loadasset_alloc_planes_loop

.loadasset_after_plane_alloc:
    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BNE.W   .loadasset_cleanup_partial_alloc

    LEA     36(A0),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L -16(A5),A0
    ADDA.W  #$88,A0
    MOVEA.L -16(A5),A1
    MOVE.L  A0,40(A1)
    MOVEQ   #0,D6

.loadasset_copy_palette_bytes_loop:
    MOVEQ   #96,D0
    CMP.L   D0,D6
    BGE.S   .loadasset_compute_row_word_span

    MOVEA.L -16(A5),A0
    MOVE.L  D6,D0
    ADDI.L  #$e8,D0
    MOVE.B  32(A3,D6.L),0(A0,D0.L)
    ADDQ.L  #1,D6
    BRA.S   .loadasset_copy_palette_bytes_loop

.loadasset_compute_row_word_span:
    MOVEQ   #0,D0
    MOVE.W  128(A3),D0
    MOVEQ   #15,D1
    ADD.L   D1,D0
    MOVEQ   #16,D1
    JSR     GROUP_AG_JMPTBL_MATH_DivS32(PC)

    ADD.L   D0,D0
    CLR.W   -18(A5)
    MOVE.W  D0,-22(A5)

.loadasset_decode_rows_loop:
    MOVE.W  -18(A5),D0
    MOVEA.L -16(A5),A0
    CMP.W   178(A0),D0
    BGE.W   .loadasset_restore_plane_ptrs

    CLR.W   -20(A5)

.loadasset_decode_planes_loop:
    MOVE.W  -20(A5),D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  136(A3),D1
    CMP.L   D1,D0
    BGE.S   .loadasset_next_row

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
    BRA.S   .loadasset_decode_planes_loop

.loadasset_next_row:
    ADDQ.W  #1,-18(A5)
    BRA.W   .loadasset_decode_rows_loop

.loadasset_restore_plane_ptrs:
    MOVEQ   #0,D6

.loadasset_restore_plane_ptrs_loop:
    MOVEQ   #0,D0
    MOVEA.L -16(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D6
    BGE.W   .loadasset_maybe_clone_type11

    MOVEQ   #5,D0
    CMP.L   D0,D6
    BGE.W   .loadasset_maybe_clone_type11

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVE.L  D0,D1
    ADDI.L  #$90,D1
    MOVE.L  -42(A5,D0.L),0(A0,D1.L)
    ADDQ.L  #1,D6
    BRA.S   .loadasset_restore_plane_ptrs_loop

.loadasset_cleanup_partial_alloc:
    MOVEA.L -16(A5),A0
    TST.B   184(A0)
    BEQ.S   .loadasset_free_node_and_clear

    MOVEQ   #5,D0
    CMP.L   D0,D6
    BGE.S   .loadasset_free_node_and_clear

    MOVE.L  D6,D0
    ASL.L   #2,D0
    MOVE.L  D0,D1
    ADDI.L  #$90,D1
    TST.L   0(A0,D1.L)
    BEQ.S   .loadasset_cleanup_next_plane

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
    PEA     Global_STR_BRUSH_C_13
    JSR     GROUP_AB_JMPTBL_UNKNOWN2B_FreeRaster(PC)

    LEA     20(A7),A7

.loadasset_cleanup_next_plane:
    ADDQ.L  #1,D6
    BRA.S   .loadasset_cleanup_partial_alloc

.loadasset_free_node_and_clear:
    PEA     372.W
    MOVE.L  -16(A5),-(A7)
    PEA     1205.W
    PEA     Global_STR_BRUSH_C_14
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    CLR.L   -16(A5)

.loadasset_maybe_clone_type11:
    MOVEQ   #11,D0
    CMP.B   190(A3),D0
    BNE.S   .loadasset_cleanup_decode_buffer

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     372.W
    PEA     1220.W
    PEA     Global_STR_BRUSH_C_15
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-16(A5)
    TST.L   D0
    BEQ.S   .loadasset_cleanup_decode_buffer

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.loadasset_copy_clone_header_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .loadasset_copy_clone_header_loop

    MOVEA.L -16(A5),A0
    MOVE.B  190(A3),32(A0)
    LEA     176(A0),A1
    LEA     128(A3),A2
    MOVEQ   #4,D0

.loadasset_copy_clone_dims_loop:
    MOVE.L  (A2)+,(A1)+
    DBF     D0,.loadasset_copy_clone_dims_loop

    MOVEA.L -16(A5),A0
    ADDA.W  #196,A0
    LEA     148(A3),A1
    MOVE.L  (A1)+,(A0)+
    SUBA.L  A0,A0
    MOVEA.L -16(A5),A1
    MOVE.L  A0,368(A1)

.loadasset_cleanup_decode_buffer:
    TST.L   -50(A5)
    BEQ.S   .return

    MOVE.L  #130000,-(A7)
    MOVE.L  -50(A5),-(A7)
    PEA     1236.W
    PEA     Global_STR_BRUSH_C_16
    JSR     GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.return:
    MOVE.L  -16(A5),D0
    MOVEM.L (A7)+,D2-D3/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

; Clone an in-memory brush definition, rebuilding its bitmap state.
;------------------------------------------------------------------------------
; FUNC: BRUSH_CloneBrushRecord   (Routine at BRUSH_CloneBrushRecord)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D7
; CALLS:
;   GROUP_AA_JMPTBL_UNKNOWN2B_AllocRaster, GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOForbid, _LVOInitBitMap, _LVOInitRastPort, _LVOPermit
; READS:
;   AbsExecBase, BRUSH_PendingAlertCode, BRUSH_SnapshotHeader, Global_REF_GRAPHICS_LIBRARY, Global_STR_BRUSH_C_17, Global_STR_BRUSH_C_18, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   BRUSH_PendingAlertCode
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_CloneBrushRecord:
    LINK.W  A5,#-12
    MOVEM.L D2/D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -8(A5)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     372.W
    PEA     1248.W
    PEA     Global_STR_BRUSH_C_17
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   .return

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.clone_copy_header_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .clone_copy_header_loop

    MOVEA.L -8(A5),A0
    ADDA.W  #$b0,A0
    LEA     128(A3),A1
    MOVEQ   #4,D0

.clone_copy_bitmap_dims_loop:
    MOVE.L  (A1)+,(A0)+
    DBF     D0,.clone_copy_bitmap_dims_loop

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
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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

.clone_copy_row_offsets_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .clone_copy_label

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
    BRA.S   .clone_copy_row_offsets_loop

.clone_copy_label:
    MOVEA.L -8(A5),A0
    ADDA.W  #$21,A0
    LEA     191(A3),A1

.clone_copy_label_loop:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .clone_copy_label_loop

    MOVEA.L -8(A5),A0
    MOVE.L  230(A3),364(A0)
    TST.L   214(A3)
    BEQ.S   .clone_default_width_limit

    MOVE.L  214(A3),348(A0)
    BRA.S   .clone_after_width_limit

.clone_default_width_limit:
    MOVEQ   #0,D0
    MOVE.W  176(A0),D0
    MOVE.L  D0,348(A0)

.clone_after_width_limit:
    TST.L   218(A3)
    BEQ.S   .clone_default_height_limit

    MOVE.L  218(A3),352(A0)
    BRA.S   .clone_after_height_limit

.clone_default_height_limit:
    MOVEQ   #0,D0
    MOVE.W  178(A0),D0
    MOVE.L  D0,352(A0)

.clone_after_height_limit:
    MOVEQ   #0,D7

.clone_alloc_planes_loop:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D7
    BGE.W   .clone_after_plane_alloc

    MOVEQ   #5,D0
    CMP.L   D0,D7
    BGE.W   .clone_after_plane_alloc

    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEQ   #0,D1
    MOVE.W  176(A0),D1
    MOVEQ   #0,D2
    MOVE.W  178(A0),D2
    MOVE.L  D2,-(A7)                      ; Height
    MOVE.L  D1,-(A7)                      ; Width
    PEA     1302.W                        ; Line Number
    PEA     Global_STR_BRUSH_C_18           ; Calling file
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
    BNE.S   .clone_next_plane_alloc

    MOVEA.L AbsExecBase,A6
    JSR     _LVOForbid(A6)

    TST.L   BRUSH_PendingAlertCode
    BNE.S   .clone_alert_already_set

    MOVEQ   #1,D0
    MOVE.L  D0,BRUSH_PendingAlertCode      ; capture snapshot so cleanup can restore UI hints
    MOVEA.L -8(A5),A0
    LEA     BRUSH_SnapshotHeader,A1

.clone_copy_snapshot_for_alert_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .clone_copy_snapshot_for_alert_loop

.clone_alert_already_set:
    JSR     _LVOPermit(A6)

    BRA.S   .clone_after_plane_alloc

.clone_next_plane_alloc:
    ADDQ.L  #1,D7
    BRA.W   .clone_alloc_planes_loop

.clone_after_plane_alloc:
    MOVEQ   #0,D0
    MOVEA.L -8(A5),A0
    MOVE.B  184(A0),D0
    CMP.L   D0,D7
    BNE.S   .return

    LEA     36(A0),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L -8(A5),A0
    ADDA.W  #$88,A0
    MOVEA.L -8(A5),A1
    MOVE.L  A0,40(A1)
    MOVEQ   #0,D7

.clone_copy_palette_bytes_loop:
    MOVEQ   #96,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVEA.L -8(A5),A0
    MOVE.L  D7,D0
    ADDI.L  #232,D0
    MOVE.B  32(A3,D7.L),0(A0,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .clone_copy_palette_bytes_loop

.return:
    MOVE.L  -8(A5),D0
    MOVEM.L (A7)+,D2/D7/A2-A3
    UNLK    A5
    RTS

;!======

; Allocate a linked brush node and splice it into the optional list at A2.
;------------------------------------------------------------------------------
; FUNC: BRUSH_AllocBrushNode   (Routine at BRUSH_AllocBrushNode)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A7/D0
; CALLS:
;   GROUP_AG_JMPTBL_MEMORY_AllocateMemory
; READS:
;   BRUSH_LastAllocatedNode, Global_STR_BRUSH_C_19, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   BRUSH_LastAllocatedNode
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_AllocBrushNode:
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     238.W
    PEA     1352.W
    PEA     Global_STR_BRUSH_C_19
    JSR     GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,BRUSH_LastAllocatedNode   ; expose allocation for cleanup/error handlers
    TST.L   D0
    BEQ.S   .allocnode_return

    MOVEA.L A3,A0
    MOVEA.L D0,A1

.allocnode_copy_header_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .allocnode_copy_header_loop

    MOVEQ   #1,D0
    MOVEA.L BRUSH_LastAllocatedNode,A0
    MOVE.L  D0,194(A0)
    CLR.B   190(A0)
    MOVEQ   #0,D0
    MOVE.L  D0,222(A0)
    MOVE.L  D0,226(A0)
    MOVE.L  A2,D0
    BEQ.S   .allocnode_link_previous_tail

    MOVE.L  A0,234(A2)

.allocnode_link_previous_tail:
    CLR.L   234(A0)

.allocnode_return:
    MOVE.L  BRUSH_LastAllocatedNode,D0
    MOVEM.L (A7)+,A2-A3
    RTS

;!======

; Convert a plane index (0-8) into the corresponding bitmask.
;------------------------------------------------------------------------------
; FUNC: BRUSH_PlaneMaskForIndex   (Routine at BRUSH_PlaneMaskForIndex)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D7
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_PlaneMaskForIndex:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    TST.L   D7
    BLE.S   .planemask_invalid_index

    MOVEQ   #9,D0
    CMP.L   D0,D7
    BGE.S   .planemask_invalid_index

    MOVEQ   #1,D0
    ASL.L   D7,D0
    BRA.S   .planemask_return

.planemask_invalid_index:
    MOVEQ   #0,D0

.planemask_return:
    MOVE.L  (A7)+,D7
    RTS

;!======

; Select a brush by its string label, updating BRUSH_SelectedNode.
;------------------------------------------------------------------------------
; FUNC: BRUSH_SelectBrushByLabel   (Routine at BRUSH_SelectBrushByLabel)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A3/A5/A7
; CALLS:
;   BRUSH_FindBrushByPredicate, GROUP_AA_JMPTBL_STRING_CompareN, GROUP_AG_JMPTBL_STRING_CopyPadNul
; READS:
;   BRUSH_LabelScratch, BRUSH_SelectedNode, BRUSH_STR_ALIAS_CODE_00, BRUSH_STR_ALIAS_CODE_11, BRUSH_STR_ALIAS_CODE_DT, BRUSH_STR_FALLBACK_DITHER, ESQIFF_BrushIniListHead
; WRITES:
;   BRUSH_ScriptPrimarySelection, BRUSH_ScriptSecondarySelection, BRUSH_SelectedNode
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_SelectBrushByLabel:
    LINK.W  A5,#-8
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L A3,A0
    LEA     BRUSH_LabelScratch,A1

.lab_0196:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .lab_0196

    MOVE.L  ESQIFF_BrushIniListHead,-4(A5)
    CLR.L   BRUSH_SelectedNode
    PEA     2.W
    PEA     BRUSH_STR_ALIAS_CODE_00
    MOVE.L  A3,-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_0197

    PEA     2.W
    PEA     BRUSH_STR_ALIAS_CODE_11
    MOVE.L  A3,-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BEQ.S   .lab_0197

    PEA     2.W
    MOVE.L  A3,-(A7)
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    BRA.S   .lab_0198

.lab_0197:
    PEA     2.W
    PEA     BRUSH_STR_ALIAS_CODE_DT
    PEA     -7(A5)
    JSR     GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7

.lab_0198:
    CLR.B   -5(A5)

.lab_0199:
    TST.L   -4(A5)
    BEQ.S   .lab_019B

    MOVEA.L -4(A5),A0
    ADDA.W  #$21,A0
    PEA     2.W
    PEA     -7(A5)
    MOVE.L  A0,-(A7)
    JSR     GROUP_AA_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .lab_019A

    MOVE.L  -4(A5),BRUSH_SelectedNode

.lab_019A:
    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .lab_0199

.lab_019B:
    TST.L   BRUSH_SelectedNode
    BNE.S   .lab_019C

    PEA     ESQIFF_BrushIniListHead
    PEA     BRUSH_STR_FALLBACK_DITHER
    BSR.W   BRUSH_FindBrushByPredicate

    ADDQ.W  #8,A7
    MOVE.L  D0,BRUSH_SelectedNode

.lab_019C:
    MOVEA.L BRUSH_SelectedNode,A0
    MOVE.L  A0,BRUSH_ScriptPrimarySelection   ; expose latest selection to script subsystem
    MOVE.L  A0,BRUSH_ScriptSecondarySelection ; and remember it as the fallback option
    MOVEA.L (A7)+,A3
    UNLK    A5
    RTS

;!======

; Append brush node A2 to the tail of list A3 (tracking via offset 368).
;------------------------------------------------------------------------------
; FUNC: BRUSH_AppendBrushNode   (Routine at BRUSH_AppendBrushNode)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A5/A7/D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_AppendBrushNode:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  A3,D0
    BNE.S   .append_node_find_tail

    MOVEA.L A2,A3
    BRA.S   .append_node_return

.append_node_find_tail:
    MOVE.L  A3,-4(A5)

.append_node_tail_loop:
    MOVEA.L -4(A5),A0
    TST.L   368(A0)
    BEQ.S   .append_node_link_tail

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .append_node_tail_loop

.append_node_link_tail:
    MOVEA.L -4(A5),A0
    MOVE.L  A2,368(A0)

.append_node_return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======

; Remove the head brush from the list at 8(A5), returning the next node.
;------------------------------------------------------------------------------
; FUNC: BRUSH_PopBrushHead   (Routine at BRUSH_PopBrushHead)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/A7/D0
; CALLS:
;   BRUSH_FreeBrushList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
BRUSH_PopBrushHead:
    LINK.W  A5,#-4

    TST.L   8(A5)
    BNE.S   .pophead_has_node

    CLR.L   -4(A5)
    BRA.S   .pophead_return

.pophead_has_node:
    MOVEA.L 8(A5),A0
    MOVE.L  368(A0),-4(A5)
    PEA     1.W
    PEA     8(A5)
    BSR.W   BRUSH_FreeBrushList

    ADDQ.W  #8,A7

.pophead_return:
    MOVE.L  -4(A5),D0
    UNLK    A5
    RTS
