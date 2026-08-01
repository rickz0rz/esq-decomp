    XDEF    _BRUSH_CloneBrushRecord


; Clone an in-memory brush definition, rebuilding its bitmap state.
;------------------------------------------------------------------------------
; FUNC: _BRUSH_CloneBrushRecord   (Routine at _BRUSH_CloneBrushRecord)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0/D1/D2/D7
; CALLS:
;   _GROUP_AA_JMPTBL_GRAPHICS_AllocRaster, _GROUP_AG_JMPTBL_MEMORY_AllocateMemory, _LVOForbid, _LVOInitBitMap, _LVOInitRastPort, _LVOPermit
; READS:
;   AbsExecBase, _BRUSH_PendingAlertCode, _BRUSH_SnapshotHeader, _Global_REF_GRAPHICS_LIBRARY, _Global_STR_BRUSH_C_17, _Global_STR_BRUSH_C_18, MEMF_CLEAR, MEMF_PUBLIC
; WRITES:
;   _BRUSH_PendingAlertCode
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_BRUSH_CloneBrushRecord:
    LINK.W  A5,#-12
    MOVEM.L D2/D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    CLR.L   -8(A5)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     372.W
    PEA     1248.W
    PEA     _Global_STR_BRUSH_C_17
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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
    PEA     _Global_STR_BRUSH_C_18           ; Calling file
    MOVE.L  D0,32(A7)
    JSR     _GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(PC)

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

    TST.L   _BRUSH_PendingAlertCode
    BNE.S   .clone_alert_already_set

    MOVEQ   #1,D0
    MOVE.L  D0,_BRUSH_PendingAlertCode      ; capture snapshot so cleanup can restore UI hints
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
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
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