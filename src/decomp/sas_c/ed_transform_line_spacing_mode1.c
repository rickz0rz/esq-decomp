typedef signed long LONG;
typedef unsigned char UBYTE;

extern LONG ED_ViewportOffset;
extern LONG ED_EditCursorOffset;
extern UBYTE ED_EditBufferScratch[];
extern UBYTE ED_EditBufferLive[];
extern UBYTE ED_LineTransformSuffixScratchBuffer[];
extern UBYTE ED_LineTransformTailScratchBuffer[];

extern LONG ESQIFF_JMPTBL_MATH_Mulu32(LONG value, LONG scale);
extern void ESQFUNC_JMPTBL_STRING_CopyPadNul(UBYTE *dst, const UBYTE *src, LONG count);

void ED_TransformLineSpacing_Mode1(void)
{
    UBYTE lineText[40];
    UBYTE lineAttrs[40];
    LONG base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
    LONG i;
    LONG lead = 0;
    LONG trail = 0;
    UBYTE fill = ED_EditBufferLive[ED_EditCursorOffset];

    ESQFUNC_JMPTBL_STRING_CopyPadNul(lineText, &ED_EditBufferScratch[base], 40);

    for (i = 0; i < 40; ++i) {
        lineAttrs[i] = ED_EditBufferLive[base + i];
    }

    while (lead < 40 && lineText[lead] == ' ') {
        lineAttrs[lead] = fill;
        ++lead;
    }

    while (trail < 40 && lineText[39 - trail] == ' ') {
        lineAttrs[39 - trail] = fill;
        ++trail;
    }

    if (lead >= 40) {
        return;
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
    for (i = 0; i < (40 - lead); ++i) {
        ED_EditBufferScratch[base + i] = lineText[lead + i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40);
    for (i = 0; i < (40 - lead); ++i) {
        ED_EditBufferLive[base + i] = lineAttrs[lead + i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40) - lead;
    for (i = 0; i < lead; ++i) {
        ED_LineTransformSuffixScratchBuffer[base + i] = lineText[i];
    }

    base = ESQIFF_JMPTBL_MATH_Mulu32(ED_ViewportOffset, 40) - lead;
    for (i = 0; i < lead; ++i) {
        ED_LineTransformTailScratchBuffer[base + i] = lineAttrs[i];
    }
}
