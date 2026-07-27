    XDEF    _BRUSH_LoadColorTextFont


; -----------------------------------------------------------------------------
; Brush.c routines
; -----------------------------------------------------------------------------
; These helpers load, cache, and tear down raster brush assets that back the
; on-screen paint tools. The original binary exported them as unnamed entry
; points (LAB_xxxx). We keep the legacy symbols for reference but introduce
; descriptive aliases below to aid navigation while we continue annotating.
; -----------------------------------------------------------------------------
;------------------------------------------------------------------------------
; FUNC: _BRUSH_LoadColorTextFont   (Routine at _BRUSH_LoadColorTextFont)
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
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, _LVORead
; READS:
;   Global_REF_DOS_LIBRARY_2, _Global_STR_BRUSH_C_1, _Global_STR_BRUSH_C_2, _Global_STR_BRUSH_C_3, _Global_STR_BRUSH_C_4, MEMF_PUBLIC, Struct_ColorTextFont_Size, return
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_LoadColorTextFont:
    LINK.W  A5,#-16
    MOVEM.L D2-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVEA.L 16(A5),A3

    PEA     (MEMF_PUBLIC).W
    PEA     Struct_ColorTextFont_Size.W
    PEA     396.W
    PEA     _Global_STR_BRUSH_C_1
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    PEA     _Global_STR_BRUSH_C_2
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    PEA     _Global_STR_BRUSH_C_3
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    PEA     _Global_STR_BRUSH_C_4
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #1,D0

.return:
    MOVEM.L -44(A5),D2-D7/A3
    UNLK    A5
    RTS

;!======