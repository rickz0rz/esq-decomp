#include "esq_types.h"

extern s16 NEWGRID_GridResourcesInitializedFlag;
extern void *NEWGRID_MainRastPortPtr;
extern void *NEWGRID_HeaderRastPortPtr;
extern u16 NEWGRID_SampleTimeTextWidthPx;
extern u16 NEWGRID_ColumnStartXPx;
extern u16 NEWGRID_ColumnWidthPx;
extern u16 NEWGRID_RowHeightPx;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern u8 Global_STR_NEWGRID_C_1;
extern u8 Global_STR_NEWGRID_C_2;
extern u8 Global_STR_44_44_44;
extern u8 Global_REF_696_400_BITMAP;
extern u8 WDISP_BannerGridBitmapStruct;

void NEWGRID2_EnsureBuffersAllocated(void) __attribute__((noinline));
void NEWGRID_JMPTBL_DISPTEXT_InitBuffers(void) __attribute__((noinline));
void NEWGRID_InitShowtimeBuckets(void) __attribute__((noinline));
void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const void *tag_name, s32 width, s32 height, s32 flags) __attribute__((noinline));
void _LVOInitRastPort(void *rastport) __attribute__((noinline));
void _LVOSetDrMd(void *rastport, s32 mode) __attribute__((noinline));
void _LVOSetFont(void *rastport, void *font) __attribute__((noinline));
s32 _LVOTextLength(void *rastport, const u8 *text, s32 len) __attribute__((noinline));
s32 NEWGRID_JMPTBL_MATH_DivS32(s32 a, s32 b) __attribute__((noinline));
void NEWGRID_DrawTopBorderLine(void) __attribute__((noinline));

void NEWGRID_InitGridResources(void) __attribute__((noinline, used));

void NEWGRID_InitGridResources(void)
{
    s32 sample_width;
    s32 col_start;
    s32 row_h;

    if (NEWGRID_GridResourcesInitializedFlag != 0) {
        return;
    }

    NEWGRID_GridResourcesInitializedFlag = 1;
    NEWGRID2_EnsureBuffersAllocated();
    NEWGRID_JMPTBL_DISPTEXT_InitBuffers();
    NEWGRID_InitShowtimeBuckets();

    NEWGRID_MainRastPortPtr = NEWGRID_JMPTBL_MEMORY_AllocateMemory(&Global_STR_NEWGRID_C_1, 99, 100, 0x10001);
    if (NEWGRID_MainRastPortPtr == (void *)0) {
        return;
    }

    _LVOInitRastPort(NEWGRID_MainRastPortPtr);
    *(void **)((u8 *)NEWGRID_MainRastPortPtr + 4) = &Global_REF_696_400_BITMAP;
    _LVOSetDrMd(NEWGRID_MainRastPortPtr, 0);
    _LVOSetFont(NEWGRID_MainRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_HeaderRastPortPtr = NEWGRID_JMPTBL_MEMORY_AllocateMemory(&Global_STR_NEWGRID_C_2, 112, 100, 0x10001);
    if (NEWGRID_HeaderRastPortPtr == (void *)0) {
        return;
    }

    _LVOInitRastPort(NEWGRID_HeaderRastPortPtr);
    *(void **)((u8 *)NEWGRID_HeaderRastPortPtr + 4) = &WDISP_BannerGridBitmapStruct;
    _LVOSetDrMd(NEWGRID_HeaderRastPortPtr, 0);
    _LVOSetFont(NEWGRID_HeaderRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_DrawTopBorderLine();

    sample_width = _LVOTextLength(NEWGRID_MainRastPortPtr, &Global_STR_44_44_44, 8);
    NEWGRID_SampleTimeTextWidthPx = (u16)sample_width;

    col_start = sample_width + 12;
    NEWGRID_ColumnStartXPx = (u16)col_start;

    NEWGRID_ColumnWidthPx = (u16)NEWGRID_JMPTBL_MATH_DivS32(624 - col_start, 3);

    row_h = ((((s32)*(u16 *)((u8 *)*(void **)((u8 *)NEWGRID_MainRastPortPtr + 52) + 20)) - 1) * 2) + 8;
    NEWGRID_RowHeightPx = (u16)row_h;

    (void)NEWGRID_JMPTBL_MATH_DivS32(row_h, 2);
    if ((row_h & 1) != 0) {
        NEWGRID_RowHeightPx = (u16)(row_h - 1);
    }

    NEWGRID_DrawTopBorderLine();
}
