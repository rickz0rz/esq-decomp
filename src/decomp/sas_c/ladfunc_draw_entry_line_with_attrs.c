typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ED_TextLimit;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern const char Global_STR_SINGLE_SPACE_1[];
extern const char Global_STR_LADFUNC_C_14[];
extern const char Global_STR_LADFUNC_C_15[];

extern LONG _LVOTextLength(void *graphicsBase, void *rastPort, const char *text, LONG length);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG n, LONG d);
extern void *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void LADFUNC_DisplayTextPackedPens(void *rastPort, LONG x, LONG y, UBYTE packedPens, const char *text);

void LADFUNC_DrawEntryLineWithAttrs(
    void *rastPort,
    LONG row,
    UBYTE *attrText,
    char *lineText
)
{
    const LONG PREVIEW_PIXEL_WIDTH = 624;
    const LONG PREVIEW_MAX_COLS = 40;
    const LONG SEGBUF_ALLOC_LINE = 712;
    const LONG SEGBUF_FREE_LINE = 824;
    const LONG SEGBUF_ALLOC_FLAGS = 0x10001;
    const LONG ROW_HEIGHT_PIXELS = 8;
    const UBYTE SPACE_CHAR = 32;
    const UBYTE CH_NUL = 0;
    LONG charWidth;
    LONG cols;
    LONG textLen = 0;
    LONG remain;
    LONG x;
    LONG y;
    UBYTE leadCtrl = 0;
    UBYTE leadAttr = 0;
    char *segBuf;

    charWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_STR_SINGLE_SPACE_1, 1);
    cols = NEWGRID_JMPTBL_MATH_DivS32(PREVIEW_PIXEL_WIDTH, charWidth);
    if (cols > PREVIEW_MAX_COLS) {
        cols = PREVIEW_MAX_COLS;
    }

    segBuf = (char *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_14, SEGBUF_ALLOC_LINE, cols + 1, SEGBUF_ALLOC_FLAGS);
    if (segBuf == (char *)0) {
        return;
    }

    if (lineText[0] == 24 || lineText[0] == 25 || lineText[0] == 26) {
        leadCtrl = lineText[0];
        leadAttr = attrText[0];
        ++lineText;
        ++attrText;
    }

    while (lineText[textLen] != 0) {
        ++textLen;
    }
    if (textLen > cols) {
        textLen = cols;
    }

    remain = cols - textLen;
    x = 0;
    y = NEWGRID_JMPTBL_MATH_Mulu32(row + 1, ROW_HEIGHT_PIXELS);
    if (leadCtrl == 24) {
        LONG indent = NEWGRID_JMPTBL_MATH_DivS32(remain, 2);
        LONG i;
        for (i = 0; i < indent; ++i) {
            segBuf[i] = SPACE_CHAR;
        }
        segBuf[indent] = CH_NUL;
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
        x += NEWGRID_JMPTBL_MATH_Mulu32(indent, charWidth);
        remain -= indent;
    } else if (leadCtrl == 26) {
        LONG indent = NEWGRID_JMPTBL_MATH_DivS32(remain, 1);
        LONG i;
        for (i = 0; i < indent; ++i) {
            segBuf[i] = SPACE_CHAR;
        }
        segBuf[indent] = CH_NUL;
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
        x += NEWGRID_JMPTBL_MATH_Mulu32(indent, charWidth);
        remain -= indent;
    }

    {
        LONG start = 0;
        while (start < textLen) {
            LONG end = start;
            UBYTE packed = attrText[start];
            while (end < textLen && attrText[end] == packed) {
                segBuf[end - start] = lineText[end];
                ++end;
            }
            segBuf[end - start] = CH_NUL;
            LADFUNC_DisplayTextPackedPens(rastPort, x, y, packed, segBuf);
            x += NEWGRID_JMPTBL_MATH_Mulu32(end - start, charWidth);
            start = end;
        }
    }

    if (remain > 0) {
        LONG i;
        for (i = 0; i < remain; ++i) {
            segBuf[i] = SPACE_CHAR;
        }
        segBuf[remain] = CH_NUL;
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_15, SEGBUF_FREE_LINE, segBuf, cols + 1);
}
