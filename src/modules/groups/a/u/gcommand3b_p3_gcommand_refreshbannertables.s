    XDEF    _GCOMMAND_RefreshBannerTables



;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_RefreshBannerTables   (Rebuild active rows in both banner copper tables)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A1
; CALLS:
;   _GCOMMAND_BuildBannerRow
; READS:
;   _GCOMMAND_BannerRowByteOffsetCurrent, _GCOMMAND_BannerRowByteOffsetPrevious, _GCOMMAND_BannerPhaseIndexCurrent, _WDISP_BannerRowScratchRasterTable0.._WDISP_BannerRowScratchRasterTable2, _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; WRITES:
;   _ESQPARS2_BannerSnapshotPlane0DstPtr, _ESQPARS2_BannerSnapshotPlane1DstPtr, _ESQPARS2_BannerSnapshotPlane2DstPtr
; DESC:
;   Rebuilds banner rows for both tables and refreshes row pointer globals.
; NOTES:
;   Uses _GCOMMAND_BannerRowByteOffsetCurrent as the active row index and _GCOMMAND_BannerPhaseIndexCurrent as the base offset.
;------------------------------------------------------------------------------
_GCOMMAND_RefreshBannerTables:
    MOVE.L  _GCOMMAND_BannerRowByteOffsetCurrent,-(A7)
    PEA     98.W
    MOVE.L  _GCOMMAND_BannerPhaseIndexCurrent,-(A7)
    PEA     _ESQ_CopperListBannerA
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   _GCOMMAND_BuildBannerRow

    MOVEQ   #88,D0
    ADD.L   _GCOMMAND_BannerRowByteOffsetCurrent,D0
    MOVE.L  D0,(A7)
    PEA     98.W
    MOVE.L  _GCOMMAND_BannerPhaseIndexCurrent,-(A7)
    PEA     _ESQ_CopperListBannerB
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   _GCOMMAND_BuildBannerRow

    LEA     36(A7),A7
    MOVE.L  _GCOMMAND_BannerRowByteOffsetPrevious,D0
    MOVEA.L _WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0
    MOVE.L  A0,_ESQPARS2_BannerSnapshotPlane0DstPtr
    MOVEA.L _WDISP_BannerRowScratchRasterTable1,A0
    ADDA.L  D0,A0
    MOVE.L  A0,_ESQPARS2_BannerSnapshotPlane1DstPtr
    MOVEA.L _WDISP_BannerRowScratchRasterTable2,A0
    ADDA.L  D0,A0
    MOVE.L  A0,_ESQPARS2_BannerSnapshotPlane2DstPtr
    RTS

;!======