    XDEF    BRUSH_AllocBrushNode
    XDEF    BRUSH_CloneBrushRecord
    XDEF    BRUSH_LoadBrushAsset



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
;   BITMAP_ProcessIlbmImage, _ESQ_PackBitsDecode, GROUP_AA_JMPTBL_STRING_CompareN, GROUP_AA_JMPTBL_GRAPHICS_AllocRaster, _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster, _GROUP_AG_JMPTBL_MATH_DivS32, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory, GROUP_AG_JMPTBL_DOS_OpenFileWithMode, _LVOClose, _LVOForbid, _LVOInitBitMap, _LVOInitRastPort, _LVOPermit, _LVORead, _LVOSeek
; READS:
;   AbsExecBase, BRUSH_PendingAlertCode, _BRUSH_SnapshotHeader, Global_REF_DOS_LIBRARY_2, Global_REF_GRAPHICS_LIBRARY, Global_STR_BRUSH_C_10, Global_STR_BRUSH_C_11, Global_STR_BRUSH_C_12, Global_STR_BRUSH_C_13, Global_STR_BRUSH_C_14, Global_STR_BRUSH_C_15, Global_STR_BRUSH_C_16, BRUSH_STR_IFF_FORM, MEMF_CLEAR, MEMF_PUBLIC, MODE_OLDFILE
; WRITES:
;   BRUSH_PendingAlertCode, _BRUSH_SnapshotDepth, _BRUSH_SnapshotWidth
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
    JSR     GROUP_AG_JMPTBL_DOS_OpenFileWithMode(PC)

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
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    MOVE.L  D0,_BRUSH_SnapshotWidth
    MOVEQ   #0,D0
    MOVE.B  136(A3),D0
    MOVE.L  D0,_BRUSH_SnapshotDepth
    MOVEA.L A3,A0
    LEA     _BRUSH_SnapshotHeader,A1

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
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(PC)

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
    LEA     _BRUSH_SnapshotHeader,A1

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
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

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
    JSR     _ESQ_PackBitsDecode(PC)

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
    JSR     _GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(PC)

    LEA     20(A7),A7

.loadasset_cleanup_next_plane:
    ADDQ.L  #1,D6
    BRA.S   .loadasset_cleanup_partial_alloc

.loadasset_free_node_and_clear:
    PEA     372.W
    MOVE.L  -16(A5),-(A7)
    PEA     1205.W
    PEA     Global_STR_BRUSH_C_14
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

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
;   GROUP_AA_JMPTBL_GRAPHICS_AllocRaster, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOForbid, _LVOInitBitMap, _LVOInitRastPort, _LVOPermit
; READS:
;   AbsExecBase, BRUSH_PendingAlertCode, _BRUSH_SnapshotHeader, Global_REF_GRAPHICS_LIBRARY, Global_STR_BRUSH_C_17, Global_STR_BRUSH_C_18, MEMF_CLEAR, MEMF_PUBLIC
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
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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
    JSR     GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(PC)

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
    LEA     _BRUSH_SnapshotHeader,A1

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
;   _GROUP_AG_JMPTBL_MEMORY_AllocateMemory
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
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

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