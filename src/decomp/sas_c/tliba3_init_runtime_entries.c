typedef signed long LONG;
typedef signed short WORD;

enum {
    GRAPHICS_WORD_OFFSET = 206,
    RUNTIME_DIW_MASK = 2,
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

void TLIBA3_InitRuntimeEntries(void)
{
    LONG d7;
    LONG d1;
    WORD gfxWord;

    gfxWord = *(WORD *)((char *)Global_REF_GRAPHICS_LIBRARY + GRAPHICS_WORD_OFFSET);
    d7 = (LONG)gfxWord;
    d7 &= RUNTIME_DIW_MASK;

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(0, d1, 352, 240, 360, 0, 4);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(1, d1, 352, 240, 16, 0, 4);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(2, d1, 696, 240, 8, 0, 4);

    d1 = (LONG)(WORD)(d7 + REGBASE_8304);
    TLIBA3_InitRuntimeEntry(3, d1, 696, 240, 0, 0, 1);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(4, d1, 640, 240, 44, 0, 4);

    d1 = (LONG)(WORD)(d7 + REGBASE_4304);
    TLIBA3_InitRuntimeEntry(5, d1, 320, 240, 44, 0, 5);

    d1 = (LONG)(WORD)(d7 + REGBASE_C300);
    TLIBA3_InitRuntimeEntry(6, d1, 640, 120, 44, 0, 4);

    d1 = (LONG)(WORD)(d7 + REGBASE_4300);
    TLIBA3_InitRuntimeEntry(7, d1, 320, 120, 44, 0, 5);

    d1 = (LONG)(WORD)(d7 + REGBASE_C304);
    TLIBA3_InitRuntimeEntry(8, d1, 320, 296, 16, 0, 4);
}
