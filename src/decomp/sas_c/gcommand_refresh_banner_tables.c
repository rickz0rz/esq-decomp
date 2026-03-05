typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE Global_REF_696_400_BITMAP[];
extern UBYTE ESQ_CopperListBannerA[];
extern UBYTE ESQ_CopperListBannerB[];

extern LONG GCOMMAND_BannerRowByteOffsetCurrent;
extern LONG GCOMMAND_BannerRowByteOffsetPrevious;
extern LONG GCOMMAND_BannerPhaseIndexCurrent;

extern UBYTE *WDISP_BannerRowScratchRasterTable0;
extern UBYTE *WDISP_BannerRowScratchRasterTable1;
extern UBYTE *WDISP_BannerRowScratchRasterTable2;

extern UBYTE *ESQPARS2_BannerSnapshotPlane0DstPtr;
extern UBYTE *ESQPARS2_BannerSnapshotPlane1DstPtr;
extern UBYTE *ESQPARS2_BannerSnapshotPlane2DstPtr;

extern void GCOMMAND_BuildBannerRow(
    UBYTE *bitmapPtr,
    UBYTE *tablePtr,
    LONG rowIndex,
    LONG fallbackIndex,
    LONG baseOffset
);

void GCOMMAND_RefreshBannerTables(void)
{
    LONG row = GCOMMAND_BannerRowByteOffsetCurrent;
    LONG phase = GCOMMAND_BannerPhaseIndexCurrent;

    GCOMMAND_BuildBannerRow(Global_REF_696_400_BITMAP, ESQ_CopperListBannerA, row, 98, phase);
    GCOMMAND_BuildBannerRow(Global_REF_696_400_BITMAP, ESQ_CopperListBannerB, row + 88, 98, phase);

    {
        LONG prev = GCOMMAND_BannerRowByteOffsetPrevious;
        ESQPARS2_BannerSnapshotPlane0DstPtr = WDISP_BannerRowScratchRasterTable0 + prev;
        ESQPARS2_BannerSnapshotPlane1DstPtr = WDISP_BannerRowScratchRasterTable1 + prev;
        ESQPARS2_BannerSnapshotPlane2DstPtr = WDISP_BannerRowScratchRasterTable2 + prev;
    }
}
