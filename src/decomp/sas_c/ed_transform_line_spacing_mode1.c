typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern LONG ED_ViewportOffset;
extern LONG ED_EditCursorOffset;
extern char ED_EditBufferScratch[];
extern UBYTE ED_EditBufferLive[];
extern UBYTE ED_LineTransformSuffixScratchBuffer[];
extern UBYTE ED_LineTransformTailScratchBuffer[];

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG value, LONG scale);
extern char *ESQFUNC_JMPTBL_STRING_CopyPadNul(char *dst, const char *src, ULONG count);

void ED_TransformLineSpacing_Mode1(void)
{
    const LONG LINE_WIDTH = 40;
    const LONG SPACE_CHAR = ' ';
    const LONG ONE = 1;
    const LONG ZERO = 0;
    char lineText[40];
    UBYTE lineAttrs[40];
    LONG base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH);
    LONG i;
    LONG lead = 0;
    LONG trail = 0;
    UBYTE fill = ED_EditBufferLive[ED_EditCursorOffset];

    ESQFUNC_JMPTBL_STRING_CopyPadNul(lineText, &ED_EditBufferScratch[base], LINE_WIDTH);

    for (i = ZERO; i < LINE_WIDTH; ++i) {
        lineAttrs[i] = ED_EditBufferLive[base + i];
    }

    while (lead < LINE_WIDTH && lineText[lead] == SPACE_CHAR) {
        lineAttrs[lead] = fill;
        ++lead;
    }

    while (trail < LINE_WIDTH && lineText[(LINE_WIDTH - ONE) - trail] == SPACE_CHAR) {
        lineAttrs[(LINE_WIDTH - ONE) - trail] = fill;
        ++trail;
    }

    if (lead >= LINE_WIDTH) {
        return;
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH);
    for (i = ZERO; i < (LINE_WIDTH - lead); ++i) {
        ED_EditBufferScratch[base + i] = lineText[lead + i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH);
    for (i = ZERO; i < (LINE_WIDTH - lead); ++i) {
        ED_EditBufferLive[base + i] = lineAttrs[lead + i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH) - lead;
    for (i = ZERO; i < lead; ++i) {
        ED_LineTransformSuffixScratchBuffer[base + i] = lineText[i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, LINE_WIDTH) - lead;
    for (i = ZERO; i < lead; ++i) {
        ED_LineTransformTailScratchBuffer[base + i] = lineAttrs[i];
    }
}
