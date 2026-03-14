#include <exec/types.h>
enum {
    GRAPHICS_WORD_OFFSET = 206,
    RUNTIME_DIW_MASK = 2,
    VM_X_0 = 0,
    VM_X_8 = 8,
    VM_X_16 = 16,
    VM_X_44 = 44,
    VM_X_360 = 360,
    VM_WIDTH_320 = 320,
    VM_WIDTH_352 = 352,
    VM_WIDTH_640 = 640,
    VM_WIDTH_696 = 696,
    VM_HEIGHT_120 = 120,
    VM_HEIGHT_240 = 240,
    VM_HEIGHT_296 = 296,
    VM_DEPTH_1 = 1,
    VM_DEPTH_4 = 4,
    VM_DEPTH_5 = 5,
    REGBASE_C304 = 0xC304,
    REGBASE_8304 = 0x8304,
    REGBASE_4304 = 0x4304,
    REGBASE_C300 = 0xC300,
    REGBASE_4300 = 0x4300
};

extern void *Global_REF_GRAPHICS_LIBRARY;

extern void TLIBA3_InitRuntimeEntry(
    LONG idx,
    LONG regBase,
    LONG width,
    LONG height,
    LONG x,
    LONG y,
    LONG depth);

typedef struct TLIBA3_GraphicsLibraryView {
    char pad0[GRAPHICS_WORD_OFFSET];
    WORD diwWord206;
} TLIBA3_GraphicsLibraryView;

void TLIBA3_InitRuntimeEntries(void)
{
    LONG d7;
    LONG d1;
    WORD gfxWord;

    gfxWord = ((TLIBA3_GraphicsLibraryView *)Global_REF_GRAPHICS_LIBRARY)->diwWord206;
    d7 = (LONG)gfxWord;
    d7 &= RUNTIME_DIW_MASK;

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(0, d1, VM_WIDTH_352, VM_HEIGHT_240, VM_X_360, 0, VM_DEPTH_4);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(1, d1, VM_WIDTH_352, VM_HEIGHT_240, VM_X_16, 0, VM_DEPTH_4);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(2, d1, VM_WIDTH_696, VM_HEIGHT_240, VM_X_8, 0, VM_DEPTH_4);

    d1 = (LONG)(WORD)(d7 + REGBASE_8304);
    TLIBA3_InitRuntimeEntry(3, d1, VM_WIDTH_696, VM_HEIGHT_240, VM_X_0, 0, VM_DEPTH_1);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(4, d1, VM_WIDTH_640, VM_HEIGHT_240, VM_X_44, 0, VM_DEPTH_4);

    d1 = (LONG)(WORD)(d7 + REGBASE_4304);
    TLIBA3_InitRuntimeEntry(5, d1, VM_WIDTH_320, VM_HEIGHT_240, VM_X_44, 0, VM_DEPTH_5);

    d1 = (LONG)(WORD)(d7 + REGBASE_C300);
    TLIBA3_InitRuntimeEntry(6, d1, VM_WIDTH_640, VM_HEIGHT_120, VM_X_44, 0, VM_DEPTH_4);

    d1 = (LONG)(WORD)(d7 + REGBASE_4300);
    TLIBA3_InitRuntimeEntry(7, d1, VM_WIDTH_320, VM_HEIGHT_120, VM_X_44, 0, VM_DEPTH_5);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(8, d1, VM_WIDTH_320, VM_HEIGHT_296, VM_X_16, 0, VM_DEPTH_4);
}
