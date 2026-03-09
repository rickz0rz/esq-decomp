typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ED_ViewportOffset;
extern LONG ED_EditCursorOffset;
extern char ED_EditBufferScratch[];
extern UBYTE ED_EditBufferLive[];

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG value, LONG scale);
extern void ESQFUNC_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, LONG count);

void ED_TransformLineSpacing_Mode2(void)
{
    const LONG LINE_WIDTH = 40;
    const LONG SPACE_CHAR = ' ';
    const LONG ONE = 1;
    const LONG ZERO = 0;
    char lineText[40];
    UBYTE lineAttrs[40];
    LONG base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH);
    LONG i;
    LONG right = 0;
    LONG left = 0;
    UBYTE fill = ED_EditBufferLive[ED_EditCursorOffset];

    ESQFUNC_JMPTBL_STRING_CopyPadNul(lineText, &ED_EditBufferScratch[base], LINE_WIDTH);

    for (i = ZERO; i < LINE_WIDTH; ++i) {
        lineAttrs[i] = ED_EditBufferLive[base + i];
    }

    while (right < LINE_WIDTH && lineText[(LINE_WIDTH - ONE) - right] == SPACE_CHAR) {
        lineAttrs[(LINE_WIDTH - ONE) - right] = fill;
        ++right;
    }

    while (left < LINE_WIDTH && lineText[left] == SPACE_CHAR) {
        lineAttrs[left] = fill;
        ++left;
    }

    if (right >= LINE_WIDTH) {
        return;
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH) + right;
    for (i = ZERO; i < (LINE_WIDTH - right); ++i) {
        ED_EditBufferScratch[base + i] = lineText[i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH) + right;
    for (i = ZERO; i < (LINE_WIDTH - right); ++i) {
        ED_EditBufferLive[base + i] = lineAttrs[i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH);
    for (i = ZERO; i < right; ++i) {
        ED_EditBufferScratch[base + i] = lineText[(LINE_WIDTH - right) + i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH);
    for (i = ZERO; i < right; ++i) {
        ED_EditBufferLive[base + i] = lineAttrs[(LINE_WIDTH - right) + i];
    }
}
