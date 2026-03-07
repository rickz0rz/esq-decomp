typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct LadfuncEntry {
    UWORD startSlot;
    UWORD endSlot;
    UWORD isHighlighted;
    UBYTE *textPtr;
    UBYTE *attrPtr;
} LadfuncEntry;

extern LONG ED_TextLimit;
extern LONG WDISP_DisplayContextBase;
extern UWORD WDISP_AccumulatorFlushPending;

extern UBYTE WDISP_PaletteTriplesRBase;
extern UBYTE WDISP_PaletteTriplesGBase;
extern UBYTE WDISP_PaletteTriplesBBase;
extern UBYTE KYBD_CustomPaletteTriplesRBase[];
extern UBYTE KYBD_CustomPaletteTriplesGBase[];
extern UBYTE KYBD_CustomPaletteTriplesBBase[];

extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_H26F_FONT;
extern void *Global_HANDLE_PREVUEC_FONT;

extern const char Global_STR_SINGLE_SPACE_2[];
extern const char Global_STR_LADFUNC_C_16[];
extern const char Global_STR_LADFUNC_C_17[];
extern const char Global_STR_LADFUNC_C_18[];
extern const char Global_STR_LADFUNC_C_19[];

extern LadfuncEntry *LADFUNC_EntryPtrTable[];

extern LONG GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(LONG a, LONG b, LONG c);
extern void _LVOSetFont(void *graphicsBase, void *rastPort, void *font);
extern LONG _LVOTextLength(void *graphicsBase, void *rastPort, const char *text, LONG length);
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG n, LONG d);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void _LVOSetDrMd(void *graphicsBase, void *rastPort, LONG drawMode);
extern void _LVOSetRast(void *graphicsBase, void *rastPort, LONG pen);
extern void GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition(void);
extern void GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition(void);
extern LONG LADFUNC_GetPackedPenHighNibble(UBYTE packed);
extern void LADFUNC_DrawEntryLineWithAttrs(void *rastPort, LONG row, UBYTE *attrBuf, UBYTE *textBuf);

void LADFUNC_DrawEntryPreview(LONG entryIndex)
{
    LadfuncEntry *entry;
    UBYTE *lineText = (UBYTE *)0;
    UBYTE *lineAttr = (UBYTE *)0;
    LONG charWidth;
    LONG maxCols;
    LONG row;
    LONG textLen = 0;
    UBYTE packed;
    LONG pen;
    LONG i;
    void *rastPort;

    WDISP_DisplayContextBase = GROUP_AW_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(4, 0, 3);
    rastPort = (void *)(WDISP_DisplayContextBase + 2);

    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_HANDLE_H26F_FONT);
    charWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_STR_SINGLE_SPACE_2, 1);
    maxCols = NEWGRID_JMPTBL_MATH_DivS32(624, charWidth);

    lineText = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(Global_STR_LADFUNC_C_16, 857, maxCols + 1, 0x10001);
    lineAttr = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(Global_STR_LADFUNC_C_17, 858, maxCols, 0x10001);
    if (lineText == (UBYTE *)0 || lineAttr == (UBYTE *)0) {
        goto cleanup;
    }

    entry = LADFUNC_EntryPtrTable[entryIndex];
    WDISP_AccumulatorFlushPending = 0;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
    GROUP_AW_JMPTBL_ESQIFF_RunCopperDropTransition();

    for (i = 0; i < 24; ++i) {
        (&WDISP_PaletteTriplesRBase)[i] = KYBD_CustomPaletteTriplesRBase[i];
    }

    while (entry->textPtr[textLen] != 0) {
        ++textLen;
    }

    packed = entry->attrPtr[0];
    pen = LADFUNC_GetPackedPenHighNibble(packed);
    WDISP_PaletteTriplesRBase = KYBD_CustomPaletteTriplesRBase[pen * 3];
    WDISP_PaletteTriplesGBase = KYBD_CustomPaletteTriplesGBase[pen * 3];
    WDISP_PaletteTriplesBBase = KYBD_CustomPaletteTriplesBBase[pen * 3];
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, rastPort, pen);

    for (row = 0; row < ED_TextLimit; ++row) {
        LONG col = 0;
        LONG src = row * 40;
        while (col < maxCols && src < textLen && entry->textPtr[src] != 0) {
            lineText[col] = entry->textPtr[src];
            lineAttr[col] = entry->attrPtr[src];
            ++col;
            ++src;
        }
        lineText[col] = 0;
        LADFUNC_DrawEntryLineWithAttrs(rastPort, row, lineAttr, lineText);
    }

    GROUP_AW_JMPTBL_ESQIFF_RunCopperRiseTransition();

cleanup:
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_HANDLE_PREVUEC_FONT);

    if (lineText != (UBYTE *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_18, 926, lineText, maxCols + 1);
    }
    if (lineAttr != (UBYTE *)0) {
        NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_19, 928, lineAttr, maxCols);
    }
}
