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
extern void LADFUNC_DisplayTextPackedPens(void *rastPort, LONG x, LONG y, UBYTE packedPens, const UBYTE *text);

void LADFUNC_DrawEntryLineWithAttrs(
    void *rastPort,
    LONG row,
    UBYTE *attrText,
    UBYTE *lineText
)
{
    LONG charWidth;
    LONG cols;
    LONG textLen = 0;
    LONG remain;
    LONG x;
    LONG y;
    UBYTE leadCtrl = 0;
    UBYTE leadAttr = 0;
    UBYTE *segBuf;

    charWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_STR_SINGLE_SPACE_1, 1);
    cols = NEWGRID_JMPTBL_MATH_DivS32(624, charWidth);
    if (cols > 40) {
        cols = 40;
    }

    segBuf = (UBYTE *)NEWGRID_JMPTBL_MEMORY_AllocateMemory(Global_STR_LADFUNC_C_14, 712, cols + 1, 0x10001);
    if (segBuf == (UBYTE *)0) {
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
    y = NEWGRID_JMPTBL_MATH_Mulu32(row + 1, 8);
    if (leadCtrl == 24) {
        LONG indent = NEWGRID_JMPTBL_MATH_DivS32(remain, 2);
        LONG i;
        for (i = 0; i < indent; ++i) {
            segBuf[i] = 32;
        }
        segBuf[indent] = 0;
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
        x += NEWGRID_JMPTBL_MATH_Mulu32(indent, charWidth);
        remain -= indent;
    } else if (leadCtrl == 26) {
        LONG indent = NEWGRID_JMPTBL_MATH_DivS32(remain, 1);
        LONG i;
        for (i = 0; i < indent; ++i) {
            segBuf[i] = 32;
        }
        segBuf[indent] = 0;
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
            segBuf[end - start] = 0;
            LADFUNC_DisplayTextPackedPens(rastPort, x, y, packed, segBuf);
            x += NEWGRID_JMPTBL_MATH_Mulu32(end - start, charWidth);
            start = end;
        }
    }

    if (remain > 0) {
        LONG i;
        for (i = 0; i < remain; ++i) {
            segBuf[i] = 32;
        }
        segBuf[remain] = 0;
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(Global_STR_LADFUNC_C_15, 824, segBuf, cols + 1);
}
