typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Font {
    UBYTE pad0[20];
    UWORD ySize;
} NEWGRID_Font;

typedef struct NEWGRID_RastPort {
    UBYTE pad0[4];
    void *bitmap;
    UBYTE pad1[44];
    NEWGRID_Font *font;
} NEWGRID_RastPort;

extern UWORD NEWGRID_GridResourcesInitializedFlag;
extern NEWGRID_RastPort *NEWGRID_MainRastPortPtr;
extern NEWGRID_RastPort *NEWGRID_HeaderRastPortPtr;
extern UWORD NEWGRID_SampleTimeTextWidthPx;
extern UWORD NEWGRID_ColumnStartXPx;
extern UWORD NEWGRID_ColumnWidthPx;
extern UWORD NEWGRID_RowHeightPx;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern const char Global_STR_NEWGRID_C_1[];
extern const char Global_STR_NEWGRID_C_2[];
extern const char Global_STR_44_44_44[];
extern UBYTE Global_REF_696_400_BITMAP;
extern UBYTE WDISP_BannerGridBitmapStruct;

extern void NEWGRID2_EnsureBuffersAllocated(void);
extern void DISPTEXT_InitBuffers(void);
extern void NEWGRID_InitShowtimeBuckets(void);
extern void *MEMORY_AllocateMemory(LONG size, LONG flags);
extern void _LVOInitRastPort(char *rastPort);
extern void _LVOSetDrMd(char *rastPort, LONG mode);
extern void _LVOSetFont(char *rastPort, void *font);
extern LONG _LVOTextLength(char *rastPort, const char *text, LONG len);
extern LONG MATH_DivS32(LONG a, LONG b);
extern void NEWGRID_DrawTopBorderLine(void);

void NEWGRID_InitGridResources(void)
{
    LONG d0;
    LONG d1;
    NEWGRID_RastPort *mainRast;

    if (NEWGRID_GridResourcesInitializedFlag != 0) {
        return;
    }

    NEWGRID_GridResourcesInitializedFlag = 1;
    NEWGRID2_EnsureBuffersAllocated();
    DISPTEXT_InitBuffers();
    NEWGRID_InitShowtimeBuckets();

    NEWGRID_MainRastPortPtr = MEMORY_AllocateMemory(100, 0x10001);
    if (NEWGRID_MainRastPortPtr == 0) {
        return;
    }

    _LVOInitRastPort((char *)NEWGRID_MainRastPortPtr);
    NEWGRID_MainRastPortPtr->bitmap = &Global_REF_696_400_BITMAP;
    _LVOSetDrMd((char *)NEWGRID_MainRastPortPtr, 0);
    _LVOSetFont((char *)NEWGRID_MainRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_HeaderRastPortPtr = MEMORY_AllocateMemory(100, 0x10001);
    if (NEWGRID_HeaderRastPortPtr == 0) {
        return;
    }

    _LVOInitRastPort((char *)NEWGRID_HeaderRastPortPtr);
    NEWGRID_HeaderRastPortPtr->bitmap = &WDISP_BannerGridBitmapStruct;
    _LVOSetDrMd((char *)NEWGRID_HeaderRastPortPtr, 0);
    _LVOSetFont((char *)NEWGRID_HeaderRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_DrawTopBorderLine();

    d0 = _LVOTextLength((char *)NEWGRID_MainRastPortPtr, Global_STR_44_44_44, 8);
    NEWGRID_SampleTimeTextWidthPx = (UWORD)d0;
    d0 += 12;
    NEWGRID_ColumnStartXPx = (UWORD)d0;
    d1 = (LONG)(UWORD)d0;
    d0 = 624 - d1;
    d0 = MATH_DivS32(d0, 3);
    NEWGRID_ColumnWidthPx = (UWORD)d0;

    mainRast = NEWGRID_MainRastPortPtr;
    d0 = (LONG)(UWORD)mainRast->font->ySize;
    d0 = ((d0 - 1) * 2) + 8;
    NEWGRID_RowHeightPx = (UWORD)d0;
    d1 = MATH_DivS32(d0, 2);
    if (d1 != 0) {
        NEWGRID_RowHeightPx = (UWORD)((UWORD)NEWGRID_RowHeightPx - 1);
    }

    NEWGRID_DrawTopBorderLine();
}
