typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UWORD NEWGRID_GridResourcesInitializedFlag;
extern void *NEWGRID_MainRastPortPtr;
extern void *NEWGRID_HeaderRastPortPtr;
extern UWORD NEWGRID_SampleTimeTextWidthPx;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern UWORD NEWGRID_RowHeightPx;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern UBYTE Global_STR_NEWGRID_C_1;
extern UBYTE Global_STR_NEWGRID_C_2;
extern UBYTE Global_STR_44_44_44;
extern UBYTE Global_REF_696_400_BITMAP;
extern UBYTE WDISP_BannerGridBitmapStruct;

extern void NEWGRID2_EnsureBuffersAllocated(void);
extern void NEWGRID_JMPTBL_DISPTEXT_InitBuffers(void);
extern void NEWGRID_InitShowtimeBuckets(void);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(UBYTE *tagName, LONG width, LONG height, LONG flags);
extern void _LVOInitRastPort(void *rastPort);
extern void _LVOSetDrMd(void *rastPort, LONG mode);
extern void _LVOSetFont(void *rastPort, void *font);
extern LONG _LVOTextLength(void *rastPort, UBYTE *text, LONG len);
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG a, LONG b);
extern void NEWGRID_DrawTopBorderLine(void);

void NEWGRID_InitGridResources(void)
{
    LONG d0;
    LONG d1;
    UBYTE *mainRast;

    if (NEWGRID_GridResourcesInitializedFlag != 0) {
        return;
    }

    NEWGRID_GridResourcesInitializedFlag = 1;
    NEWGRID2_EnsureBuffersAllocated();
    NEWGRID_JMPTBL_DISPTEXT_InitBuffers();
    NEWGRID_InitShowtimeBuckets();

    NEWGRID_MainRastPortPtr = NEWGRID_JMPTBL_MEMORY_AllocateMemory(&Global_STR_NEWGRID_C_1, 99, 100, 0x10001);
    if (NEWGRID_MainRastPortPtr == 0) {
        return;
    }

    _LVOInitRastPort(NEWGRID_MainRastPortPtr);
    *(void **)((UBYTE *)NEWGRID_MainRastPortPtr + 4) = &Global_REF_696_400_BITMAP;
    _LVOSetDrMd(NEWGRID_MainRastPortPtr, 0);
    _LVOSetFont(NEWGRID_MainRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_HeaderRastPortPtr = NEWGRID_JMPTBL_MEMORY_AllocateMemory(&Global_STR_NEWGRID_C_2, 112, 100, 0x10001);
    if (NEWGRID_HeaderRastPortPtr == 0) {
        return;
    }

    _LVOInitRastPort(NEWGRID_HeaderRastPortPtr);
    *(void **)((UBYTE *)NEWGRID_HeaderRastPortPtr + 4) = &WDISP_BannerGridBitmapStruct;
    _LVOSetDrMd(NEWGRID_HeaderRastPortPtr, 0);
    _LVOSetFont(NEWGRID_HeaderRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_DrawTopBorderLine();

    d0 = _LVOTextLength(NEWGRID_MainRastPortPtr, &Global_STR_44_44_44, 8);
    NEWGRID_SampleTimeTextWidthPx = (UWORD)d0;
    d0 += 12;
    NEWGRID_ColumnStartXPx = (UWORD)d0;
    d1 = (LONG)(UWORD)d0;
    d0 = 624 - d1;
    d0 = NEWGRID_JMPTBL_MATH_DivS32(d0, 3);
    NEWGRID_ColumnWidthPx = (UWORD)d0;

    mainRast = (UBYTE *)NEWGRID_MainRastPortPtr;
    d0 = (LONG)(UWORD)(*(UWORD *)(*(UBYTE **)(mainRast + 52) + 20));
    d0 = ((d0 - 1) * 2) + 8;
    NEWGRID_RowHeightPx = (UWORD)d0;
    d1 = NEWGRID_JMPTBL_MATH_DivS32(d0, 2);
    if (d1 != 0) {
        NEWGRID_RowHeightPx = (UWORD)((UWORD)NEWGRID_RowHeightPx - 1);
    }

    NEWGRID_DrawTopBorderLine();
}
