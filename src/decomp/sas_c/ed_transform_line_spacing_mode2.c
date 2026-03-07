typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ED_ViewportOffset;
extern LONG ED_EditCursorOffset;
extern UBYTE ED_EditBufferScratch[];
extern UBYTE ED_EditBufferLive[];

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG value, LONG scale);
extern void ESQFUNC_JMPTBL_STRING_CopyPadNul(UBYTE *dst, const UBYTE *src, LONG count);

void ED_TransformLineSpacing_Mode2(void)
{
    UBYTE lineText[40];
    UBYTE lineAttrs[40];
    LONG base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
    LONG i;
    LONG right = 0;
    LONG left = 0;
    UBYTE fill = ED_EditBufferLive[ED_EditCursorOffset];

    ESQFUNC_JMPTBL_STRING_CopyPadNul(lineText, &ED_EditBufferScratch[base], 40);

    for (i = 0; i < 40; ++i) {
        lineAttrs[i] = ED_EditBufferLive[base + i];
    }

    while (right < 40 && lineText[39 - right] == ' ') {
        lineAttrs[39 - right] = fill;
        ++right;
    }

    while (left < 40 && lineText[left] == ' ') {
        lineAttrs[left] = fill;
        ++left;
    }

    if (right >= 40) {
        return;
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40) + right;
    for (i = 0; i < (40 - right); ++i) {
        ED_EditBufferScratch[base + i] = lineText[i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40) + right;
    for (i = 0; i < (40 - right); ++i) {
        ED_EditBufferLive[base + i] = lineAttrs[i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
    for (i = 0; i < right; ++i) {
        ED_EditBufferScratch[base + i] = lineText[(40 - right) + i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
    for (i = 0; i < right; ++i) {
        ED_EditBufferLive[base + i] = lineAttrs[(40 - right) + i];
    }
}
