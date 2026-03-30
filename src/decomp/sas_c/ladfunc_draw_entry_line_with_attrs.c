#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>

extern LONG ED_TextLimit;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern const char Global_STR_SINGLE_SPACE_1[];
extern const char Global_STR_LADFUNC_C_14[];
extern const char Global_STR_LADFUNC_C_15[];

extern LONG _LVOTextLength(void *graphicsBase, struct RastPort *rastPort, const char *text, LONG length);
extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern LONG NEWGRID_JMPTBL_MATH_DivS32(LONG n, LONG d);
extern char *NEWGRID_JMPTBL_MEMORY_AllocateMemory(const char *file, LONG line, LONG size, LONG flags);
extern void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
extern void LADFUNC_DisplayTextPackedPens(struct RastPort *rastPort, LONG x, LONG y, UBYTE packedPens, const char *text);

static LONG asr1_round_toward_zero(LONG value)
{
    if (value < 0) {
        value += 1;
    }
    return value >> 1;
}

void LADFUNC_DrawEntryLineWithAttrs(
    struct RastPort *rastPort,
    LONG row,
    char *lineText,
    UBYTE *attrText
)
{
    const LONG PREVIEW_PIXEL_WIDTH = 624;
    const LONG PREVIEW_MAX_COLS = 40;
    const LONG SEGBUF_ALLOC_LINE = 712;
    const LONG SEGBUF_FREE_LINE = 824;
    const LONG SEGBUF_ALLOC_FLAGS = 0x10001;
    const UBYTE CTRL_CENTER = 24;
    const UBYTE CTRL_KEEP = 25;
    const UBYTE CTRL_RIGHT = 26;
    const UBYTE CH_SPACE = 32;
    LONG charWidth;
    LONG cols;
    LONG textLen;
    LONG remain;
    LONG x;
    LONG y;
    UBYTE leadCtrl;
    UBYTE leadAttr;
    char *segBuf;

    leadCtrl = 0;
    leadAttr = 0;

    charWidth = _LVOTextLength(Global_REF_GRAPHICS_LIBRARY, rastPort, Global_STR_SINGLE_SPACE_1, 1);
    cols = NEWGRID_JMPTBL_MATH_DivS32(PREVIEW_PIXEL_WIDTH, charWidth);
    if (cols > PREVIEW_MAX_COLS) {
        cols = PREVIEW_MAX_COLS;
    }

    segBuf = NEWGRID_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_LADFUNC_C_14,
        SEGBUF_ALLOC_LINE,
        cols + 1,
        SEGBUF_ALLOC_FLAGS);
    if (segBuf == 0) {
        return;
    }

    if (lineText[0] == CTRL_CENTER || lineText[0] == CTRL_KEEP || lineText[0] == CTRL_RIGHT) {
        leadCtrl = (UBYTE)lineText[0];
        leadAttr = attrText[0];
        lineText++;
        attrText++;
    }

    textLen = 0;
    while (lineText[textLen] != '\0') {
        textLen++;
    }
    if (textLen > cols) {
        textLen = cols;
    }

    remain = cols - textLen;
    if (remain > 0 && leadCtrl == 0) {
        leadAttr = attrText[textLen];
    }

    x = asr1_round_toward_zero(
        (((LONG)(UWORD)rastPort->BitMap->BytesPerRow) << 3)
        - NEWGRID_JMPTBL_MATH_Mulu32(charWidth, textLen));
    y = asr1_round_toward_zero(
        ((LONG)(WORD)rastPort->BitMap->Rows)
        - NEWGRID_JMPTBL_MATH_Mulu32((LONG)(UWORD)rastPort->Font->tf_YSize, ED_TextLimit));
    y += NEWGRID_JMPTBL_MATH_Mulu32(row + 1, (LONG)(UWORD)rastPort->Font->tf_YSize);

    if (x < 0) {
        x = 0;
    }
    if (y < 0) {
        y = 0;
    }

    if (leadCtrl == CTRL_CENTER && remain > 0) {
        LONG indent;
        LONG i;

        indent = NEWGRID_JMPTBL_MATH_DivS32(remain, 2);
        for (i = 0; i < indent; ++i) {
            segBuf[i] = CH_SPACE;
        }
        segBuf[indent] = '\0';
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
        x += NEWGRID_JMPTBL_MATH_Mulu32(indent, charWidth);
        remain -= indent;
    } else if (leadCtrl == CTRL_RIGHT && remain > 0) {
        LONG indent;
        LONG i;

        indent = NEWGRID_JMPTBL_MATH_DivS32(remain, 1);
        for (i = 0; i < indent; ++i) {
            segBuf[i] = CH_SPACE;
        }
        segBuf[indent] = '\0';
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
        x += NEWGRID_JMPTBL_MATH_Mulu32(indent, charWidth);
        remain -= indent;
    }

    {
        LONG start;

        start = 0;
        while (start < textLen) {
            LONG segLen;
            UBYTE packed;

            segLen = 0;
            packed = attrText[start];
            while ((start + segLen) < textLen && attrText[start + segLen] == packed) {
                segBuf[segLen] = lineText[start + segLen];
                segLen++;
            }

            segBuf[segLen] = '\0';
            LADFUNC_DisplayTextPackedPens(rastPort, x, y, packed, segBuf);
            x += NEWGRID_JMPTBL_MATH_Mulu32(charWidth, segLen);
            start += segLen;
        }
    }

    if (remain > 0) {
        LONG i;

        for (i = 0; i < remain; ++i) {
            segBuf[i] = CH_SPACE;
        }
        segBuf[remain] = '\0';
        LADFUNC_DisplayTextPackedPens(rastPort, x, y, leadAttr, segBuf);
    }

    NEWGRID_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_LADFUNC_C_15,
        SEGBUF_FREE_LINE,
        segBuf,
        cols + 1);
}
