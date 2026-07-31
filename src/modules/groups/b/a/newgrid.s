    XDEF    _NEWGRID_InitGridResources


;!======
;------------------------------------------------------------------------------
; FUNC: _NEWGRID_InitGridResources   (Initialize grid rastports and layout)
; ARGS:
;   (none)
; RET:
;   D0: none (implicit via globals)
; CLOBBERS:
;   D0-D3/A0-A1/A6
; CALLS:
;   _NEWGRID2_EnsureBuffersAllocated, NEWGRID_JMPTBL_DISPTEXT_InitBuffers, _NEWGRID_InitShowtimeBuckets, _NEWGRID_JMPTBL_MEMORY_AllocateMemory, _LVOInitRastPort,
;   _LVOSetDrMd, _LVOSetFont, _NEWGRID_DrawTopBorderLine,
;   _LVOTextLength, _NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   _NEWGRID_GridResourcesInitializedFlag, _Global_HANDLE_PREVUEC_FONT, Global_STR_44_44_44
; WRITES:
;   _NEWGRID_GridResourcesInitializedFlag, _NEWGRID_MainRastPortPtr/2, _NEWGRID_RowHeightPx-232B
; DESC:
;   Allocates two RastPorts, attaches bitmaps/fonts, and computes layout metrics
;   for the grid header/banner area.
; NOTES:
;   Early-outs if already initialized (_NEWGRID_GridResourcesInitializedFlag != 0) or allocation fails.
;------------------------------------------------------------------------------
_NEWGRID_InitGridResources:
    TST.W   _NEWGRID_GridResourcesInitializedFlag
    BNE.W   .return_init_status

    MOVE.W  #1,_NEWGRID_GridResourcesInitializedFlag
    JSR     _NEWGRID2_EnsureBuffersAllocated(PC)

    JSR     NEWGRID_JMPTBL_DISPTEXT_InitBuffers(PC)

    JSR     _NEWGRID_InitShowtimeBuckets(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     99.W
    PEA     Global_STR_NEWGRID_C_1
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_MainRastPortPtr
    TST.L   D0
    BEQ.W   .return_init_status

    MOVEA.L D0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     112.W
    PEA     Global_STR_NEWGRID_C_2
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_NEWGRID_HeaderRastPortPtr
    TST.L   D0
    BEQ.W   .return_init_status

    MOVEA.L D0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L _NEWGRID_HeaderRastPortPtr,A0
    MOVE.L  #_WDISP_BannerGridBitmapStruct,4(A0)
    MOVEA.L _NEWGRID_HeaderRastPortPtr,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _NEWGRID_HeaderRastPortPtr,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    BSR.W   _NEWGRID_DrawTopBorderLine

    MOVEQ   #8,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    LEA     Global_STR_44_44_44,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  D0,NEWGRID_SampleTimeTextWidthPx
    ADDI.W  #12,D0
    MOVE.W  D0,_NEWGRID_ColumnStartXPx
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  #624,D0
    SUB.L   D1,D0
    MOVEQ   #3,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,_NEWGRID_ColumnWidthPx
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    SUBQ.L  #1,D0
    ADD.L   D0,D0
    ADDQ.L  #8,D0
    MOVE.W  D0,_NEWGRID_RowHeightPx
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BEQ.S   .align_even

    MOVE.W  _NEWGRID_RowHeightPx,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,_NEWGRID_RowHeightPx

.align_even:
    BSR.W   _NEWGRID_DrawTopBorderLine

.return_init_status:
    RTS

;!======